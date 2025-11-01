extends RefCounted
class_name Delay

var _buffer := PackedFloat32Array()
var _buffer_size: int = 14
var _buffer_pointer: int = 0

func _init(p_buffer_size = 14) -> void:
    _buffer_size = p_buffer_size
    _buffer.resize(_buffer_size)
    _buffer.fill(0.0)

func get_current_sample() -> float:
    var sample_pointer = (_buffer_pointer + 1) % _buffer_size
    return _buffer[sample_pointer]

func add_sample(sample: float) -> void:
    _buffer[_buffer_pointer] = sample
    _buffer_pointer = (_buffer_pointer + 1) % _buffer_size
