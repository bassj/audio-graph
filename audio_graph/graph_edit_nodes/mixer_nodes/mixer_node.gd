extends "res://audio_graph/graph_edit_nodes/base_node.gd"

@export var mixer := Mixer.new()

func set_input(index: int, input: AudioGraphNode) -> void:
	mixer.set_input(index, input)

func get_output() -> AudioGraphNode:
	return mixer
