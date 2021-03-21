class_name SubGame
extends Node

onready var state := get_parent()


func _ready():
	pass


func _process(_delta: float):
	if Engine.editor_hint:
		pass
	else:
		pass
