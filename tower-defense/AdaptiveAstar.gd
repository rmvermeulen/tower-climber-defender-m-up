extends Area2D

enum CONNECT_MODE { STRAIGHT, STRAIGHT_AND_DIAGONAL }

const GRID_CELL_SIZE := 64.0
export (CONNECT_MODE) var connect_mode := CONNECT_MODE.STRAIGHT_AND_DIAGONAL

onready var astar := AStar2D.new()

var disabled_points := {}


func _ready():
	get_parent().set('nav', self)

	var rect := $CollisionShape2D.shape as RectangleShape2D
	var cell_count := rect.extents / GRID_CELL_SIZE

	var id := 0
	for cy in range(-cell_count.y, cell_count.y):
		for cx in range(-cell_count.x, cell_count.x):
			var pos := Vector2(cx, cy) * GRID_CELL_SIZE
			astar.add_point(id, to_global(pos), 1.0)
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


func _on_body_entered(body: StaticBody2D) -> void:
	prints(name, 'body entered', body)
	if not body:
		return
	var shape_node: CollisionShape2D = Util.find_child_of_type(body, CollisionShape2D)
	var extents := (shape_node.shape as RectangleShape2D).extents
	var rect := Rect2(body.position - extents, 2 * extents)
	var disabled := []
	for pid in astar.get_points():
		if astar.is_point_disabled(pid):
			continue
		var pos := astar.get_point_position(pid)
		if rect.has_point(pos):
			_disable_point_with_body(pid, body)
			disabled.append([pid, pos])
	prints('Astar: disabled %d points' % disabled.size(), disabled)
	update()


func _on_body_exited(body: StaticBody2D) -> void:
	if not body:
		return
	var enabled := []
	# check disabled_points for the body, and remove it wherever it is
	# if the disabled point has no more bodies disabling it, it becomes active again
	for pid in disabled_points:
		var bodies: Array = disabled_points[pid]
		# if the body is in the list, remove it
		if body in bodies:
			bodies.erase(body)
			# if the list is now empty, re-enable the point
			if bodies.empty():
				assert(disabled_points.erase(pid))
				astar.set_point_disabled(pid, false)
				enabled.append(pid)
			else:
				# point still disabled by other bodies
				disabled_points[pid] = bodies
	update()


func _disable_point_with_body(pid: int, body: PhysicsBody2D):
	if not disabled_points.has(pid):
		disabled_points[pid] = []

	var bodies: Array = disabled_points[pid]
	if bodies.find(body) >= 0:
		return
	bodies.append(body)
	disabled_points[pid] = bodies
	astar.set_point_disabled(pid)


func find_path(start: Vector2, end: Vector2, _options := {}) -> PoolVector2Array:
	return astar.get_point_path(astar.get_closest_point(start), astar.get_closest_point(end))


func _draw():
	var colors := [Color.red, Color.green, Color.blue, Color.yellow]
	var connection_cache := {}
	for point_a in astar.get_points():
		if astar.is_point_disabled(point_a):
			# skip connections to point_a
			continue
		var pos_a := to_local(astar.get_point_position(point_a))

		for point_b in astar.get_point_connections(point_a):
			if astar.is_point_disabled(point_b):
				# skip connections to point_b
				continue

			# check if we've already processed this point pair
			var c := [point_a, point_b]
			c.sort()
			var key = hash(c)
			if connection_cache.has(key):
				continue

			# compute remaining data to draw a connection
			var pos_b := to_local(astar.get_point_position(point_b))
			var color: Color = colors[randi() % colors.size()]

			# used to call draw_line, so arguments match
			connection_cache[key] = [pos_a, pos_b, color]

	for args in connection_cache.values():
		callv("draw_line", args)

	for id in astar.get_points():
		if astar.is_point_disabled(id):
			continue
		var pos := astar.get_point_position(id)
		draw_circle(to_local(pos), 4, Color.black)
