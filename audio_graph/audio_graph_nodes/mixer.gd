@tool
extends AudioGraphNode
class_name Mixer

@export var inputs: Array[AudioGraphNode] = []

func set_input(index: int, input: AudioGraphNode) -> bool:
	if _has_circular_connection(input):
		return false

	if index >= inputs.size():
		inputs.resize(index + 1)
	inputs[index] = input

	if audio_graph and input != null:
		audio_graph.graph_branch_added.emit(input)

	return true

func get_leaf_nodes() -> Array[AudioGraphNode]:
	return inputs.filter(func (input): return input != null)

func sample() -> float:
	var value = 0.0
	for input in inputs:
		if input == null:
			continue
		value += input.sample()
	return value
