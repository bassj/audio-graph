extends GraphEdit

const BaseNode = preload("res://audio_graph/graph_edit_nodes/base_node.gd");
const MonoOutputNode = preload("res://audio_graph/graph_edit_nodes/mono_output_node.gd");

const AudioFunctionGenerator: PackedScene = preload("res://audio_graph/graph_edit_nodes/audio_function_generator.tscn");
const Mix2: PackedScene = preload("res://audio_graph/graph_edit_nodes/mixer_nodes/mix2_node.tscn");

@export var audio_graph: AudioGraph

@onready var output_graph_node : MonoOutputNode = $MonoOutput

var _node_types = {
	"Generator": AudioFunctionGenerator,
	"Mix": {
		"Mix2": Mix2,
	}
}

var context_menu: PopupMenu

func _ready() -> void:
	assert(audio_graph != null, "AudioGraphGraphEdit has no AudioGraph assigned to it.")
	_init_output_node()
	_init_context_menu()
	_init_connection_handlers()

func _on_context_menu_id_pressed(p_context_menu: PopupMenu) -> Callable:
	return func (id: int):
		var value = p_context_menu.get_item_metadata(id)
		var instance = value.instantiate()
		add_child(instance)
		instance.position_offset = get_local_mouse_position() + scroll_offset

func _add_context_menu_item(p_context_menu: PopupMenu, label: String, value: Variant) -> void:
	if value is Dictionary:
		var submenu_name = label + "Menu"
		var submenu = PopupMenu.new()
		submenu.id_pressed.connect(_on_context_menu_id_pressed(submenu))
		submenu.name = submenu_name
		for sublabel in value.keys():
			_add_context_menu_item(submenu, sublabel, value[sublabel])
		p_context_menu.add_child(submenu)
		p_context_menu.add_submenu_item(label, submenu_name)
	else:
		var id = p_context_menu.get_item_count()
		p_context_menu.add_item(label, id)
		p_context_menu.set_item_metadata(id, value)


func _init_context_menu() -> void:
	context_menu = PopupMenu.new()
	context_menu.id_pressed.connect(_on_context_menu_id_pressed(context_menu))

	for label in _node_types.keys():
		var value = _node_types[label]
		_add_context_menu_item(context_menu, label, value)

	add_child(context_menu)

	popup_request.connect(func (at_position):
		context_menu.set_position(at_position)
		context_menu.show()
	)

func _init_output_node() -> void:
	output_graph_node.set_audio_graph(audio_graph)

	output_graph_node.input_changed.connect(func (new_input: AudioGraphNode):
		audio_graph.graph_root = new_input
	)

func _init_connection_handlers() -> void:
	delete_nodes_request.connect(func (nodes: Array):
		for node in nodes:
			var child = get_node(NodePath(node))
			if child and child.get("can_be_deleted"):
				var con_list = get_connection_list_from_node(node)
				for c in con_list:
					var to_node = c["to_node"]
					var to_port = c["to_port"]
					var to_node_ref = get_node(NodePath(to_node)) as BaseNode
					to_node_ref.set_input(to_port, null)
				child.queue_free()
	)

	connection_request.connect(func(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
		var from_node_ref = get_node(NodePath(from_node)) as GraphNode
		var to_node_ref = get_node(NodePath(to_node)) as GraphNode

		if not from_node_ref or not to_node_ref:
			return

		# var from_slot = from_node_ref.get_output_port_slot(from_port)
		var from_type = from_node_ref.get_output_port_type(from_port)
		# var to_slot = to_node_ref.get_input_port_slot(to_port)
		var to_type = to_node_ref.get_input_port_type(to_port)

		if from_type != to_type:
			return

		for c in _get_incoming_connections_with_port(to_node, to_port):
			disconnect_node(c["from_node"], c["from_port"], to_node, to_port)

		to_node_ref.set_input(to_port, from_node_ref.get_output())

		connect_node(from_node, from_port, to_node, to_port)
	)

	disconnection_request.connect(func(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
		var from_node_ref = get_node(NodePath(from_node)) as GraphNode
		var to_node_ref = get_node(NodePath(to_node)) as GraphNode

		if not from_node_ref or not to_node_ref:
			return

		to_node_ref.input = null
		disconnect_node(from_node, from_port, to_node, to_port)
	)

func _get_incoming_connections_with_port(node: StringName, port: int):
	var cons = get_connection_list_from_node(node)
	var result = []

	for c in cons:
		if c["to_node"] != node:
			continue
		if c["to_port"] != port:
			continue

		result.push_back(c)

	return result

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	if not audio_graph:
		warnings.append("AudioGraphGraphEdit has no AudioGraph assigned to it.")
	return warnings
