extends "res://audio_graph/graph_edit_nodes/base_node.gd"

@export var mixer := Mixer.new()

func set_input(index: int, input: AudioGraphNode, output_index: int = 0) -> bool:
	return mixer.set_input(index, input, output_index)

func get_audio_node() -> AudioGraphNode:
	return mixer
