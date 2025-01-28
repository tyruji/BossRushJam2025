extends Node2D

func _ready() -> void:
	$"../Weapon".on_attack_hit.connect( play_hit_particles )

func play_hit_particles():
	$AttackHitParticles.global_position = $"../Weapon/WeaponTip".global_position
	$AttackHitParticles.restart()
