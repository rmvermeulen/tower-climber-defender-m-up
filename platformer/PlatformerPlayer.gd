extends KinematicBody2D

const MAX_SPEED := Vector2(400, 1000)
const GRAVITY := 1200.0
const ACCELERATION := MAX_SPEED.x * 3.5
const DECELERATION := ACCELERATION * 1.2
const JUMP_POWER := MAX_SPEED.x * 1.5

var vel := Vector2.ZERO

var is_facing_to_the_right := true


func _physics_process(delta):
	var right := int(Input.is_action_pressed("right"))
	var left := int(Input.is_action_pressed("left"))
	var h_input := right - left

	if h_input == 0:
		# slow down automatically
		vel.x = sign(vel.x) * clamp(abs(vel.x) - DECELERATION * delta, 0, MAX_SPEED.x)
	else:
		# accelerate according to input
		vel.x = clamp(vel.x + h_input * ACCELERATION * delta, -MAX_SPEED.x, MAX_SPEED.x)
		if vel.x > 0:
			is_facing_to_the_right = true
		elif vel.x < 0:
			is_facing_to_the_right = false

	if is_on_floor() && Input.is_action_just_pressed("jump"):
		vel.y = -JUMP_POWER
	else:
		vel.y += GRAVITY * delta

	vel.y = clamp(vel.y, -MAX_SPEED.y, MAX_SPEED.y)

	vel = move_and_slide(vel, Vector2.UP)

	update()


func _draw() -> void:
	var x_scale = 1.0 if is_facing_to_the_right else -1.0

	var pos := to_local(to_global(Vector2(x_scale * 32, -32)).snapped(Vector2(64, 64)))
	draw_rect(Rect2(pos - Vector2(32, 32), Vector2(64, 64)), Color.yellow, false, 2)
