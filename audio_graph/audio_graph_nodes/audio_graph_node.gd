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

func _has_circular_connection(p_input: AudioGraphNode) -> bool:
	if p_input == null:
		return false

	var stack = [p_input]
	while not stack.is_empty():
		var node = stack.pop_back()
		if node == self:
			return true
		stack.append_array(node.get_leaf_nodes())

	return false
