@tool
extends AudioGraphNode
class_name Gain

@export var gain: float = 1.0

func sample(p_output_index: int, time_scale: float = 1.0) -> float:
    assert(p_output_index == 0, "Gain node only has one output (index 0)")

    var input = inputs.get(0, {})
    var input_node = input.get("node", null)
    var output_index = input.get("output_index", 0)

    if input_node == null:
        return 0.0

    return input_node.sample(output_index, time_scale) * gain