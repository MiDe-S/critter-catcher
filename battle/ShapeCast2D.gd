extends ShapeCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_colliding():
		print("Yo")

func _convertDegreesRadians(degrees: float):
	return degrees * PI / 180
	
func setFacing(facing: MovementController.Directions):
	match facing:
		MovementController.Directions.UP:
			rotation = _convertDegreesRadians(180)
		MovementController.Directions.DOWN:
			rotation = 0
		MovementController.Directions.RIGHT:
			rotation = _convertDegreesRadians(270)
		MovementController.Directions.LEFT:
			rotation = _convertDegreesRadians(90)
