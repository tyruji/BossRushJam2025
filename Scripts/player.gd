extends CharacterBase

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	cursor_pos = get_global_mouse_position()

func get_cursor_pos() -> Vector2:
	return get_global_mouse_position()
