extends Node2D

"""This is the player controller, handling inputs for the charges"""

enum ChargeDir {NONE, UP, DOWN, LEFT, RIGHT}

var charge_state: ChargeDir = ChargeDir.NONE #hands which direction the player is holding*
var time_held: float = 0.0 #how much time a button has been held

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#button pressed and held
	if Input.is_action_pressed("charge_up"):
		#handle charging up
		charge_state = ChargeDir.UP
		print("up")
	if Input.is_action_pressed("charge_down"):
		charge_state = ChargeDir.DOWN
		print("down")
	if Input.is_action_pressed("charge_left"):
		charge_state = ChargeDir.LEFT
		print("left")
	if Input.is_action_pressed("charge_right"):
		charge_state = ChargeDir.RIGHT
		print("right")
	
	#timer
	if charge_state != ChargeDir.NONE:
		time_held += delta
		
	#reset everything when button is released 
	if Input.is_action_just_released("charge_up") or Input.is_action_just_released("charge_down") \
	or Input.is_action_just_released("charge_left") or Input.is_action_just_released("charge_right"):
		"""Function for activating a charge"""
		print("released ", time_held)
		charge_state = ChargeDir.NONE
		time_held = 0.0
		
