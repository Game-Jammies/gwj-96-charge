class_name ChargeBar extends Node2D

@onready var progress_bar: TextureProgressBar = %TextureProgressBar

## Seconds of holding to fill the bar completely.
@export var total_charge_time: float = 2.0
## Segments on the bar
@export_range(1,5) var segment_count: int = 4

var current_charge: float = 0.0

func _process(delta: float) -> void: 
	if Input.is_action_pressed("charge_up"):
		var fill_rate: float = progress_bar.max_value / total_charge_time
		current_charge = minf(current_charge + fill_rate * delta, progress_bar.max_value)
		progress_bar.value = current_charge
	
		
	else:
		_release_attack(_get_charged_segments())
	pass

func _ready() -> void:
	progress_bar.value = 0
	pass
	
func _get_charged_segments() -> int:
	var per_segment: float = progress_bar.max_value / segment_count
	return clampi(floori(current_charge / per_segment), 0, segment_count)

func _release_attack(charge: int) -> void: 
	if charge == 0:
		return
	print("Charged %d segments" % charge)
	current_charge = 0.0
	progress_bar.value = 0.0
