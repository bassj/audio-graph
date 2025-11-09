# TODO: Fix issue with loading files twice
# Save orphaned branches
# Add a way to adjust gain
# Add a way to adjust the phase or playback speed of custom generators

@tool
extends Resource
class_name AudioGraph

signal graph_branch_added(new_branch: AudioGraphNode)
signal mix_rate_changed(new_mix_rate: int)

@export var graph_root: AudioGraphNode :
	set(p_graph_root):
		graph_root = p_graph_root
		graph_branch_added.emit(graph_root)

@export var graph_root_output_index: int = 0

var playback_position: float = 0.0

var mix_rate: int = 44100 :
	set(p_mix_rate):
		if p_mix_rate == mix_rate:
			return
		mix_rate = p_mix_rate
		mix_rate_changed.emit(mix_rate)

func _set_audio_graph_recursive(p_root: AudioGraphNode = graph_root) -> void:
	if p_root == null:
		return

	var s = [p_root]
	while s.size() > 0:
		var n = s.pop_front()
		n.audio_graph = self
		s.append_array(n.get_leaf_nodes())

func _init() -> void:
	graph_branch_added.connect(_set_audio_graph_recursive)

func sample(p_playback_position: float) -> Vector2:
	playback_position = p_playback_position

	if not graph_root:
		return Vector2.ZERO

	var _sample = graph_root.sample(graph_root_output_index)
	return Vector2.ONE * _sample

# var _left_delay := Delay.new()
# var _right_delay := Delay.new()

# var _piston := Generator.new(
#     func(phase) -> float:
#         return cos(2.0 * TAU * phase);
# )

# var _ignition := Generator.new(
#     func(phase) -> float:
#         var t = 0.0833
#         if 0 < phase and phase < t:
#             return sin(TAU * (phase * t + 0.5))
#         else:
#             return 0.0
# )

# var _exhaust := Generator.new(
#     func (phase) -> float:
#         if phase > 0.75 and phase < 1.0:
#             return -sin(TAU * 2.0 * phase)
#         else:
#             return 0.0
# )

# var _intake := Generator.new(
#     func (phase) -> float:
#         if phase > 0.0 and phase < 0.25:
#             return sin(TAU * 2.0 * phase)
#         else:
#             return 0.0
# )
# var ignition = _ignition.sample(increment)
# var intake = _intake.sample(increment)
# var exhaust = _exhaust.sample(increment)
# var piston = _piston.sample(increment)

# var val = ignition + intake + exhaust + piston

# var right_delay = _right_delay.get_current_sample()
# var left_delay = _left_delay.get_current_sample()

# _right_delay.add_sample(val + left_delay * 0.96)
# _left_delay.add_sample(right_delay * -0.04)


# func _generate_samples(num_samples: int) -> PackedVector2Array:
#     var samples = PackedVector2Array()

#     for i in range(num_samples):
#         samples.append(
#             Vector2.ONE * _generate_sample()
#         )

#     return samples

# func generate_audio(playback: AudioStreamGeneratorPlayback, duration: float) -> void:
#     var samples_needed := int(ceil(duration * sample_rate))
#     var samples := _generate_samples(samples_needed)
#     playback.push_buffer(samples)
