extends Node3D
class_name Door
@export var direction: float = 0.0
var open: bool = false

func toggle() -> void:
	if open:
		open = false
		rotation.y = 0.0
	else:
		open = true
		rotation.y = PI / 2.0 * direction
