extends CanvasLayer
class_name Transition

signal screenBlack()

@export var fade_time: float = 0.15

@onready var maxTime: float = fade_time

var isFadeOut: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fade_time -= delta
	if fade_time <= 0:
		if isFadeOut:
			screenBlack.emit()
			fade_time = maxTime
			isFadeOut = false
		else:
			queue_free()
		
