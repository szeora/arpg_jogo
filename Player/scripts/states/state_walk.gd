class_name State_Walk extends State

# Defines the variables used in the code.
@export var move_speed: float = 175.0

# Calls other scenes that this code will depend.
@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

# What happens when the player enters this state?
func enter() -> void:
	player.update_animation("walk")
	pass

# What happens when the player exits this state?
func exit() -> void:
	pass

# What happens during the _process update in this state?
func process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	if player.set_direction():
		player.update_animation("walk")
	return null

# What happens durig the _physics_process update in this state?
func physics (_delta: float) -> State:
	return null

# What happens with input events in this state?
func handle_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
	return null
