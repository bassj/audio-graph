extends "res://audio_graph/graph_edit_nodes/base_node.gd"

@onready var preview: FunctionPlotter = $AudioFunctionOut/VBoxContainer/Control/FunctionPlotter

@onready var frequency_spin: SpinBox = $FunctionFrequencyIn/SpinBox
@onready var frequency_slider: HSlider = $FunctionFrequencyIn/HSlider

@onready var amplitude_spin: SpinBox = $FunctionAmplitudeIn/SpinBox
@onready var amplitude_slider: HSlider = $FunctionAmplitudeIn/HSlider

@onready var offset_spin: SpinBox = $FunctionOffsetIn/SpinBox
@onready var offset_slider: HSlider = $FunctionOffsetIn/HSlider

@onready var function_option: OptionButton = $AudioFunctionOut/VBoxContainer/FunctionTypeOption

@export var generator: Generator = Generator.new(
	"sine",
	0.0
)

func _update_frequency_ui() -> void:
	frequency_spin.value = generator.frequency
	frequency_slider.value = generator.frequency
var _frequency: float = 0.0:
	get():
		return generator.frequency
	set(value):
		generator.frequency = value
		_update_frequency_ui()
		preview.queue_redraw()

func _update_amplitude_ui() -> void:
	amplitude_spin.value = generator.amplitude
	amplitude_slider.value = generator.amplitude
var _amplitude: float = 0.0:
	get():
		return generator.amplitude
	set(value):
		generator.amplitude = value
		_update_amplitude_ui()
		preview.queue_redraw()

func _update_phase_ui() -> void:
	offset_spin.value = generator.phase_offset
	offset_slider.value = generator.phase_offset
var _phase: float = 0.0:
	get():
		return generator.phase_offset
	set(value):
		generator.phase_offset = value
		_update_phase_ui()
		preview.queue_redraw()

func save_editor_metadata() -> void:
	generator.set_meta("graph_edit_position", position_offset)

func apply_editor_metadata() -> void:
	var pos = generator.get_meta("graph_edit_position", null)
	if pos != null:
		position_offset = pos

func get_audio_node() -> AudioGraphNode:
	return generator

func set_input(_index: int, _input: AudioGraphNode, _output_index: int) -> bool:
	assert(false, "FunctionGeneratorNode cannot have an input.")
	return false

func _ready() -> void:
	_update_frequency_ui()
	_update_amplitude_ui()
	_update_phase_ui()

	frequency_spin.value_changed.connect(func (value):
		_frequency = value
	)
	frequency_slider.value_changed.connect(func (value):
		_frequency = value
	)

	amplitude_spin.value_changed.connect(func (value):
		_amplitude = value

	)
	amplitude_slider.value_changed.connect(func (value):
		_amplitude = value
	)

	offset_spin.value_changed.connect(func (value):
		_phase = value
	)


	offset_slider.value_changed.connect(func (value):
		_phase = value
	)

	function_option.item_selected.connect(func (index):
		match index:
			0:
				generator.function = "sine"
			1:
				generator.function = "square"
			2:
				generator.function = "sawtooth"
		preview.queue_redraw()
	)

	preview.function = func (phase: float) -> float:
		return generator.sample_at(phase + generator.phase_offset)
