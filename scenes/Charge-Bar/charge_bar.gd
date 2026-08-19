class_name ChargeBar extends Node2D

@onready var progress_bar: TextureProgressBar = %TextureProgressBar

## Seconds of holding to fill the bar completely.
@export var total_charge_time: float = 2.0
## Segments on the bar
@export_range(1,5) var segment_count: int = 4

var current_charge: float = 0.0

func _process(delta: float) -> void: 
	# NOTE: This will most likely move to player script, add Direction and Damage
	if Input.is_action_pressed("charge_up"):
		_charge_bar(delta)
	elif Input.is_action_pressed("charge_down"):
		_charge_bar(delta)
	elif Input.is_action_pressed("charge_left"):
		_charge_bar(delta)
	elif Input.is_action_pressed("charge_right"):
		_charge_bar(delta)
	elif Input.is_action_just_released("charge_up") or Input.is_action_just_released("charge_down") or Input.is_action_just_released("charge_left") or Input.is_action_just_released("charge_right"):
		_release_attack(_get_charged_segments())

func _ready() -> void:
	progress_bar.value = 0


func _charge_bar(delta: float) -> void:
	var fill_rate: float = progress_bar.max_value / total_charge_time
	current_charge = minf(current_charge + fill_rate * delta, progress_bar.max_value)
	progress_bar.value = current_charge

func _get_charged_segments() -> int:
	var per_segment: float = progress_bar.max_value / segment_count
	return clampi(floori(current_charge / per_segment), 0, segment_count)

func _release_attack(charge: int) -> void: 
	print("Charged %d segments" % charge)
	current_charge = 0.0
	progress_bar.value = 0.0
