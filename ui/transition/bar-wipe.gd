extends Transition

var total_size: int

func _ready() -> void:
	total_size = $RightContainer.get_size().x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	super._process(_delta)
	# assume width of container is width of screen
	if isFadeOut:
		var current_pos: Vector2 = $RightContainer.get_position()
		current_pos.x = int(fade_time / maxTime * total_size)
		$RightContainer.set_position(current_pos)
		
		var current_posL: Vector2 = $LeftContainer.get_position()
		current_posL.x = int((1 - fade_time / maxTime) * total_size - total_size)
		$LeftContainer.set_position(current_posL)
	# go to scene
	else:
		var current_pos: Vector2 = $RightContainer.get_position()
		current_pos.x = int(fade_time / maxTime * total_size - total_size)
		$RightContainer.set_position(current_pos)
		
		var current_posL: Vector2 = $LeftContainer.get_position()
		current_posL.x = int((1 - fade_time / maxTime) * total_size)
		$LeftContainer.set_position(current_posL)
