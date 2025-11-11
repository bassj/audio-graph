@tool
extends "res://audio_graph/graph_edit_nodes/scripts/base_node.gd"

@onready var speed_in: NumberInput = $PlaybackSpeedIn

@export var playback_speed := PlaybackSpeed.new()

func save_editor_metadata() -> void:
	playback_speed.set_meta("graph_edit_position", position_offset)
	playback_speed.set_meta("graph_edit_param_meta", _get_param_meta(speed_in))

func apply_editor_metadata() -> void:
	if playback_speed.has_meta("graph_edit_position"):
		position_offset = playback_speed.get_meta("graph_edit_position")

	if playback_speed.has_meta("graph_edit_param_meta"):
		_apply_param_meta(
			playback_speed.get_meta("graph_edit_param_meta", {}),
			speed_in
		)

func set_audio_node(p_node: AudioGraphNode) -> void:
	assert(p_node is PlaybackSpeed, "Node must be of type PlaybackSpeed.")
	playback_speed = p_node

func get_audio_node() -> AudioGraphNode:
	return playback_speed

func set_input(index: int, input: AudioGraphNode, output_index: int) -> bool:
	assert(index == 0, "PlaybackSpeedNode supports one input.")
	return playback_speed.set_input(0, input, output_index)

func _ready() -> void:
	speed_in.value = playback_speed.playback_speed

	speed_in.value_changed.connect(func(value):
		playback_speed.playback_speed = value
	)
