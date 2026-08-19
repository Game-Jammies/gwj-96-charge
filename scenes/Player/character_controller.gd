extends Node2D

"""This is the player controller, handling inputs for the charges"""

signal attack_charging(delta: float)
signal attack_released

enum ChargeDir {NONE, UP, DOWN, LEFT, RIGHT}
var charge_state: ChargeDir = ChargeDir.NONE #hands which direction the player is holding*

@onready var charge_bar: ChargeBar = %ChargeBar

func _ready() -> void:
	attack_charging.connect(charge_bar.add_charge)
	attack_released.connect(charge_bar.release_charge)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#button pressed and held
	if Input.is_action_pressed("charge_up"):
		#handle charging up
		charge_state = ChargeDir.UP
		attack_charging.emit(delta)
	elif Input.is_action_pressed("charge_down"):
		charge_state = ChargeDir.DOWN
		attack_charging.emit(delta)
	elif Input.is_action_pressed("charge_left"):
		charge_state = ChargeDir.LEFT
		attack_charging.emit(delta)
	elif Input.is_action_pressed("charge_right"):
		charge_state = ChargeDir.RIGHT
		attack_charging.emit(delta)
	
	#reset everything when button is released 
	if Input.is_action_just_released("charge_up") or Input.is_action_just_released("charge_down") \
	or Input.is_action_just_released("charge_left") or Input.is_action_just_released("charge_right"):
		"""Function for activating a charge"""
		attack_released.emit()
		charge_state = ChargeDir.NONE
		
		
