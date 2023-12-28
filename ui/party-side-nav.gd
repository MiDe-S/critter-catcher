extends PathFollow2D

signal finished

@export var reverse: bool = false

const SPEED := 800

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if reverse:
		self.set_progress( self.get_progress() - SPEED * delta)
		if self.get_progress_ratio() <= 0:
			finished.emit()
	else:
		self.set_progress(self.get_progress() + SPEED * delta)
		#if self.get_progress_ratio() >= 1:
			#finished.emit()
