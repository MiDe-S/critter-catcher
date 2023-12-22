extends Camera2D

func _process(_delta):
	if offset != Vector2.ZERO:
		offset = offset.move_toward(Vector2.ZERO, 0.01)
