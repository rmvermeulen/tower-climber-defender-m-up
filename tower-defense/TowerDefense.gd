extends SubGame


func _ready():
	if not state:
		return
	assert(OK == state.connect("block_created", self, "_on_block_created"))
	assert(OK == state.connect("block_destroyed", self, "_on_block_destroyed"))


func _on_block_created(pos: Vector2, type: String):
	# TODO: use type
	var shape := RectangleShape2D.new()
	shape.extents = Vector2(32, 32)
	var shape_node := CollisionShape2D.new()
	shape_node.shape = shape
	var body := StaticBody2D.new()
	body.add_child(shape_node)

	add_child(body)


func _on_block_destroyed(pos: Vector2):
	for child in get_children():
		if child is StaticBody2D && child.position == pos:
			remove_child(child)
			child.queue_free()
			break
