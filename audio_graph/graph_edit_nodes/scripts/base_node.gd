@abstract
extends GraphNode

@export var can_be_deleted: bool = true

var audio_graph: AudioGraph = null:
	set = set_audio_graph,
	get = get_audio_graph

#region Virtual Methods

func save_editor_metadata() -> void:
	return

func apply_editor_metadata() -> void:
	return

func set_audio_graph(p_audio_graph: AudioGraph) -> void:
	audio_graph = p_audio_graph

func get_audio_graph() -> AudioGraph:
	return audio_graph

func set_audio_node(_node: AudioGraphNode) -> void:
	return

func get_audio_node() -> AudioGraphNode:
	assert(false, "get_audio_node() not implemented in subclass")
	return null

func set_input(_index: int, _input: AudioGraphNode, _output_index: int) -> bool:
	assert(false, "set_input() not implemented in subclass")
	return false

func clear_input(index: int) -> void:
	set_input(index, null, 0)

#endregion

#region Utility Methods

var _debounce_timers = {}
func _debounce(fn: Callable, delay_ms: int = 250) -> Callable:
	var timer_key = str(fn)

	if not _debounce_timers.has(timer_key):
		var _timer = Timer.new()
		_timer.wait_time = float(delay_ms) / 1000.0
		_timer.one_shot = true
		add_child(_timer)
		_debounce_timers[timer_key] = _timer

	var timer = _debounce_timers.get(timer_key, null)

	return func(...args):
		_disconnect_all(timer.timeout)
		timer.timeout.connect(func ():
			return fn.callv(args)
		)
		timer.start()

func _disconnect_all(_signal: Signal) -> void:
	for connection in _signal.get_connections():
		_signal.disconnect(connection["callable"])

func _get_param_meta(input: NumberInput) -> Dictionary:
	return {
		"min_value": input.min_value,
		"max_value": input.max_value,
		"step": input.step,
		"units": input.units,
	}

func _apply_param_meta(meta: Dictionary, input: NumberInput) -> void:
	if meta.has("min_value"):
		input.min_value = meta["min_value"]
	if meta.has("max_value"):
		input.max_value = meta["max_value"]
	if meta.has("step"):
		input.step = meta["step"]
	if meta.has("units"):
		input.units = meta["units"]

#endregion
