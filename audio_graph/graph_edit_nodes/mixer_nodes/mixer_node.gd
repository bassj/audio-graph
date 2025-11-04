extends "res://audio_graph/graph_edit_nodes/base_node.gd"

@export var mixer := Mixer.new()

func set_input(index: int, input: AudioGraphNode, output_index: int = 0) -> bool:
	return mixer.set_input(index, input, output_index)

func save_editor_metadata() -> void:
	mixer.set_meta("graph_edit_position", position_offset)

func apply_editor_metadata() -> void:
	var pos = mixer.get_meta("graph_edit_position", null)
	if pos != null:
		position_offset = pos

func set_audio_node(node: AudioGraphNode) -> void:
	assert(node is Mixer, "Node must be of type Mixer.")
	mixer = node


func get_audio_node() -> AudioGraphNode:
	return mixer
