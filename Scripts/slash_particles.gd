extends GPUParticles2D

func _on_weapon_on_weapon_swing_start() -> void:
	emitting = true

func _on_weapon_on_weapon_swing_stop() -> void:
	emitting = false
