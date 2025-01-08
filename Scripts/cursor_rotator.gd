extends Marker2D

@export
var normal_rotation_speed = 5

@export
var slashing_rotation_speed = 15

@onready
var cursor = $Cursor

var rotation_speed = 50
var rotation_direction : float = .0

func _ready() -> void:
	rotation_speed = normal_rotation_speed

func _process( delta: float ) -> void:
	rotation += rotation_direction * rotation_speed * delta

func get_cursor_position() -> Vector2:
	return cursor.global_position

func slash_rotation():
	rotation_speed = slashing_rotation_speed
	
func normal_rotation():
	rotation_speed = normal_rotation_speed

func rotate_clockwise():
	rotation_direction = 1.0
	
func rotate_counterclockwise():
	rotation_direction = -1.0
	
func stop_rotation():
	rotation_direction = 0.0
