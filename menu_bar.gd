extends MenuBar

const FILE_SAVE: int = 0
const FILE_LOAD: int = 1

@export var audio_graph_edit: GraphEdit


@onready var file_menu: PopupMenu = $File as PopupMenu

var _file_dialog: FileDialog

func _save_file(path: String) -> void:
	var err = ResourceSaver.save(audio_graph_edit.audio_graph, path, ResourceSaver.FLAG_CHANGE_PATH)
	if err != OK:
		push_error("Failed to save Audio Graph to %s" % path)

func _load_file(path: String) -> void:
	print(path)

func _show_dialog(file_selected: Callable) -> void:
	_file_dialog.popup_centered()

	var on_dialog_closed = func() -> void:
		if _file_dialog.file_selected.is_connected(file_selected):
			_file_dialog.file_selected.disconnect(file_selected)

	_file_dialog.file_selected.connect(file_selected, CONNECT_ONE_SHOT)
	_file_dialog.canceled.connect(on_dialog_closed, CONNECT_ONE_SHOT)

func _ready() -> void:
	_file_dialog = FileDialog.new()
	_file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	_file_dialog.add_filter("*.tres", "Audio Graph Resource")

	add_child(_file_dialog)

	file_menu.id_pressed.connect(func(id: int) -> void:
		match id:
			FILE_SAVE:
				_file_dialog.title = "Save Audio Graph"
				_file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
				_show_dialog(_save_file)
			FILE_LOAD:
				_file_dialog.title = "Load Audio Graph"
				_file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
				_show_dialog(_load_file)
	)
