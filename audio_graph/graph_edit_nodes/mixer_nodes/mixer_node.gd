extends BaseNode

@export var mixer := Mixer.new()

var _inputs = {}

func set_input(index: int, input: AudioGraphNode) -> void:
	_inputs[index] = input
	if index >= mixer.inputs.size():
		mixer.inputs.insert(index, input)
	else:
		mixer.inputs[index] = input

func get_output() -> AudioGraphNode:
	return mixer
