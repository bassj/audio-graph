extends "res://audio_graph/graph_edit_nodes/base_node.gd"

@onready var delay_spin: SpinBox = $DelayIn/SpinBox
@onready var delay_slider: HSlider = $DelayIn/HSlider

@export var delay: Delay = Delay.new(4410)

var _delay_length: float = 0.1:
	get():
		return _delay_length
	set(value):
		_delay_length = value
		delay.delay_buffer_size = ceil(_delay_length * audio_graph.mix_rate)
		delay_spin.value = value
		delay_slider.value = value

func save_editor_metadata() -> void:
	delay.set_meta("graph_edit_position", position_offset)

func apply_editor_metadata() -> void:
	if delay.has_meta("graph_edit_position"):
		position_offset = delay.get_meta("graph_edit_position")

func set_audio_node(node: AudioGraphNode) -> void:
	assert(node is Delay, "Node must be of type Delay.")
	delay = node

func get_audio_node() -> AudioGraphNode:
	return delay

func set_input(index: int, input: AudioGraphNode, output_index: int = 0) -> bool:
	assert(index == 0, "DelayNode only supports one input.")
	return delay.set_input(0, input, output_index)

func _ready() -> void:
	delay_spin.value = _delay_length
	delay_slider.value = _delay_length

	delay_spin.value_changed.connect(func(value):
		_delay_length = value
	)

	delay_slider.value_changed.connect(func(value):
		_delay_length = value
	)
