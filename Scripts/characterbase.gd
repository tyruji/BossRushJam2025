class_name CharacterBase
extends CharacterBody2D

signal on_take_damage

var anchor_position : Vector2
var anchor_radius : float
var anchored : bool = false 
var cursor_pos : Vector2

@onready
var weapon = $Weapon

@export
var speed = 10
@export
var air_friction = 10
@export
var weapon_swing_speed = 25
@export
var max_air_velocity = 10000

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

	## Override this method
func get_cursor_pos() -> Vector2:
	return Vector2.ZERO

func _ready() -> void:
	cursor_pos = get_cursor_pos()

func _physics_process( delta: float ) -> void:
	
	cursor_pos = cursor_pos.lerp( get_cursor_pos(), delta * weapon_swing_speed )
	var dir_to_mouse = ( cursor_pos - global_position ).normalized()
	
		# Dont rotate when the direction is the zero vector
	if( dir_to_mouse != Vector2.ZERO ):
		rotate_weapon( dir_to_mouse )
	
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

func rotate_weapon( dir_to_mouse: Vector2 ):
	$Weapon.transform.y = dir_to_mouse
	$Weapon.transform.x = Vector2( dir_to_mouse.y, -dir_to_mouse.x )

func damage( damage_value: int, knockback = Vector2.ZERO ):
	
	velocity += knockback
	
	on_take_damage.emit()

	pass
