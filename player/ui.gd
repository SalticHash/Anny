extends Control

@onready var player: Player = get_parent()
var selected_mode: Input.MouseMode = Input.MOUSE_MODE_CAPTURED
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"ui_cancel"):
		if selected_mode == Input.MOUSE_MODE_CAPTURED:
			selected_mode = Input.MOUSE_MODE_VISIBLE
		else:
			selected_mode = Input.MOUSE_MODE_CAPTURED
	if player.npc_info_open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = selected_mode
		
