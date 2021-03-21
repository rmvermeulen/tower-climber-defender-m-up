extends Node2D

signal block_created(pos, type)
signal block_destroyed(pos)

export var width := 16
export var height := 32

export var blocks := [{"x": 6, "y": 3, "type": 0}]
export var player := {}
