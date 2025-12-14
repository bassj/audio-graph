@tool
extends AudioGraphNode
class_name Gain

@export var gain: float = 1.0

const INPUT_AUDIO := 0;
const INPUT_GAIN  := 1;

func sample(p_output_index: int, time_scale: float = 1.0) -> float:
    assert(p_output_index == 0, "Gain node only has one output (index 0)")

    var audio_in = _sample_input(inputs.get(INPUT_AUDIO, {}), time_scale)
    var gain_in  = gain
    if inputs.has(INPUT_GAIN):
        gain_in = _sample_input(inputs.get(INPUT_GAIN, {}), time_scale)

    return audio_in * gain_in