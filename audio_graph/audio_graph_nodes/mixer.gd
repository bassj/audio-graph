@tool
extends AudioGraphNode
class_name Mixer

func sample(output_index: int, time_scale: float = 1.0) -> float:
	assert(output_index == 0, "Mixer node only has one output (index 0)")

	var value = 0.0
	for input in inputs.values():
		if input == null:
			continue
		value += input["node"].sample(input["output_index"], time_scale)
	return value