@tool
extends AudioGraphNode
class_name Delay

@export_custom(PROPERTY_HINT_NONE, "suffix:seconds")
var delay_buffer_size: int = 4410 :
	set(p_buffer_size):
		delay_buffer_size = p_buffer_size
		_resize_buffer()

var _buffer := PackedFloat32Array()
var _buffer_pointer: int = 0

func _resize_buffer() -> void:
	_buffer.resize(delay_buffer_size)
	_buffer.fill(0.0)
	_buffer_pointer = _buffer_pointer % delay_buffer_size

func _init(p_buffer_size = 4410) -> void:
	delay_buffer_size = p_buffer_size
	_resize_buffer()

func sample(output_index: int, time_scale: float = 1.0) -> float:
	assert(output_index == 0, "Delay node only has one output (index 0)")

	var val := 0.0
	var input = inputs.get(0)

	if input != null:
		val = input["node"].sample(input["output_index"], time_scale)
	_buffer[_buffer_pointer] = val

	var sample_pointer = (_buffer_pointer + 1) % delay_buffer_size
	val = _buffer[sample_pointer]
	_buffer_pointer = sample_pointer

	return val
