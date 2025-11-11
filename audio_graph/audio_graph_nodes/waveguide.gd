@tool
extends AudioGraphNode
class_name WaveGuide

@export_custom(PROPERTY_HINT_NONE, "suffix:samples")
var waveguide_buffer_size: int = 4410 :
    set(p_buffer_size):
        waveguide_buffer_size = p_buffer_size
        _resize_buffer()

@export
var reflection_forward: float = 1.0

@export
var reflection_backward: float = 1.0


var _forward_buffer := PackedFloat32Array()
var _backward_buffer := PackedFloat32Array()
var _buffer_pointer: int = 0

func _resize_buffer() -> void:
    _forward_buffer.resize(waveguide_buffer_size)
    _backward_buffer.resize(waveguide_buffer_size)
    _forward_buffer.fill(0.0)
    _backward_buffer.fill(0.0)
    _buffer_pointer = _buffer_pointer % waveguide_buffer_size

func _init(p_buffer_size = 4410) -> void:
    waveguide_buffer_size = p_buffer_size
    _resize_buffer()

func sample(output_index: int, time_scale: float = 1.0) -> float:
    assert(output_index == 0, "WaveGuide node only has one output (index 0)")

    var input = inputs.get(0, {})
    var input_node = input.get("node", null)

    var val = 0.0

    if input_node != null:
        val = input_node.sample(input.get("output_index", 0), time_scale)

    var _sample_pointer = (_buffer_pointer + 1) % waveguide_buffer_size
    var forward_sample = _forward_buffer[_sample_pointer]
    var backward_sample = _backward_buffer[_sample_pointer]

    _forward_buffer[_buffer_pointer] = val + backward_sample * reflection_forward
    _backward_buffer[_buffer_pointer] = forward_sample * reflection_backward

    _buffer_pointer = _sample_pointer
    return backward_sample