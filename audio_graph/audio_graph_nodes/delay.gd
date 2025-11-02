@tool
extends AudioGraphNode
class_name Delay

@export_custom(PROPERTY_HINT_NONE, "suffix:seconds")
var delay_buffer_size: int = 4410 :
	set(p_buffer_size):
		delay_buffer_size = p_buffer_size
		_resize_buffer()

@export var input: AudioGraphNode

var _buffer := PackedFloat32Array()
var _buffer_pointer: int = 0

func set_input(p_input: AudioGraphNode) -> bool:
	if _has_circular_connection(p_input):
		return false

	input = p_input
	if audio_graph != null and p_input != null:
		audio_graph.graph_branch_added.emit(input)

	return true

func get_leaf_nodes() -> Array[AudioGraphNode]:
	var leaf_nodes := [] as Array[AudioGraphNode]
	if input != null:
		leaf_nodes.append(input)

	return leaf_nodes

func _resize_buffer() -> void:
	_buffer.resize(delay_buffer_size)
	_buffer.fill(0.0)
	_buffer_pointer = _buffer_pointer % delay_buffer_size

func _init(p_buffer_size = 4410) -> void:
	delay_buffer_size = p_buffer_size
	_resize_buffer()

func sample() -> float:
	var val := 0.0
	if input != null:
		val = input.sample()
	_buffer[_buffer_pointer] = val

	var sample_pointer = (_buffer_pointer + 1) % delay_buffer_size
	val = _buffer[sample_pointer]
	_buffer_pointer = sample_pointer

	return val
