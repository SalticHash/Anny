extends CharacterBody3D
class_name Player
var collects: Array[Collect] = []

@onready var camera: Camera3D = %Camera
@onready var collision: CollisionShape3D = $Collision
@onready var interact: RayCast3D = %Interact
@onready var last_global_postition: Vector3 = global_position
const SPEED: float = 2.0
const JUMP_VELOCITY: float = 4.5
var money: int = 100
var car: Car = null :
	set(new_car):
		if car: car.ride = false
		car = new_car
		if car: car.ride = true
		collision.disabled = car != null

var air_time: float = 0.0
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(&"throw"):
		throw()
	if car:
		global_position = car.to_global(Vector3(0, 0.5, 0))
		global_rotation = car.global_rotation + Vector3(0, PI, 0)
		if Input.is_action_just_pressed(&"jump") or Input.is_action_just_pressed(&"interact"):
			car = null
			global_rotation = Vector3(0, global_rotation.y, 0)
		return
	
	if air_time > 5.0:
		global_position = Vector3.ZERO
		last_global_postition = global_position
		
	if not is_on_floor():
		velocity += get_gravity() * delta
		air_time += delta
	else:
		air_time = 0.0
		last_global_postition = global_position
	
	if global_position.y < -20:
		global_position = last_global_postition
	if Input.is_action_just_pressed(&"interact"):
		interact_with(interact.get_collider())
		
	# Handle jump.
	if Input.is_action_just_pressed(&"jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector(&"left", &"right", &"up", &"down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

const DPI: float = 0.004
func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion: return
	rotate_y(-event.relative.x * DPI)
	camera.rotation.x = clampf(
		camera.rotation.x + -event.relative.y * DPI,
		-PI / 2.0, PI / 2.0
	)

func interact_with(body: Node) -> void:
	if !body: return
	if body is Car:
		car = body
		return
	if body is Door:
		body.toggle()
		return
	if body is Collect and money > 0:
		collects.push_back(body.collect())
		money -= 1
		return

func throw() -> void:
	if collects.size() == 0: return
	var collect = collects.pop_back()
	collect.last_owner.add_child(collect)
	collect.global_position = camera.to_global(Vector3.FORWARD)
	var dir = -camera.global_transform.basis.z
	collect.linear_velocity = dir * 7.0
