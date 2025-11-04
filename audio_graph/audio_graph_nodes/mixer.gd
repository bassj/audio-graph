@tool
extends AudioGraphNode
class_name Mixer

func set_input(index: int, input: AudioGraphNode, output_index: int = 0) -> bool:
	if _has_circular_connection(input):
		return false

	inputs[index] = AudioGraphNodeOutput.new(input, output_index)

	if audio_graph and input != null:
		audio_graph.graph_branch_added.emit(input)

	return true

func sample(output_index: int) -> float:
	assert(output_index == 0, "Mixer node only has one output (index 0)")

	var value = 0.0
	for input in inputs.values():
		if input == null:
			continue
		value += input.node.sample(input.output_index)
	return value
