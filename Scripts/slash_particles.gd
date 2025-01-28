extends GPUParticles2D

func _ready():
	$"..".on_weapon_swing_start.connect( _on_weapon_on_weapon_swing_start )
	$"..".on_weapon_swing_stop.connect( _on_weapon_on_weapon_swing_stop )

func _on_weapon_on_weapon_swing_start() -> void:
	emitting = true

func _on_weapon_on_weapon_swing_stop() -> void:
	emitting = false
