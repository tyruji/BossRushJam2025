extends CharacterBase

@onready
var cursor_rotator = $CursorRotator

	# Just for now, will probably get the player in a different way later
@onready
var player = $"../Player"

func _process( delta: float ) -> void:
	super._process( delta )
	
	var dir_to_player = player.global_position - global_position
	var dist_to_slash_player = 500
	
	if( dir_to_player.length_squared() > dist_to_slash_player * dist_to_slash_player ):
		cursor_rotator.normal_rotation()
	else:
		cursor_rotator.slash_rotation()
	
	if( dir_to_player.x > 0 ):
		cursor_rotator.rotate_clockwise()
	else:
		cursor_rotator.rotate_counterclockwise()

func get_cursor_pos() -> Vector2:
	return cursor_rotator.get_cursor_position()
