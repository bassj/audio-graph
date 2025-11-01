@abstract
extends GraphNode
class_name BaseNode

@export var can_be_deleted: bool = true

func get_output() -> AudioGraphNode:
	assert(false, "get_output() not implemented in subclass")
	return null

func set_input(_index: int, _input: AudioGraphNode) -> void:
	assert(false, "set_input() not implemented in subclass")
