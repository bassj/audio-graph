extends "res://audio_graph/graph_edit_nodes/base_node.gd"

@export var mixer := Mixer.new()

func set_input(index: int, input: AudioGraphNode) -> bool:
	return mixer.set_input(index, input)

func get_output() -> AudioGraphNode:
	return mixer
