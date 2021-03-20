tool
extends Node2D

export (float, -5, 5) var rotor_rps := 1.0
export (float, 0.5, 2.0) var rotor_y_scale := 0.5
export (Vector2) var rotor_offset := Vector2(0, -28)

export (float, 0, 5) var hover_freq := 1.0
export (float, 0, 5) var hover_amp := 1.0

var rotor_angle := 0.0
var hover_angle := 0.0


func _process(delta):
	rotor_angle += delta * rotor_rps * TAU
	hover_angle += delta * hover_freq * TAU
	position.y = sin(hover_angle) * hover_amp
	update()


func _draw():
	draw_circle(Vector2.ZERO, 32, Color.blue)
	draw_arc(Vector2.ZERO, 32, 0, TAU, 16, Color.black, 3, true)
	draw_circle(Vector2(12, -8), 4, Color.white)

	var points := PoolVector2Array([])
	points.resize(32)
	var step := TAU / points.size()
	var scalar := Vector2(1, rotor_y_scale)
	for i in points.size():
		var p := Vector2(40, 0).rotated(rotor_angle + i * step)
		points[i] = rotor_offset + scalar * p

	var half := points.size() / 2
	for i in half / 2:
		var ia: int = half + i
		var ib: int = points.size() - (i + 1)
		var swap = points[ia]
		points[ia] = points[ib]
		points[ib] = swap

	draw_polyline(points, Color.aliceblue, 2, true)

# end
