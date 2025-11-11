extends "res://audio_graph/graph_edit_nodes/scripts/base_node.gd"

@onready var preview: FunctionPlotter = $AudioFunctionOut/VBoxContainer/Control/FunctionPlotter

@onready var frequency_input: NumberInput = $FunctionFrequencyIn
@onready var amplitude_input: NumberInput = $FunctionAmplitudeIn
@onready var phase_input: NumberInput = $FunctionOffsetIn

@onready var function_option: OptionButton = $AudioFunctionOut/VBoxContainer/FunctionTypeOption

const FUNCTION_SINE := 0
const FUNCTION_SQUARE := 1
const FUNCTION_SAWTOOTH := 2

#region Properties

@export var generator: SimpleGenerator = SimpleGenerator.new(
	"sine",
	0.0
)

var _frequency: float = 0.0:
	get():
		return generator.frequency
	set(value):
		generator.frequency = value
		frequency_input.value = value
		preview.queue_redraw()

var _amplitude: float = 0.0:
	get():
		return generator.amplitude
	set(value):
		generator.amplitude = value
		amplitude_input.value = value
		preview.queue_redraw()

var _phase: float = 0.0:
	get():
		return generator.phase_offset
	set(value):
		generator.phase_offset = value
		phase_input.value = value
		preview.queue_redraw()

#endregion

#region Virtual Methods

func save_editor_metadata() -> void:
	generator.set_meta("graph_edit_position", position_offset)

func apply_editor_metadata() -> void:
	if generator.has_meta("graph_edit_position"):
		position_offset = generator.get_meta("graph_edit_position")

func set_audio_node(node: AudioGraphNode) -> void:
	assert(node is SimpleGenerator, "AudioGraphGraphEdit can only set SimpleGenerator nodes as its audio node.")
	generator = node

func get_audio_node() -> AudioGraphNode:
	return generator

func set_input(_index: int, _input: AudioGraphNode, _output_index: int) -> bool:
	assert(false, "FunctionGeneratorNode cannot have an input.")
	return false

#endregion

func _ready() -> void:
	_frequency = generator.frequency
	_amplitude = generator.amplitude
	_phase = generator.phase_offset

	frequency_input.value_changed.connect(func (value):
		_frequency = value
	)

	amplitude_input.value_changed.connect(func (value):
		_amplitude = value

	)

	phase_input.value_changed.connect(func (value):
		_phase = value
	)

	function_option.item_selected.connect(func (index):
		match index:
			FUNCTION_SINE:
				generator.function = "sine"
			FUNCTION_SQUARE:
				generator.function = "square"
			FUNCTION_SAWTOOTH:
				generator.function = "sawtooth"
		preview.queue_redraw()
	)

	preview.function = func (phase: float) -> float:
		return generator.sample_at(phase + generator.phase_offset)
