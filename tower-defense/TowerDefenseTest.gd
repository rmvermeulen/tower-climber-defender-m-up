extends SubGame


func _ready():
	assert(OK == self.state.connect("block_created", self, "_on_block_created"))
	assert(OK == self.state.connect("block_destroyed", self, "_on_block_destroyed"))


func _on_block_created(pos: Vector2, type: String):
	pass


func _on_block_destroyed(pos: Vector2):
	pass
