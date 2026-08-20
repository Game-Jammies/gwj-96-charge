class_name Weapon extends Resource

enum WeaponClass {LANCE}

@export var name: String = ""
@export var damage: float = 0.0 #damage gained per space charged
@export var max_charge_dmg_bonus: float = 0.0 #bonus damage when fully charged
@export var max_charge_time: float = 10.0 #how much time it takes to get a full charge
@export var charge_distance: int = 0 #number of squares you move
@export var attack_cooldown_time: float = 0.5 #how long before you can start charging again
@export var weapon_class: WeaponClass = WeaponClass.LANCE

func get_weapon_name() -> String:
	return name

func get_weapon_class() -> WeaponClass:
	return weapon_class

func get_max_damage() -> float:
	return (damage * charge_distance) + max_charge_dmg_bonus
	
func get_min_damage() -> float:
	return damage

func get_charge_time() -> float:
	return max_charge_time

func get_cooldown_time() -> float:
	return attack_cooldown_time

func get_charge_distance() -> int:
	return charge_distance
