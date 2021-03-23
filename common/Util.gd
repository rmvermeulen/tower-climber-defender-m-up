class_name Util
extends Node

static func find_child_of_type(parent: Node, type) -> Node:
	for child in parent.get_children():
		if child is type:
			return child
	return null
