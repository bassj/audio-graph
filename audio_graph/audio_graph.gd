@tool
extends Resource
class_name AudioGraph

@export var graph_root: AudioGraphNode

func sample(increment: float) -> Vector2:
	assert(graph_root != null, "Trying to sample AudioGraph with no root node set")
	var _sample = graph_root.sample(increment)
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
