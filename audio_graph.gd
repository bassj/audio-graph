@tool
extends Resource
class_name AudioGraph

@export var sample_rate: int = 44100

var _current_sample: int = 0

var _left_delay := Delay.new()
var _right_delay := Delay.new()

@export var engine_freq = 10.0

@export var turbulence_noise: FastNoiseLite = FastNoiseLite.new()

# func _init() -> void:
	# _delay_buffer.resize(_delay_buffer_size)
	# _delay_buffer.fill(0.0)

func _sine(frequency: float = 440.0, amplitude: float = 0.5) -> float:
	var time = float(_current_sample) / float(sample_rate)
	return amplitude * sin(TAU * frequency * time)

func _ignition() -> float:
	var time = float(_current_sample) / float(sample_rate)
	# var x = time
	var x = fmod(time * engine_freq, 1.0)
	var t = 0.0833

	if 0 < x and x < t:
		return sin(TAU * (x * t + 0.5))
	else:
		return 0.0

func _intake() -> float:
	var time = float(_current_sample) / float(sample_rate)
	var x = fmod(time * engine_freq, 1.0)

	if x > 0.0 and x < 0.25:
		return sin(TAU * 2.0 * x)
	else:
		return 0.0

func _exhaust() -> float:
	var time = float(_current_sample) / float(sample_rate)
	var x = fmod(time * engine_freq, 1.0)

	if x > 0.75 and x < 1.0:
		return -sin(TAU * 2.0 * x)
	else:
		return 0.0

func _piston() -> float:
	var time = float(_current_sample) / float(sample_rate)
	var x = fmod(time * engine_freq, 1.0)

	return cos(2.0 * TAU * x);

# var _delay_buffer := PackedFloat32Array()
# var _delay_buffer_size := 22050
# var _delay_buffer_pointer: int = 0
# func _delay(sample: float) -> float:
#     var playback_pointer: int = (_delay_buffer_pointer + 1) % _delay_buffer_size
#     _delay_buffer[_delay_buffer_pointer] = sample
#     _delay_buffer_pointer = playback_pointer
#     return _delay_buffer[playback_pointer]

func _generate_sample() -> float:
	#var val = _sine(400.0)
	var ignition = _ignition() # Sound at the mounth of the pipe
	var intake = _intake()
	var exhaust = _exhaust()
	var piston = _piston()

	var val = ignition + intake + exhaust + piston

	var right_delay = _right_delay.get_current_sample()
	var left_delay = _left_delay.get_current_sample()

	# var time = float(_current_sample) / float(sample_rate) * 10.0
	# val += turbulence_noise.get_noise_1d(time)

	_right_delay.add_sample(val + left_delay * 0.85)
	_left_delay.add_sample(right_delay * -0.3)

	_current_sample += 1
	return right_delay

func _generate_samples(num_samples: int) -> PackedVector2Array:
	var samples = PackedVector2Array()

	for i in range(num_samples):
		samples.append(
			Vector2.ONE * _generate_sample()
		)

	return samples

func generate_audio(playback: AudioStreamGeneratorPlayback, duration: float) -> void:
	var samples_needed := int(ceil(duration * sample_rate))
	var samples := _generate_samples(samples_needed)
	playback.push_buffer(samples)

class Delay:
	var _buffer := PackedFloat32Array()
	var _buffer_size: int = 20
	var _buffer_pointer: int = 0
	func _init() -> void:
		_buffer.resize(_buffer_size)
		_buffer.fill(0.0)

	func get_current_sample() -> float:
		var sample_pointer = (_buffer_pointer + 1) % _buffer_size
		return _buffer[sample_pointer]

	func add_sample(sample: float) -> void:
		_buffer[_buffer_pointer] = sample
		_buffer_pointer = (_buffer_pointer + 1) % _buffer_size
