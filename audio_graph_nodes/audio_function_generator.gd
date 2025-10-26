extends BaseNode

@onready var frequency_spin: SpinBox = $FunctionFrequencyIn/SpinBox
@onready var frequency_slider: HSlider = $FunctionFrequencyIn/HSlider

@export var frequency: float = 440.0 :
	set(p_frequency):
		frequency = p_frequency
		frequency_spin.value = frequency
		frequency_slider.value = frequency

func _ready() -> void:
	frequency_spin.value = frequency
	frequency_slider.value = frequency

	frequency_spin.value_changed.connect(func (value):
		frequency = value
	)
	frequency_slider.value_changed.connect(func (value):
		frequency = value
	)
