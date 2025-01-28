extends CharacterBody2D

@export
var player_pos_lerp_damp = 5

@export
var distance_to_stop = 50

@onready
var player = $"../Characters/Player"

func _process( delta: float ) -> void:
	var alpha = delta * player_pos_lerp_damp
	var dir = player.global_position - global_position
	if( dir.length_squared() <= distance_to_stop * distance_to_stop ):
		return
	
	global_position = global_position.lerp( player.global_position, alpha )
	
	move_and_slide()
