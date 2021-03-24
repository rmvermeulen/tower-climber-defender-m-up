extends Node2D


func _process(_delta: float) -> void:
	position = get_global_mouse_position()
	update()


func _draw():
	var pos := to_local(position.snapped(Vector2(64, 64)) - Vector2(32, 32))
	draw_rect(Rect2(pos, Vector2(64, 64)), Color.green, false, 2.0)
