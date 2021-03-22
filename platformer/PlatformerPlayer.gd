extends KinematicBody2D

const MAX_SPEED := Vector2(400, 1000)
const GRAVITY := 600.0
const ACCELERATION := MAX_SPEED.x * 1.5
const DECELERATION := ACCELERATION * 1.2
const JUMP_POWER := MAX_SPEED.y * 0.5

var vel := Vector2.ZERO


func _physics_process(delta):
	var right := int(Input.is_action_pressed("right"))
	var left := int(Input.is_action_pressed("left"))
	var h_input := right - left

	if h_input == 0:
		# slow down automatically
		vel.x = sign(vel.x) * clamp(abs(vel.x) - DECELERATION * delta, 0, MAX_SPEED.x)
	else:
		# accelerate according to input
		vel.x += h_input * ACCELERATION * delta

	if is_on_floor() && Input.is_action_just_pressed("jump"):
		vel.y = -JUMP_POWER
	else:
		vel.y += GRAVITY * delta

	vel.y = clamp(vel.y, -MAX_SPEED.y, MAX_SPEED.y)

	vel = move_and_slide(vel, Vector2.UP)
