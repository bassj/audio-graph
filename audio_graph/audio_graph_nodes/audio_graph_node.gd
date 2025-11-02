@abstract
extends Resource
class_name AudioGraphNode

var audio_graph: AudioGraph = null:
	set = set_audio_graph,
	get = get_audio_graph

func set_audio_graph(p_audio_graph: AudioGraph) -> void:
	audio_graph = p_audio_graph

func get_audio_graph() -> AudioGraph:
	return audio_graph

func get_leaf_nodes() -> Array[AudioGraphNode]:
	return []

func sample(_increment: float) -> float:
	assert(false, "sample() not implemented in subclass")
	return 0.0
