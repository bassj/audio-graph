@tool
extends AudioGraphNode
class_name Mixer

@export var inputs: Array[AudioGraphNode] = []

func sample(increment: float) -> float:
    var value = 0.0
    for input in inputs:
        value += input.sample(increment)
    return value