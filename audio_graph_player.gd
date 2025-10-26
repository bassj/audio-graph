extends AudioStreamPlayer

@export var audio_graph: AudioGraph

var playback: AudioStreamGeneratorPlayback

func _ready() -> void:
	play()
	playback = get_stream_playback() as AudioStreamGeneratorPlayback

func _process(delta: float) -> void:
	if not playback:
		return

	audio_graph.generate_audio(playback, delta)
