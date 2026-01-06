class_name PlayerStateMachine extends Node

# Defines the variables used in the code.
var states: Array[State]
var prev_state: State
var current_state: State

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	pass

# Matches the process of the current state.
func _process(delta):
	change_state(current_state.process(delta))
	pass

# Matches the physics of the current state.
func _physics_process(delta):
	change_state(current_state.physics(delta))
	pass

# Matches the handle_input of the current state.
func _unhandled_input(event):
	change_state(current_state.handle_input(event))
	pass

# Initializes the state machine by making an array of possible states the player can enter.
func initialize(_player: Player) -> void:
	states = []
	
	# Considers all the child nodes of the state machine as states, and appends them into the array.
	for c in get_children():
		if c is State:
			states.append(c)
	
	if states.size() == 0:
		return
	
	states[0].player = _player
	states[0].state_machine = self
	
	for state in states:
		state.init()
	
	# Makes the player be able to change between states should they exist.
	change_state(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT
	pass

# Makes it possible for the player to transition between the states.
func change_state(new_state: State) -> void:
	if new_state == null || new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	prev_state = current_state
	current_state = new_state
	current_state.enter()
	pass
