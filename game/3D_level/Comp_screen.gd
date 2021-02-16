extends MeshInstance

func _ready() -> void:
	# Get the viewport and clear it
	var viewport :Object = $Viewport
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	material_override.albedo_texture = viewport.get_texture()

