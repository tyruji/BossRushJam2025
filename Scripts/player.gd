extends CharacterBody2D

var anchor_position : Vector2
var anchor_radius : float
var anchored : bool = false 
var speed = 10
var air_friction = 10
var weapon_swing_speed = 25
var mouse_pos : Vector2
var max_air_velocity = 10000

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	mouse_pos = get_global_mouse_position()

func _physics_process( delta: float ) -> void:
	
	mouse_pos = mouse_pos.lerp( get_global_mouse_position(), delta * weapon_swing_speed )
	var dir_to_mouse = ( mouse_pos - global_position ).normalized()
	
		# Dont rotate when the direction is the zero vector
	if( dir_to_mouse == Vector2.ZERO ):
		return
	
	$Weapon.transform.y = dir_to_mouse
	$Weapon.transform.x = Vector2( dir_to_mouse.y, -dir_to_mouse.x )
	
	velocity.y += delta * gravity
	velocity.x = lerp( velocity.x, .0, delta * air_friction )
	
	if( anchored ):
		var target_pos = anchor_position - dir_to_mouse * anchor_radius
		velocity = ( target_pos - global_position ) * speed
	
	move_and_slide()

func _on_weapon_on_anchor_remove() -> void:
	
	if( velocity.length_squared() > max_air_velocity * max_air_velocity ):
		velocity = velocity.normalized() * max_air_velocity
		
	anchored = false
	
	pass # Replace with function body.


func _on_weapon_on_anchor_set( anchor_pos: Vector2, radius: float ) -> void:
	
	anchor_position = anchor_pos
	anchor_radius = radius
	anchored = true
	
	pass # Replace with function body.
