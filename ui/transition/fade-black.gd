extends Transition

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	super._process(_delta)
	# go to black
	if isFadeOut:
		var currentColor: Color = $ColorRect.get_color()
		currentColor.a = 1 - fade_time / maxTime
		$ColorRect.set_color(currentColor)
	# go to scene
	else:
		var currentColor: Color = $ColorRect.get_color()
		currentColor.a = fade_time / maxTime
		$ColorRect.set_color(currentColor)
