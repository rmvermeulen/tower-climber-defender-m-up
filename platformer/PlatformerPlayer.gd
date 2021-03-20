extends KinematicBody2D

var vel := Vector2.ZERO

onready var gravity: Vector2 = (
	ProjectSettings.get("physics/2d/default_gravity")
	* ProjectSettings.get("physics/2d/default_gravity_vector")
)


func _physics_process(delta):
	vel += gravity * delta
	vel = move_and_slide(vel, Vector2.UP)
