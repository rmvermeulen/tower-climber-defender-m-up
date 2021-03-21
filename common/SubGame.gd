class_name SubGame
extends Node

const GameState := preload("res://common/GameState.gd")

onready var state: GameState = get_parent()


func _ready():
	pass


func _process(_delta: float):
	if Engine.editor_hint:
		pass
	else:
		pass
