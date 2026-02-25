extends VehicleBody3D
class_name Bus

var braking: bool = false
var inside_stop_zone: bool = false
var player_inside: bool = false
var player_waiting: bool = false
@export var engine_force_value: float = 19.0
const BRAKE_STRENGTH: float = 1.0

var previous_speed: float = linear_velocity.length()

func _physics_process(_delta: float):
	if (player_waiting and !inside_stop_zone) or player_inside:
		engine_force = 50.0 if player_inside else engine_force_value
	else:
		engine_force = 0.0
		linear_velocity = Vector3.ZERO
