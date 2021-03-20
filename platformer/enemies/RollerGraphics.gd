tool
extends Node2D

export (float, 0, 1) var quality := 0.5 setget set_quality
export (bool) var anti_aliasing := true setget set_anti_aliasing


func set_quality(value: float) -> void:
	quality = value
	update()


func set_anti_aliasing(value: bool) -> void:
	anti_aliasing = value
	update()


func _draw():
	var here := Vector2.ZERO
	draw_circle(here, 32, Color.brown)
	draw_arc(here, 32, 0, TAU, 8 + int(24 * quality), Color.black, 2, anti_aliasing)
	# eyes
	for x in [-1, 1]:
		draw_circle(Vector2(10 * x, -5), 6, Color.white)
		draw_line(Vector2(18 * x, -12), Vector2(3 * x, -8), Color.black, 3, anti_aliasing)
	draw_line(Vector2(0, -12), Vector2(0, -3), Color.black)
