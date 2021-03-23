extends Area2D

enum CONNECT_MODE { STRAIGHT, STRAIGHT_AND_DIAGONAL }

const GRID_CELL_SIZE := 64.0
export (CONNECT_MODE) var connect_mode := CONNECT_MODE.STRAIGHT_AND_DIAGONAL

onready var astar := AStar2D.new()
onready var rect := $CollisionShape2D.shape as RectangleShape2D


func _ready():
	var cell_count := rect.extents / GRID_CELL_SIZE
	var id := 0
	for cy in range(-cell_count.y, cell_count.y):
		for cx in range(-cell_count.x, cell_count.x):
			var pos := Vector2(cx, cy) * GRID_CELL_SIZE
			astar.add_point(id, pos, 1.0)
			id += 1
	var connected := 0
	var skipped := 0
	var max_dist: float
	match connect_mode:
		CONNECT_MODE.STRAIGHT:
			max_dist = pow(GRID_CELL_SIZE * 1.1, 2)
		CONNECT_MODE.STRAIGHT_AND_DIAGONAL:
			max_dist = pow(GRID_CELL_SIZE * 1.5, 2)
		_:
			assert(false, "Invalid connect_mode")
	prints('max dist', max_dist)
	for a in astar.get_points():
		for b in astar.get_points():
			if b <= a:
				continue
			var pa := astar.get_point_position(a)
			var pb := astar.get_point_position(b)
			var d := pa.distance_squared_to(pb)
			if d < max_dist:
				connected += 1
				astar.connect_points(a, b)
			else:
				skipped += 1
	prints('connected %d skipped %d' % [connected, skipped])
	assert(OK == connect("body_entered", self, "_on_body_entered"))
	assert(OK == connect("body_exited", self, "_on_body_exited"))

	while is_inside_tree():
		yield(get_tree().create_timer(5.0), "timeout")
		update()


func _on_body_entered(body: StaticBody2D) -> void:
	if not body:
		return
	block_cell(body.position, 0)


func _on_body_exited(body: StaticBody2D) -> void:
	if not body:
		return
	clear_cell(body.position)


func block_cell(pos: Vector2, type: int) -> void:
	var pid := astar.get_closest_point(pos)
	astar.set_point_disabled(pid)


func clear_cell(pos: Vector2) -> void:
	var pid := astar.get_closest_point(pos, true)
	astar.set_point_disabled(pid, false)


func find_path(start: Vector2, end: Vector2, _options := {}) -> PoolVector2Array:
	return astar.get_simple_path(start, end)


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
				idp,
				astar.get_point_position(pc),
				colors[randi() % colors.size()],
			]
	for args in cs.values():
		callv("draw_line", args)

	for id in astar.get_points():
		var pos := astar.get_point_position(id)
		draw_circle(pos, 4, Color.black)
