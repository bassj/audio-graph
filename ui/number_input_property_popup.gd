extends PopupPanel

@export var name_input: LineEdit
@export var units_input: LineEdit
@export var min_input: SpinBox
@export var max_input: SpinBox
@export var step_input: SpinBox
@export var delete_button: Button

@export var parameter_input: NumberInput :
	set(p_parameter_input):
		if p_parameter_input == parameter_input:
			return
		parameter_input = p_parameter_input
		_update_ui_fields()

@export var config_button: Button

func _update_parameter_inputs() -> void:
	parameter_input.label = name_input.text
	parameter_input.units = units_input.text
	parameter_input.min_value = min_input.value
	parameter_input.max_value = max_input.value
	parameter_input.step = step_input.value

func _update_ui_fields() -> void:
	name_input.text = parameter_input.label
	units_input.text = parameter_input.units
	min_input.value = parameter_input.min_value
	max_input.value = parameter_input.max_value
	step_input.value = parameter_input.step

func _ready() -> void:
	config_button.pressed.connect(func():
		var mouse_pos = get_parent().get_viewport().get_mouse_position()
		popup(Rect2i(mouse_pos, Vector2i(0, 0)))
	)

	about_to_popup.connect(func():
		_update_ui_fields()
	)

	delete_button.pressed.connect(func():
		parameter_input.delete_requested.emit()
	)

	name_input.text_changed.connect(func(_text): _update_parameter_inputs())
	units_input.text_changed.connect(func(_text): _update_parameter_inputs())
	min_input.value_changed.connect(func(_value): _update_parameter_inputs())
	max_input.value_changed.connect(func(_value): _update_parameter_inputs())
	step_input.value_changed.connect(func(_value): _update_parameter_inputs())
