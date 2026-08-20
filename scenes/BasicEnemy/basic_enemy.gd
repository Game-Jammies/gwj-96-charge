class_name BasicEnemy extends CharacterBody2D

### This enemy moves towards the player while avoiding obstacles
## then attacks by charging and dashing towards the player.

enum State { CHASE, CHARGE}
enum ChargeDir {NONE , UP, DOWN, LEFT, RIGHT}

@onready var charge_bar: ChargeBar = %TextureProgressBar
@onready var sprite: Sprite2D = %Sprite2D
@onready var up: RayCast2D = %up
@onready var down: RayCast2D = %down
@onready var left: RayCast2D = %left
@onready var right: RayCast2D = %right
@onready var player: Player = get_tree().get_first_node_in_group("player")

@export var move_interval: float = 0.5
@export var attack_range_tiles: int = 2
@export var attack_cooldown_time: float = 0.6

const TILE_SIZE: Vector2 = Vector2(16,16) * 4
var sprite_node_pos_tween: Tween
var current_state: State
var move_timer: float
var charge_dir: Vector2
var cooldown_remaining: float


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
