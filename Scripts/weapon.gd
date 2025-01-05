extends Area2D

signal on_anchor_set( anchor_position : Vector2, anchor_radius : float )
signal on_anchor_remove

var anchor : Vector2
var anchor_radius : float
var anchor_body_rid : RID

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	var body_shape_owner_id = body.shape_find_owner( body_shape_index )
	var body_shape_owner = body.shape_owner_get_owner( body_shape_owner_id )
	var body_shape_2d = body.shape_owner_get_shape( body_shape_owner_id, 0 )
	var body_global_tr = body_shape_owner.global_transform
	
	var area_shape_owner_id = shape_find_owner( local_shape_index )
	var area_shape_owner = shape_owner_get_owner( area_shape_owner_id )
	var area_shape_2d = shape_owner_get_shape( area_shape_owner_id, 0 )
	var area_global_transform = area_shape_owner.global_transform
	
	var collision_points = area_shape_2d.collide_and_get_contacts( area_global_transform,
		body_shape_2d,
		body_global_tr )
	
	anchor = collision_points[ 0 ]
	anchor_body_rid = body_rid
	anchor_radius = ( global_position - anchor ).length();
	
	on_anchor_set.emit( anchor, anchor_radius )
	
	pass # Replace with function body.


func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	
	if( body_rid != anchor_body_rid ):
		return
	
	on_anchor_remove.emit()
	
