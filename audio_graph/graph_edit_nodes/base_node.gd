@abstract
extends GraphNode

@export var can_be_deleted: bool = true

var audio_graph: AudioGraph = null :
	set = set_audio_graph,
	get = get_audio_graph

func set_audio_graph(p_audio_graph: AudioGraph) -> void:
	audio_graph = p_audio_graph

func get_audio_graph() -> AudioGraph:
	return audio_graph

func get_output() -> AudioGraphNode:
	assert(false, "get_output() not implemented in subclass")
	return null

func set_input(_index: int, _input: AudioGraphNode) -> void:
	assert(false, "set_input() not implemented in subclass")
