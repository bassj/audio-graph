@abstract
extends Resource
class_name AudioGraphNode

var audio_graph: AudioGraph = null:
	set = set_audio_graph,
	get = get_audio_graph

var phase := 0.0 :
	set(p_phase):
		pass # noop - read only
	get():
		if audio_graph == null:
			return 0.0
		return fmod(audio_graph.playback_position, 1.0)

func set_audio_graph(p_audio_graph: AudioGraph) -> void:
	audio_graph = p_audio_graph

func get_audio_graph() -> AudioGraph:
	return audio_graph

func get_leaf_nodes() -> Array[AudioGraphNode]:
	return []

func sample() -> float:
	assert(false, "sample() not implemented in subclass")
	return 0.0
