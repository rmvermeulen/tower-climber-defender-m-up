extends SubGame


func _ready():
	if not state:
		return
	assert(OK == state.connect("block_created", self, "_on_block_created"))
	assert(OK == state.connect("block_destroyed", self, "_on_block_destroyed"))


func _on_block_created(pos: Vector2, type: String):
	$AdaptiveAstar.block_cell(pos, type)


func _on_block_destroyed(pos: Vector2):
	$AdaptiveAstar.clear_cell(pos)
