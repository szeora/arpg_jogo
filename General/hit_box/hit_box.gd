class_name HitBox extends Area2D

# Signals the state of a damaged being.
signal damaged(hurt_box: HurtBox)

func _ready():
	pass

# Emits the signal that this hitbox has been damaged by a hurtbox.
func take_damage(hurt_box: HurtBox) -> void:
	damaged.emit(hurt_box)
	pass
