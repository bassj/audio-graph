@tool
extends AudioGraphNode
class_name Mixer

@export var inputs: Array[AudioGraphNode] = []

func set_input(index: int, input: AudioGraphNode) -> void:
    if index >= inputs.size():
        inputs.insert(index, input)
    else:
        inputs[index] = input

    if audio_graph:
        audio_graph.graph_changed.emit(input)

func get_leaf_nodes() -> Array[AudioGraphNode]:
    return inputs

func sample(increment: float) -> float:
    var value = 0.0
    for input in inputs:
        value += input.sample(increment)
    return value