extends Enemy

const TowerDefense := preload("res://tower-defense/TowerDefense.gd")

onready var game: TowerDefense = get_parent()

var target: Node2D = null
var path: PoolVector2Array = []
var path_index := -1


func _ready():
	_find_target()


func _find_target():
	var towers := get_tree().get_nodes_in_group("towers")
	if towers.empty():
		return
	towers.sort_custom(self, "_sort_by_proximity")
	target = towers[0]
	path = game.nav.find_path(position, target.position)
	path_index = 0
	prints(name, path)


func _sort_by_proximity(a, b):
	var da := position.distance_squared_to(a.position)
	var db := position.distance_squared_to(b.position)
	return da < db


func _physics_process(delta: float):
	if path.empty() || path_index >= path.size():
		return
	var dst := _get_current_destination()
	var diff := dst - position

	position += diff.normalized() * 50 * delta


func _get_current_destination() -> Vector2:
	assert(not path.empty())
	if path_index >= path.size():
		return position
	var point := path[path_index]
	if position.distance_squared_to(point) < 10:
		path_index += 1
		return _get_current_destination()
	return point


func _draw():
	draw_circle(Vector2.ZERO, 24, Color.blue)
	draw_arc(Vector2.ZERO, 24, 0, TAU, 16, Color.darkblue)
