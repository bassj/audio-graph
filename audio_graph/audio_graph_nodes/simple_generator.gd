@tool
extends AudioGraphNode
class_name SimpleGenerator

const FUNCTION_SINE := "sine"
const FUNCTION_SQUARE := "square"
const FUNCTION_SAWTOOTH := "sawtooth"

@export_enum(FUNCTION_SINE, FUNCTION_SQUARE, FUNCTION_SAWTOOTH) var function: String
@export var frequency: float = 440.0
@export var amplitude: float = 1.0
@export var phase_offset: float

var phase := 0.0

func _init(p_function: String = FUNCTION_SINE, p_phase_offset: float = 0.0) -> void:
	function = p_function
	phase_offset = p_phase_offset

func sample(output_index: int, time_scale: float = 1.0) -> float:
	assert(output_index == 0, "SimpleGenerator node only has one output (index 0)")

	var value = sample_at(phase + phase_offset)

	var increment := (time_scale / float(audio_graph.mix_rate))
	phase = fmod(phase + increment, 1.0)

	return value

func sample_at(p_phase: float) -> float:
	var value = 0.0
	if function == "sine":
		value = _sine(p_phase)
	elif function == "square":
		value = _square(p_phase)
	elif function == "sawtooth":
		value = _sawtooth(p_phase)
	return value

func get_leaf_nodes() -> Array[AudioGraphNode]:
	return []

func _sine(p_phase: float) -> float:
	return sin(frequency * TAU * p_phase) * amplitude

func _square(p_phase: float) -> float:
	return sign(_sine(p_phase)) * amplitude

func _sawtooth(p_phase: float) -> float:
	var _phase = p_phase * frequency
	return (2.0 * (_phase - floor(_phase + 0.5))) * amplitude
