extends Area3D

var player_inside: bool = false
@export var bus: Bus
func _process(_delta: float) -> void:
	bus.player_waiting = player_inside

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		player_inside = true


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		player_inside = false
