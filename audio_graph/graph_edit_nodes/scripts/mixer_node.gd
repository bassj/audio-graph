extends "res://audio_graph/graph_edit_nodes/scripts/base_node.gd"

@export var mixer := Mixer.new()

func set_input(index: int, input: AudioGraphNode, output_index: int = 0) -> bool:
	return mixer.set_input(index, input, output_index)

func save_editor_metadata() -> void:
	mixer.set_meta("graph_edit_position", position_offset)

func apply_editor_metadata() -> void:
	if mixer.has_meta("graph_edit_position"):
		position_offset = mixer.get_meta("graph_edit_position")

func set_audio_node(node: AudioGraphNode) -> void:
	assert(node is Mixer, "Node must be of type Mixer.")
	mixer = node


func get_audio_node() -> AudioGraphNode:
	return mixer
