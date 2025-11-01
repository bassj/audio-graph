@tool
extends AudioGraphNode
class_name Generator

const FUNCTION_SINE := "sine"
const FUNCTION_SQUARE := "square"
const FUNCTION_SAWTOOTH := "sawtooth"

@export_enum(FUNCTION_SINE, FUNCTION_SQUARE, FUNCTION_SAWTOOTH) var function: String
@export var frequency: float = 440.0
@export var amplitude: float = 1.0
@export var phase: float

func _init(p_function: String = FUNCTION_SINE, p_phase: float = 0.0) -> void:
    function = p_function
    phase = p_phase

func _sine(p_phase: float) -> float:
    return sin(frequency * TAU * p_phase) * amplitude

func _square(p_phase: float) -> float:
    return sign(_sine(p_phase)) * amplitude

func _sawtooth(p_phase: float) -> float:
    var _phase = p_phase * frequency
    return (2.0 * (_phase - floor(_phase + 0.5))) * amplitude

func sample(increment: float) -> float:
    var value = sample_at(phase)
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