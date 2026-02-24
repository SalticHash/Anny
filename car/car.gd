extends VehicleBody3D
class_name Car

@onready var wheels: Array[VehicleWheel3D] = [$WheelBackLeft, $WheelBackRight, $WheelFrontRight, $WheelFrontLeft]
@export var color: Color = Color.RED

@onready var mesh: MeshInstance3D = $Mesh
const STEER_SPEED: float = 1.5
const STEER_LIMIT: float = 0.4
const BRAKE_STRENGTH: float = 2.0

@export var engine_force_value: float = 40.0

var previous_speed: float = linear_velocity.length()
var _steer_target: float = 0.0
var ride: bool = false

func _ready() -> void:
	mesh.get_surface_override_material(0).albedo_color = color

var air_time: float = 0.0
@onready var last_global_position: Vector3 = global_position
func _physics_process(delta: float):
	var wheels_on_floor: int = 0
	for w in wheels:
		if w.is_in_contact(): wheels_on_floor += 1
	if wheels_on_floor != 4:
		air_time += delta
	else:
		air_time = 0.0
	if air_time > 5.0:
		global_position = last_global_position
	if ride:
		_steer_target = Input.get_axis(&"right", &"left")
		_steer_target *= STEER_LIMIT
	
	if Input.is_action_pressed(&"up") and ride:
		# Increase engine force at low speeds to make the initial acceleration faster.
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = clampf(engine_force_value * 5.0 / speed, 0.0, 100.0)
		else:
			engine_force = engine_force_value
	else:
		engine_force = 0.0

	if Input.is_action_pressed(&"down") and ride:
		# Increase engine force at low speeds to make the initial reversing faster.
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = -clampf(engine_force_value * BRAKE_STRENGTH * 5.0 / speed, 0.0, 100.0)
		else:
			engine_force = -engine_force_value * BRAKE_STRENGTH

	steering = move_toward(steering, _steer_target, STEER_SPEED * delta)

	previous_speed = linear_velocity.length()
