extends CharacterBody3D
class_name WalkingNPC
@onready var game: Game = get_tree().current_scene
var player: Player
const SPEED: float = 2.0
const JUMP_VELOCITY: float = 4.5
var walk: bool = false
var jump: bool = false
var jump_time: Vector2 = Vector2(1.0 * 4, 5.0 * 4)
var jump_buffer: float = randf_range(jump_time.x, jump_time.y)
var walk_time: Vector2 = Vector2(0.25 * 4, 0.75 * 4)
var walk_buffer: float = randf_range(walk_time.x, walk_time.y)
var facing_player: bool = false
@onready var sprite: AnimatedSprite3D = $Sprite
const reldir: String = "res://walking_npcs"
static var npc_information: Dictionary = preload(reldir + "/npc_info.json").data
var display_name: String
var raw_name: String
var desc: String
var thumb: CompressedTexture2D

func load_information(_raw_name: String):
	raw_name = _raw_name
	
	var info: Dictionary = npc_information[raw_name]
	display_name = info["name"]
	desc = info["desc"]
	thumb = load(reldir + info["thumb"])
	sprite.sprite_frames = load(reldir + info["animation"])


func _ready() -> void:
	var random_name: String = npc_information.keys().pick_random()
	load_information(random_name)
	rotation.y = randf_range(0, TAU)
	if !game.is_node_ready(): await game.ready
	player = game.player

func _physics_process(delta: float) -> void:
	if player:
		var dir = Vector3(cos(rotation.y), 0.0, sin(rotation.y))
		var player_dir = Vector3(cos(player.rotation.y), 0.0, sin(player.rotation.y))
		facing_player = dir.dot(player_dir) > 0.0
		sprite.modulate = Color.WHITE if facing_player else Color.GRAY
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if jump and is_on_floor():
		jump = false
		velocity.y = JUMP_VELOCITY

	rotation.y += delta * TAU / 4.0 * randf_range(-0.5, 0.5)
	walk_buffer -= delta
	if walk_buffer <= 0.0:
		walk = !walk
		if walk: rotation.y += randf_range(-PI/4, PI/4)
		walk_buffer = randf_range(walk_time.x, walk_time.y)
	jump_buffer -= delta
	if jump_buffer <= 0.0:
		jump_buffer = randf_range(jump_time.x, jump_time.y)
		jump = true
	
	if walk:
		velocity.x = sin(rotation.y) * SPEED
		velocity.z = cos(rotation.y) * SPEED
		if facing_player: sprite.play("gif")
		else: sprite.play_backwards("gif")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		sprite.frame = 0

	move_and_slide()
