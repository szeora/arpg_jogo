class_name Player extends CharacterBody2D

# Signals the change of direction so the interactions can work.
signal direction_changed(new_direction: Vector2)
signal player_damaged(hurt_box: HurtBox)

var DIR_8: Array = []

# Defines the variables used in the code.
var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

var invulnerable: bool = false
var hp: int = 6
var max_hp: int = 6

# Calls other scenes that this code will depend.
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer # ADD THIS
@onready var hit_box: HitBox = $HitBox
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

# Initializes the state machine so that the player can transition into different states.
func _ready():
	PlayerManager.player = self
	state_machine.initialize(self)
	hit_box.damaged.connect(_take_damage)
	update_hp(99)
	DIR_8 = [
		Vector2.RIGHT,
		Vector2(1, 1).normalized(),
		Vector2.DOWN,
		Vector2(-1, 1).normalized(),
		Vector2.LEFT,
		Vector2(-1, -1).normalized(),
		Vector2.UP,
		Vector2(1, -1).normalized()
	]
	pass

# Gets the inputs to change the direction the player is facing.
func _process(_delta):
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	pass

# Helps the movement to go through when facing diagonals.
func _physics_process(_delta):
	move_and_slide()
	pass

# Computes the direction faced by the player according to the inputs.
func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	# Complex mathematical solution to get the angle from the direction of an input.
	var direction_id: int = int(
		round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_8.size())
		) % DIR_8.size()
	var new_dir = DIR_8[direction_id]
	
	# If there was no change to the direction, then does nothing.
	if new_dir == cardinal_direction:
		return false
	
	# Modifies properly the directions, and applies the inverse scaling so the sprite can look to both sides.
	cardinal_direction = new_dir
	direction_changed.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction.x < 0 else 1
	return true

# Changes the sprite according to the state he is in.
func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())
	pass

# Plays the animation of a specific direction in accordance to the state.
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2(1, 1).normalized() or cardinal_direction == Vector2(-1, 1).normalized():
		return "downside"
	elif cardinal_direction == Vector2(1, -1).normalized() or cardinal_direction == Vector2(-1, -1).normalized():
		return "upside"
	else:
		return "side"

func _take_damage(hurt_box: HurtBox) -> void:
	if invulnerable == true:
		return
	update_hp(-hurt_box.damage)
	if hp > 0:
		player_damaged.emit(hurt_box)
	else:
		player_damaged.emit(hurt_box)
		update_hp(99)
	pass

func update_hp(delta: int) -> void:
	hp = clampi(hp + delta, 0, max_hp)
	PlayerHud.update_hp(hp, max_hp) # ADD THIS WOWOWOWOWOWOWOWOWOWOWOWOWOWOW
	pass

func make_invulnerable(_duration: float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer(_duration).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass
