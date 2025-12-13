# Add the ability to temporarily disable nodes in a graph.
@tool
extends "res://audio_graph/graph_edit_nodes/scripts/base_node.gd"

@onready var length_in: NumberInput = $DelayIn
@onready var reflection_in: NumberInput = $ForwardReflectionIn
@onready var reflection_back: NumberInput = $BackwardReflectionIn
@onready var bypass_button: Button = $HBoxContainer/BypassButton

@export var waveguide: WaveGuide = WaveGuide.new()

func save_editor_metadata() -> void:
	waveguide.set_meta("graph_edit_position", position_offset)

func apply_editor_metadata() -> void:
	if waveguide.has_meta("graph_edit_position"):
		position_offset = waveguide.get_meta("graph_edit_position")

func set_audio_node(node: AudioGraphNode) -> void:
	assert(node is WaveGuide, "Node must be of type Waveguide.")
	waveguide = node

func get_audio_node() -> AudioGraphNode:
	return waveguide

func set_input(index: int, input: AudioGraphNode, output_index: int = 0) -> bool:
	assert(index == 0, "WaveguideNode only supports one input.")
	return waveguide.set_input(0, input, output_index)

func _ready() -> void:
	length_in.value = waveguide.waveguide_buffer_size / float(audio_graph.mix_rate)
	reflection_in.value = waveguide.reflection_forward
	reflection_back.value = waveguide.reflection_backward

	length_in.value_changed.connect(func(value):
		waveguide.waveguide_buffer_size = ceil(value * audio_graph.mix_rate)
	)

	reflection_in.value_changed.connect(func(value):
		waveguide.reflection_forward = value
	)

	reflection_back.value_changed.connect(func(value):
		waveguide.reflection_backward = value
	)

	bypass_button.toggled.connect(func (pressed):
		waveguide.bypass = pressed
	)
