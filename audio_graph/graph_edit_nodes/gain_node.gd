@tool
extends "res://audio_graph/graph_edit_nodes/base_node.gd"

@onready var gain_in: NumberInput = $GainIn

@export var gain: Gain = Gain.new()

func save_editor_metadata() -> void:
    gain.set_meta("graph_edit_position", position_offset)

func apply_editor_metadata() -> void:
    if gain.has_meta("graph_edit_position"):
        position_offset = gain.get_meta("graph_edit_position")

func set_audio_node(p_node: AudioGraphNode) -> void:
    assert(p_node is Gain, "Node must be of type Gain.")
    gain = p_node

func get_audio_node() -> AudioGraphNode:
    return gain

func set_input(index: int, input: AudioGraphNode, output_index: int) -> bool:
    assert(index == 0, "GainNode supports one input.")
    return gain.set_input(0, input, output_index)

func _ready() -> void:
    gain_in.value = linear_to_db(gain.gain)

    gain_in.value_changed.connect(func(value):
        gain.gain = db_to_linear(value)
    )
