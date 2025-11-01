extends BaseNode

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

var _frequency: float = 0.0:
	get():
		return generator.frequency
	set(value):
		generator.frequency = value
		frequency_spin.value = value
		frequency_slider.value = value
		preview.queue_redraw()

var _amplitude: float = 0.0:
	get():
		return generator.amplitude
	set(value):
		generator.amplitude = value
		amplitude_spin.value = value
		amplitude_slider.value = value
		preview.queue_redraw()

var _phase: float = 0.0:
	get():
		return generator.phase
	set(value):
		generator.phase = value
		offset_spin.value = value
		offset_slider.value = value
		preview.queue_redraw()

func get_output() -> AudioGraphNode:
	return generator

func set_input(_input: AudioGraphNode) -> void:
	assert(false, "FunctionGeneratorNode cannot have an input.")

func _ready() -> void:
	frequency_spin.value = generator.frequency
	frequency_slider.value = generator.frequency
	amplitude_spin.value = generator.amplitude
	amplitude_slider.value = generator.amplitude
	offset_spin.value = generator.phase
	offset_slider.value = generator.phase

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
		return generator.sample_at(phase + generator.phase)
