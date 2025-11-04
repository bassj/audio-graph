@abstract
extends GraphNode

@export var can_be_deleted: bool = true

var audio_graph: AudioGraph = null :
	set = set_audio_graph,
	get = get_audio_graph

func save_editor_metadata() -> void:
	return

func apply_editor_metadata() -> void:
	return

func set_audio_graph(p_audio_graph: AudioGraph) -> void:
	audio_graph = p_audio_graph

func get_audio_graph() -> AudioGraph:
	return audio_graph

func set_audio_node(_node: AudioGraphNode) -> void:
	return

func get_audio_node() -> AudioGraphNode:
	assert(false, "get_audio_node() not implemented in subclass")
	return null

func set_input(_index: int, _input: AudioGraphNode, _output_index: int) -> bool:
	assert(false, "set_input() not implemented in subclass")
	return false

func clear_input(index: int) -> void:
	set_input(index, null, 0)
