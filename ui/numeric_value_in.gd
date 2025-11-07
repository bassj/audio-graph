@tool
extends VBoxContainer
class_name NumberInput

@export var label_ref: Label
@export var spinner: SpinBox
@export var slider: HSlider

#region Signals

signal value_changed(value: float)
signal label_changed(new_label: String)
signal delete_requested()

#endregion

#region Properties

@export var value: float = 0.0:
	set(p_value):
		if value == p_value:
			return

		value = clampf(p_value, min_value, max_value)
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
		if label == p_label:
			return
		var old_label = label
		label = p_label
		label_changed.emit(label)
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
	slider.value_changed.connect(_on_value_changed)
	spinner.value_changed.connect(_on_value_changed)

	_update_config()
	_update_value()

#endregion

#region Private Methods

func _on_value_changed(p_value: float) -> void:
	value = p_value

func _update_value() -> void:
	spinner.value = value
	slider.value = value

func _update_config() -> void:
	spinner.min_value = min_value
	spinner.max_value = max_value
	spinner.step = step
	spinner.suffix = units

	slider.min_value = min_value
	slider.max_value = max_value
	slider.step = step

	label_ref.text = label

#endregion
