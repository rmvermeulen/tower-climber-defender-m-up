extends Enemy

const TowerDefense := preload("res://tower-defense/TowerDefense.gd")

onready var game: TowerDefense = get_parent()

var target: Node2D = null
var path: PoolVector2Array = []


func _ready():
	_find_target()


func _find_target():
	var towers := get_tree().get_nodes_in_group("towers")
	if towers.empty():
		return
	towers.sort_custom(self, "_sort_by_proximity")
	target = towers[0]
	path = game.nav.find_path(position, target.position)
	prints(name, path)


func _sort_by_proximity(a, b):
	var da := position.distance_squared_to(a.position)
	var db := position.distance_squared_to(b.position)
	return da < db
