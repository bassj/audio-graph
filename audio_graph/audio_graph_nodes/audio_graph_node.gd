@abstract
extends Resource
class_name AudioGraphNode

var audio_graph: AudioGraph = null:
	set = set_audio_graph,
	get = get_audio_graph

var inputs: Dictionary[int, AudioGraphNodeOutput] = {}

var phase := 0.0:
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
	var nodes: Array[AudioGraphNode] = []
	for output in inputs.values():
		nodes.append(output.node)
	return nodes

func set_input(index: int, input: AudioGraphNode, output_index: int = 0) -> bool:
	if _has_circular_connection(input):
		return false

	if input == null:
		inputs.erase(index)
		return true

	inputs[index] = AudioGraphNodeOutput.new(input, output_index)

	if audio_graph:
		audio_graph.graph_branch_added.emit(input)

	return true

func sample(_output_index: int) -> float:
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

class AudioGraphNodeOutput:
	var node: AudioGraphNode
	var output_index: int = 0

	func _init(p_node: AudioGraphNode, p_output_index: int = 0) -> void:
		node = p_node
		output_index = p_output_index