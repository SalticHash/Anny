extends VehicleBody3D




@export var engine_force_value: float = 40.0
const BRAKE_STRENGTH: float = 2.0

var previous_speed: float = linear_velocity.length()

func _physics_process(delta: float):

	
	if Input.is_action_pressed(&"up"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = clampf(engine_force_value * 5.0 / speed, 0.0, 100.0)
		else:
			engine_force = engine_force_value
	else:
		engine_force = 0.0

	if Input.is_action_pressed(&"down"):
		# Increase engine force at low speeds to make the initial reversing faster.
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = -clampf(engine_force_value * BRAKE_STRENGTH * 5.0 / speed, 0.0, 100.0)
		else:
			engine_force = -engine_force_value * BRAKE_STRENGTH


	previous_speed = linear_velocity.length()
