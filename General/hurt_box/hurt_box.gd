class_name HurtBox extends Area2D

@export var damage: int = 1

# Connects a signal to the function defined below.
func _ready():
	area_entered.connect(_area_entered)
	pass

func _process(_delta):
	pass

# If what entered the area of the hurtbox is a hitbox, then apply damage to it.
func _area_entered(a: Area2D) -> void:
	if a is HitBox:
		a.take_damage(self)
	pass
