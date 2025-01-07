extends Area2D

signal on_anchor_set( anchor_position : Vector2, anchor_radius : float )
signal on_anchor_remove
signal on_weapon_swing_start
signal on_weapon_swing_stop

var anchor : Vector2
var anchor_radius : float
var anchor_body_rid : RID
var last_pos : Vector2

@onready
var weapon_tip = $Marker2D

@export
var weapon_damage : int = 10 
@export
var weapon_knockback : int = 5000

var attacking_swing : bool = false

func _ready() -> void:
	last_pos = get_local_weapon_tip_pos()

func _process( delta: float ) -> void:
	
	var marker_pos = get_local_weapon_tip_pos()
	var speed = ( marker_pos - last_pos ).length()
	last_pos = marker_pos

	if( speed < 30 && attacking_swing ):
		on_weapon_swing_stop.emit()
		attacking_swing = false
		return
		
	if( speed >= 30 && !attacking_swing ):
		on_weapon_swing_start.emit()
		attacking_swing = true
	
func get_local_weapon_tip_pos():
	return weapon_tip.global_position - global_position

func _on_body_shape_entered( body_rid: RID, body: Node2D, 
		body_shape_index: int, local_shape_index: int ) -> void:
			
	if( body is CharacterBase ):
			# Check if this is the weapon so the character doesnt attack itself
		if( body.weapon.get_instance_id() == get_instance_id() ):
			return
		
		handle_damage_dealing( body )
		
			# As of now, lets not allow anchoring on the enemy
		return
	
	handle_anchoring( body_rid, body, body_shape_index, local_shape_index )
	
func handle_damage_dealing( body: Node2D ):
	if( attacking_swing && body.has_method( "damage" ) ):
		var dir_to_body = ( body.global_position - get_local_weapon_tip_pos() ).normalized()
		body.damage( weapon_damage, dir_to_body * weapon_knockback )

func handle_anchoring( body_rid: RID, body: Node2D, 
		body_shape_index: int, local_shape_index: int ) -> void:
			
	var body_shape_owner_id = body.shape_find_owner( body_shape_index )
	var body_shape_owner = body.shape_owner_get_owner( body_shape_owner_id )
	var body_shape_2d = body.shape_owner_get_shape( body_shape_owner_id, 0 )
	var body_global_tr = body_shape_owner.global_transform
	
	var area_shape_owner_id = shape_find_owner( local_shape_index )
	var area_shape_owner = shape_owner_get_owner( area_shape_owner_id )
	var area_shape_2d = shape_owner_get_shape( area_shape_owner_id, 0 )
	var area_global_transform = area_shape_owner.global_transform
	
	var collision_points = area_shape_2d.collide_and_get_contacts( 
		area_global_transform,
		body_shape_2d,
		body_global_tr )
	
	if( collision_points.size() == 0 ):
		return
	
	anchor = collision_points[ 0 ]
	anchor_body_rid = body_rid
	anchor_radius = ( global_position - anchor ).length();
	
	on_anchor_set.emit( anchor, anchor_radius )
	
func _on_body_shape_exited( body_rid: RID, body: Node2D, 
		body_shape_index: int, local_shape_index: int ) -> void:
	
	if( body_rid != anchor_body_rid ):
		return
	
	on_anchor_remove.emit()
	
