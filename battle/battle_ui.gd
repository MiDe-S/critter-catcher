extends CanvasLayer

signal moveChosen(move: Move)

func setMoves(moves):
	$MoveGrid.clearMoveButtons()
	$MoveGrid.createMoveButtons(moves)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
func pressed(move):
	moveChosen.emit(move)
