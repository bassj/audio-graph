@tool
extends AudioGraphNode
class_name CustomGenerator

signal execution_error(String)

@export var expression: String = "sin(TAU * phase)"
@export var parameters: Dictionary[String, Variant] = {}

var _expression: Expression = Expression.new()
var _context := ExpressionContext.new(self)
var _parse_error := false

func _update_expression() -> Error:
	_context._error_text = ""
	var res := _expression.parse(expression)
	_parse_error = res != OK
	return res

func sample(output_index: int) -> float:
	assert(output_index == 0, "CustomGenerator node only has one output (index 0)")

	var value = sample_at(phase)
	return value

func sample_at(p_phase: float) -> float:
	_context.phase = p_phase
	if _parse_error:
		return 0.0
	var value = _expression.execute([], _context, false)
	if _expression.has_execute_failed():
		if _context._error_text:
			execution_error.emit(_context._error_text)
		else:
			execution_error.emit(_expression.get_error_text())
		return 0.0

	if value == null:
		return 0.0

	return value

class ExpressionContext:
	extends RefCounted

	var _error_text := ""
	var _generator: CustomGenerator = null
	var phase: float = 0.0

	func _init(generator: CustomGenerator) -> void:
		_generator = generator

	func _get(property: StringName) -> Variant:
		if _generator.parameters.has(property):
			return _generator.parameters.get(property)
		_error_text = "Unknown parameter: " + property
		return null

	# Utility functions for custom generators

	func piecewise(value, start: float = 0.0, end: float = 1.0):
		if phase < start or phase > end:
			return 0.0
		return value
