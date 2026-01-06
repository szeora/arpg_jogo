class_name Plant extends Node2D

# Sets up the hitbox for the plant.
func _ready():
	$HitBox.damaged.connect(take_damage)
	pass

# Makes its own destruction in the scene possible when damage is taken.
func take_damage(_damage: HurtBox) -> void:
	queue_free()
	pass
