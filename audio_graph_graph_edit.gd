extends GraphEdit

const AudioFunctionGenerator: PackedScene = preload("res://audio_graph_nodes/audio_function_generator.tscn");

var popup_menu: PopupMenu

func _ready() -> void:
	popup_menu = PopupMenu.new()
	popup_menu.add_item("Add Function Generator")
	popup_menu.id_pressed.connect(_on_popup_menu_id_pressed)
	add_child(popup_menu)

	popup_request.connect(func (at_position):
		popup_menu.set_position(at_position)
		popup_menu.show()
	)

	delete_nodes_request.connect(func (nodes: Array):
		for node in nodes:
			var child = get_node(NodePath(node))
			if child and child.get("can_be_deleted"):
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

		connect_node(from_node, from_port, to_node, to_port)
	)

	disconnection_request.connect(func(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
		disconnect_node(from_node, from_port, to_node, to_port)
	)

func _on_popup_menu_id_pressed(id: int) -> void:
	match id:
		0:
			_add_function_generator()

func _add_function_generator() -> void:
	var instance = AudioFunctionGenerator.instantiate()
	add_child(instance)
	instance.set_position(get_local_mouse_position())

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
