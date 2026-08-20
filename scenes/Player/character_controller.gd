class_name Player extends CharacterBody2D

"""This is the player controller, handling inputs for the charges"""

## Signals
signal attack_charging(delta: float)
signal attack_released

## Enums + constants
enum ChargeDir {NONE , UP, DOWN, LEFT, RIGHT}
var charge_state: ChargeDir = ChargeDir.NONE #handles which direction the player is holding
const TILE_SIZE: Vector2 = Vector2(16,16) * 4

## Seconds after releasing an attack before charging can start again.
@export var attack_cooldown_time: float = 0.5
var cooldown_remaining: float = 0.0

## Variables
@onready var charge_bar: ChargeBar = %ChargeBar
@onready var sprite: Sprite2D = %Sprite2D
@onready var up: RayCast2D = %up
@onready var down: RayCast2D = %down
@onready var left: RayCast2D = %left
@onready var right: RayCast2D = %right
var sprite_node_pos_tween: Tween

var curr_weapon: Weapon #the player's currently equipped weapon

func _ready() -> void:
	attack_charging.connect(charge_bar.add_charge)
	attack_released.connect(charge_bar.release_charge)
	curr_weapon = load("res://resource/weapons/test_weapon.tres") as Weapon
	## NOTE: if we want to directly alter the weapon stats via powerups, create a copy of the curr_weapons variable and edit/use that
	update_chargebar_to_new_weapon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if cooldown_remaining > 0.0:
		cooldown_remaining -= delta
		return

	#button pressed and held
	if Input.is_action_pressed("charge_up") and !up.is_colliding():
		#handle charging up
		charge_state = ChargeDir.UP
		attack_charging.emit(delta)
	elif Input.is_action_pressed("charge_down") and !down.is_colliding():
		charge_state = ChargeDir.DOWN
		attack_charging.emit(delta)
	elif Input.is_action_pressed("charge_left") and !left.is_colliding():
		charge_state = ChargeDir.LEFT
		attack_charging.emit(delta)
	elif Input.is_action_pressed("charge_right") and !right.is_colliding():
		charge_state = ChargeDir.RIGHT
		attack_charging.emit(delta)
	
	#reset everything when button is released 
	if Input.is_action_just_released("charge_up") or Input.is_action_just_released("charge_down") \
	or Input.is_action_just_released("charge_left") or Input.is_action_just_released("charge_right"):
		"""Function for activating a charge"""
		if charge_bar.get_charged_segments() > 0:
			_move(charge_state)
		attack_released.emit()
		charge_state = ChargeDir.NONE
		cooldown_remaining = attack_cooldown_time


func _move(charge_dir: ChargeDir):
	var dir: Vector2
	if charge_dir == ChargeDir.UP:
		dir = Vector2.UP
	elif charge_dir == ChargeDir.DOWN:
		dir = Vector2.DOWN
	elif charge_dir == ChargeDir.LEFT:
		dir = Vector2.LEFT
	elif charge_dir == ChargeDir.RIGHT:
		dir = Vector2.RIGHT
	else:
		dir = Vector2.ZERO
	var move_amount: Vector2 = dir * TILE_SIZE * charge_bar.get_charged_segments()
	move_and_collide(move_amount) #Move the physics body first
	# Move the sprites after
	var sprite_target: Vector2 = global_position
	var charge_bar_target: Vector2 = charge_bar.global_position
	sprite.global_position -= move_amount
	charge_bar.global_position -= move_amount
	# Use a tween for a smooth transition
	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.set_parallel(true)
	sprite_node_pos_tween.tween_property(sprite, "global_position", sprite_target, 0.3).set_trans(Tween.TRANS_SINE)
	sprite_node_pos_tween.tween_property(charge_bar, "global_position", charge_bar_target, 0.3).set_trans(Tween.TRANS_SINE)


func update_chargebar_to_new_weapon():
	#Updates the chargebar's variables to the stats of curr_weapon, call this whenever a weapon is equipped
	charge_bar.set_charge_dist(curr_weapon.get_charge_distance())
	charge_bar.set_charge_time(curr_weapon.get_charge_time())


func equip_new_weapon(new_weapon: Weapon):
	#sets a new weapon for the player, alternatively pass a file path
	curr_weapon = new_weapon
	update_chargebar_to_new_weapon()
