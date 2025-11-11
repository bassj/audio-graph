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

@export var config_button: Button

func _update_parameter_inputs() -> void:
	if name_input:
		parameter_input.label = name_input.text
	if units_input:
		parameter_input.units = units_input.text
	if min_input:
		parameter_input.min_value = min_input.value
	if max_input:
		parameter_input.max_value = max_input.value
	if step_input:
		parameter_input.step = step_input.value

func _update_ui_fields() -> void:
	if  name_input:
		name_input.text = parameter_input.label
	if units_input:
		units_input.text = parameter_input.units
	if min_input:
		min_input.value = parameter_input.min_value
	if max_input:
		max_input.value = parameter_input.max_value
	if step_input:
		step_input.value = parameter_input.step

func _ready() -> void:
	_update_ui_fields()

	config_button.pressed.connect(func():
		var mouse_pos = get_parent().get_viewport().get_mouse_position()
		popup(Rect2i(mouse_pos, Vector2i(0, 0)))
	)

	about_to_popup.connect(func():
		_update_ui_fields()
	)

	if delete_button:
		if parameter_input.can_be_deleted:
			delete_button.pressed.connect(func():
				parameter_input.delete_requested.emit()
			)
		else:
			delete_button.visible = false

	if name_input:
		name_input.text_changed.connect(func(_text): _update_parameter_inputs())
	if units_input:
		units_input.text_changed.connect(func(_text): _update_parameter_inputs())
	if min_input:
		min_input.value_changed.connect(func(_value): _update_parameter_inputs())
	if max_input:
		max_input.value_changed.connect(func(_value): _update_parameter_inputs())
	if step_input:
		step_input.value_changed.connect(func(_value): _update_parameter_inputs())
