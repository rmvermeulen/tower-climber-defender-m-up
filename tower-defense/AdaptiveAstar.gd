extends Area2D

enum CONNECT_MODE { STRAIGHT, DIAGONAL, EXTRA }

const GRID_CELL_SIZE := 64
export (CONNECT_MODE) var connect_mode := CONNECT_MODE.DIAGONAL

onready var astar := AStar2D.new()
onready var rect := $CollisionShape2D.shape as RectangleShape2D


func _ready():
	var cell_count := rect.extents / GRID_CELL_SIZE
	var id := 0
	for y in range(-cell_count.y, cell_count.y):
		for x in range(-cell_count.x, cell_count.x):
			astar.add_point(id, Vector2(x, y), 1.0)
			id += 1
	var connected := 0
	var skipped := 0
	var max_dist: float
	match connect_mode:
		CONNECT_MODE.STRAIGHT:
			max_dist = 2
		CONNECT_MODE.DIAGONAL:
			max_dist = 3
		CONNECT_MODE.EXTRA:
			max_dist = 6
		_:
			assert(false, "Invalid connect_mode")
	prints('max dist', max_dist)
	for a in astar.get_points():
		for b in astar.get_points():
			if b <= a:
				continue
			var pa := astar.get_point_position(a)
			var pb := astar.get_point_position(b)
			if pa.distance_squared_to(pb) < max_dist:
				connected += 1
				astar.connect_points(a, b)
			else:
				skipped += 1
	prints('connected %d skipped %d' % [connected, skipped])
	assert(OK == connect("body_entered", self, "_on_body_entered"))
	assert(OK == connect("body_exited", self, "_on_body_exited"))

	for body in get_overlapping_bodies():
		_block_body_position(body)


func _on_body_entered(body: StaticBody2D) -> void:
	if not body:
		return
	_block_body_position(body)


func _on_body_exited(body: StaticBody2D) -> void:
	if not body:
		return
	_clear_body_position(body)


func _block_body_position(body: StaticBody2D) -> void:
	pass


func _clear_body_position(body: StaticBody2D) -> void:
	pass


func _draw():
	var colors := [Color.red, Color.green, Color.blue, Color.yellow]
	var cs := {}
	for id in astar.get_points():
		var idp := astar.get_point_position(id)
		for pc in astar.get_point_connections(id):
			var c := [id, pc]
			c.sort()
			var key = hash(c)
			if cs.has(key):
				continue
			cs[key] = [
				idp * GRID_CELL_SIZE,
				astar.get_point_position(pc) * GRID_CELL_SIZE,
				colors[randi() % colors.size()],
			]
	for args in cs.values():
		callv("draw_line", args)

	for id in astar.get_points():
		var pos := GRID_CELL_SIZE * astar.get_point_position(id)
		draw_circle(pos, 4, Color.black)
