@tool
@abstract
extends Resource
class_name AudioGraphNode

var audio_graph: AudioGraph = null:
	set = set_audio_graph,
	get = get_audio_graph

@export
var inputs: Dictionary[int, Dictionary] = {}

func set_audio_graph(p_audio_graph: AudioGraph) -> void:
	audio_graph = p_audio_graph

func get_audio_graph() -> AudioGraph:
	return audio_graph

func get_leaf_nodes() -> Array[AudioGraphNode]:
	var nodes: Array[AudioGraphNode] = []
	for output in inputs.values():
		nodes.append(output["node"])
	return nodes

func set_input(index: int, input: AudioGraphNode, output_index: int = 0) -> bool:
	if _has_circular_connection(input):
		return false

	if input == null:
		inputs.erase(index)
		return true

	inputs[index] = {
		"node": input,
		"output_index": output_index,
	}

	if audio_graph:
		audio_graph.graph_branch_added.emit(input)

	return true

func sample(_output_index: int, _time_scale: float = 1.0) -> float:
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