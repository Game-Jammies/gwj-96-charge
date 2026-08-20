class_name ChargeBar extends TextureProgressBar

## Seconds of holding to fill the bar completely.
@export var total_charge_time: float = 2.0
## Segments on the bar
@export_range(1,5) var segment_count: int = 4

var current_charge: float = 0.0

func _ready() -> void:
	self.value = 0

func add_charge(delta: float) -> void:
	var fill_rate: float = self.max_value / total_charge_time
	current_charge = minf(current_charge + fill_rate * delta, self.max_value)
	self.value = current_charge


func release_charge() -> void:
	var charge: int = get_charged_segments()
	print("Charged %d segments" % charge)
	reset_bar()
	
func reset_bar() -> void:
	#safety function
	current_charge = 0.0
	self.value = 0.0

## getters and setters
func get_charged_segments() -> int:
	var per_segment: float = self.max_value / segment_count
	return clampi(floori(current_charge / per_segment), 0, segment_count)
	
func set_charge_time(new_time:float) -> void:
	total_charge_time = new_time
	reset_bar()
	
func set_charge_dist(new_seg:int) -> void:
	segment_count = new_seg
	reset_bar()
