@tool
extends VBoxContainer
class_name NumberInput

@onready var _label: Label = $Label
@onready var _spinner: SpinBox = $SpinBox
@onready var _slider: HSlider = $HSlider

#region Signals

signal value_changed(value: float)

#endregion

#region Properties

@export var value: float = 0.0:
	set(p_value):
		if value == p_value:
			return

		value = p_value
		if is_inside_tree():
			_update_value()
		else:
			_update_value.call_deferred()
		value_changed.emit(value)

@export var min_value: float = -1.0:
	set(p_min_value):
		min_value = p_min_value
		if is_inside_tree():
			_update_config()
		else:
			_update_config.call_deferred()
@export var max_value: float = 1.0:
	set(p_max_value):
		max_value = p_max_value
		if is_inside_tree():
			_update_config()
		else:
			_update_config.call_deferred()
@export var step: float = 0.1:
	set(p_step):
		step = p_step
		if is_inside_tree():
			_update_config()
		else:
			_update_config.call_deferred()

@export var label: String = "Number Input":
	set(p_label):
		label = p_label
		if is_inside_tree():
			_update_config()
		else:
			_update_config.call_deferred()
@export var units: String = "":
	set(p_units):
		units = p_units
		if is_inside_tree():
			_update_config()
		else:
			_update_config.call_deferred()

#endregion

#region Godot Hooks

func _ready() -> void:
	_slider.value_changed.connect(_on_value_changed)
	_spinner.value_changed.connect(_on_value_changed)

	_update_config()
	_update_value()

#endregion

#region Private Methods

func _on_value_changed(p_value: float) -> void:
	value = p_value

func _update_value() -> void:
	_spinner.value = value
	_slider.value = value

func _update_config() -> void:
	_spinner.min_value = min_value
	_spinner.max_value = max_value
	_spinner.step = step
	_spinner.suffix = units

	_slider.min_value = min_value
	_slider.max_value = max_value
	_slider.step = step

	_label.text = label

#endregion
