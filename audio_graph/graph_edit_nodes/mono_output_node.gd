extends "res://audio_graph/graph_edit_nodes/base_node.gd"

signal input_changed(new_input: AudioGraphNode)

@onready var audio_graph_player: AudioGraphPlayer = $AudioGraphPlayer

@onready var playback_position: Label = $PlaybackPosition

@onready var play_button: Button = $Controls/PlayButton
@onready var pause_button: Button = $Controls/PauseButton
@onready var stop_button: Button = $Controls/StopButton

func set_audio_graph(p_audio_graph: AudioGraph) -> void:
	audio_graph_player.audio_graph = p_audio_graph

func get_audio_graph() -> AudioGraph:
	return audio_graph_player.audio_graph

func save_editor_metadata() -> void:
	audio_graph.set_meta("output_graph_edit_position", position_offset)

func apply_editor_metadata() -> void:
	if audio_graph.has_meta("output_graph_edit_position"):
		position_offset = audio_graph.get_meta("output_graph_edit_position")

func set_audio_node(_node: AudioGraphNode) -> void:
	assert(false, "MonoOutputNode does not have an audio node.")

func get_audio_node() -> AudioGraphNode:
	assert(false, "MonoOutputNode does not have an output.")
	return null

func set_input(index: int, p_input: AudioGraphNode, output_index: int) -> bool:
	assert(index == 0, "MonoOutputNode only supports a single input at index 0.")
	input_changed.emit(p_input, output_index)
	return true

func _ready() -> void:
	play_button.pressed.connect(func ():
		if audio_graph.graph_root == null:
			return
		audio_graph_player.play()
	)
	pause_button.pressed.connect(func ():
		audio_graph_player.stop()
	)
	stop_button.pressed.connect(func ():
		audio_graph_player.stop()
		audio_graph_player.seek(0.0)
		_update_playback_position_label()
	)

func _process(_delta: float) -> void:
	if audio_graph_player.playing:
		_update_playback_position_label()

func _update_playback_position_label() -> void:
	var position_seconds = audio_graph_player.get_playback_position()
	# update the label to show the playback position in hh:mm:ss format
	var hours = (position_seconds / 3600.0)
	var minutes = (fmod(position_seconds, 3600.0) / 60.0)
	var seconds = fmod(position_seconds, 60.0)
	playback_position.text = "%02.0d:%02.0d:%02.0d" % [hours, minutes, seconds]
