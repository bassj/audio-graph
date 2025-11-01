extends AudioStreamPlayer
class_name AudioGraphPlayer

@export var audio_graph: AudioGraph

var playback: AudioStreamGeneratorPlayback

func _process(delta: float) -> void:
	if not has_stream_playback():
		if playback != null:
			playback = null
		return

	if not playback:
		playback = get_stream_playback() as AudioStreamGeneratorPlayback

	var sample_rate: int = stream.get_mix_rate()
	var increment = 1.0 / sample_rate
	var samples_needed: int = ceil(sample_rate * delta)

	for i in range(samples_needed):
		var sample = audio_graph.sample(increment)
		playback.push_frame(sample)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	if not audio_graph:
		warnings.append("AudioGraphPlayer has no AudioGraph assigned to it.")
	return warnings
