extends BaseNode
class_name MonoOutputNode

signal input_changed(new_input: AudioGraphNode)

@onready var audio_graph_player: AudioGraphPlayer = $AudioGraphPlayer

@onready var playback_position: Label = $PlaybackPosition

@onready var play_button: Button = $Controls/PlayButton
@onready var pause_button: Button = $Controls/PauseButton
@onready var stop_button: Button = $Controls/StopButton

var input: Resource = null

func set_audio_graph(audio_graph: AudioGraph) -> void:
	audio_graph_player.audio_graph = audio_graph

func get_audio_graph() -> AudioGraph:
	return audio_graph_player.audio_graph

func get_output() -> AudioGraphNode:
	assert(false, "MonoOutputNode does not have an output.")
	return null

func set_input(p_input: AudioGraphNode) -> void:
	if input == p_input:
		return

	input = p_input
	input_changed.emit(input)

func _ready() -> void:
	play_button.pressed.connect(func ():
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
