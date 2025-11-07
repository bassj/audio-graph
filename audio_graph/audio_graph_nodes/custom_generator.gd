@tool
extends AudioGraphNode
class_name CustomGenerator

@export var expression: String = "sin(TAU * phase)"

@export var parameters: Dictionary[String, Variant] = {}

var _expression: Expression = Expression.new()

func _update_expression() -> Error:
	var parameter_names := PackedStringArray(["phase"])
	for param_name in parameters.keys():
		parameter_names.append(param_name)

	var res := _expression.parse(expression, parameter_names)
	return res

func sample(output_index: int) -> float:
	assert(output_index == 0, "CustomGenerator node only has one output (index 0)")

	var value = sample_at(phase)
	return value

func sample_at(p_phase: float) -> float:
	var parameter_values : Array = [p_phase]
	parameter_values.append_array(parameters.values())
	var value = _expression.execute(parameter_values)
	if _expression.has_execute_failed():
		# push_error("CustomGenerator execution failed: %s" % _expression.get_error_text())
		return 0.0

	if value == null:
		return 0.0

	return value