extends CanvasLayer

func setMoves(moves):
	$MoveGrid.clearMoveButtons()
	$MoveGrid.createMoveButtons(moves)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
