extends "res://audio_graph/graph_edit_nodes/base_node.gd"

var ParameterInputScene: PackedScene = preload("res://ui/custom_function_parameter.tscn")

@export var preview: FunctionPlotter

@export var expression_code_edit: CodeEdit
@export var expression_error_label: Label

@export var variable_add_button: Button
@export var variable_container: VBoxContainer

@export var generator: CustomGenerator = CustomGenerator.new():
	set(p_generator):
		if p_generator == generator:
			return

		generator = p_generator
		generator.execution_error.connect(func (error_text):
			expression_error_label.text = error_text
		)
		_update_ui()

func delete_parameter(p_parameter_name: String) -> void:
	if generator.parameters.has(p_parameter_name):
		generator.parameters.erase(p_parameter_name)
	generator._update_expression()
	preview.queue_redraw()

func save_editor_metadata() -> void:
	generator.set_meta("graph_edit_position", position_offset)

	var param_meta = {}
	for c in variable_container.get_children():
		var number_input = c as NumberInput
		var param_name = number_input.label
		param_meta[param_name] = {
			"min_value": number_input.min_value,
			"max_value": number_input.max_value,
			"step": number_input.step,
			"units": number_input.units,
		}

	generator.set_meta("graph_edit_param_meta", param_meta)

func apply_editor_metadata() -> void:
	var pos = generator.get_meta("graph_edit_position", null)
	if pos != null:
		position_offset = pos
	_update_ui()

func set_audio_node(p_node: AudioGraphNode) -> void:
	assert(p_node is CustomGenerator, "Node must be a CustomGenerator")
	generator = p_node as CustomGenerator

func get_audio_node() -> AudioGraphNode:
	return generator

func _update_expression() -> void:
	generator.expression = expression_code_edit.text
	expression_error_label.text = ""

	if generator._update_expression() != OK:
		expression_error_label.text = generator._expression.get_error_text()
		return

	preview.queue_redraw()

func _update_ui():
	expression_code_edit.text = generator.expression

	for c in variable_container.get_children():
		c.queue_free()

	for k in generator.parameters.keys():
		_create_parameter_input(k)

	preview.queue_redraw()

func _create_parameter_input(p_parameter_name: String) -> NumberInput:
	var param_meta = generator \
			.get_meta("graph_edit_param_meta", {}) \
			.get(p_parameter_name, {})
	# Needs to be an array so we can pass by reference into the function closure
	var parameter_name = [p_parameter_name]
	var number_input = ParameterInputScene.instantiate()

	number_input.step = param_meta.get("step", 0.1)
	number_input.min_value = param_meta.get("min_value", 0.0)
	number_input.max_value = param_meta.get("max_value", 1.0)
	number_input.units = param_meta.get("units", "")

	var parameter_value = generator.parameters.get(
		parameter_name[0],
		clampf(
			0.0,
			number_input.min_value,
			number_input.max_value,
		)
	)
	number_input.label = parameter_name[0]
	number_input.value = parameter_value

	var _save_value = func(value):
		generator.parameters[parameter_name[0]] = value
		preview.queue_redraw()

	var _rename_parameter = func(new_name: String):
		if new_name == parameter_name[0]:
			return

		if generator.parameters.has(new_name):
			push_warning("Cannot have two parameters of the same name")
			number_input.label = parameter_name[0]
			return

		var old_name = parameter_name[0]
		parameter_name[0] = new_name
		generator.parameters[new_name] = number_input.value
		generator.parameters.erase(old_name)
		_update_expression()

	var _delete_parameter = func ():
		generator.parameters.erase(parameter_name[0])
		variable_container.remove_child(number_input)
		number_input.queue_free()
		_update_expression()

	number_input.value_changed.connect(_save_value)
	number_input.label_changed.connect(_debounce(_rename_parameter))
	number_input.delete_requested.connect(_delete_parameter)

	variable_container.add_child(number_input)

	return number_input

func _ready() -> void:
	expression_code_edit.text_changed.connect(_debounce(_update_expression))
	_update_expression()


	generator.execution_error.connect(func (error_text):
		expression_error_label.text = error_text
	)

	variable_add_button.pressed.connect(func():
		var parameter_name = "var_%d" % (generator.parameters.size() + 1)
		var input = _create_parameter_input(parameter_name)
		generator.parameters[parameter_name] = input.value
		_update_expression()
	)

	preview.function = func(phase: float) -> float:
		return generator.sample_at(phase)
