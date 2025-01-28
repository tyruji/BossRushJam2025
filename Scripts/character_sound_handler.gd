extends Node

@export
var grunt_min_velocity = 4000

func _ready():
	
	$"../Weapon".on_anchor_set.connect( play_thump )
	$"../Weapon".on_anchor_remove.connect( play_grunt )
	$"../Weapon".on_weapon_swing_start.connect( play_attack_swing )
	$"../Weapon".on_attack_hit.connect( play_hit )
	$"..".on_take_damage.connect( play_hurt )
	pass

func play_thump( position, __ ):
	$ThumpSound.global_position = position
	$ThumpSound.play()
	
func play_grunt():
	
	if( $"..".velocity.length_squared() < grunt_min_velocity * grunt_min_velocity ):
		return
	
	$GruntSound.pitch_scale = randf_range( .8, .92 )
	$GruntSound.volume_db = randf_range( -12, -6 )
	$GruntSound.play()

func play_attack_swing():
	$SwingSound.pitch_scale = randf_range( .9, 1.02 )
	$SwingSound.volume_db = randf_range( -4, -1 )
	$SwingSound.play()

func play_hit():
	$AttackHitSound.pitch_scale = randf_range( .9, 1.02 )
	$AttackHitSound.volume_db = randf_range( -1, 1 )
	$AttackHitSound.play()

func play_hurt():
	$HurtSound.pitch_scale = randf_range( .96, 1.05 )
	$HurtSound.volume_db = randf_range( -1, 3 )
	$HurtSound.play()
