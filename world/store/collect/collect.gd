extends RigidBody3D
class_name Collect

@onready var last_owner = get_parent()
func collect():
	get_parent().remove_child(self)
	return self
