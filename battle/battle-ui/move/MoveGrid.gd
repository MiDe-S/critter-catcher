extends GridContainer

signal pressedMove(move: Move)

var move_button := preload("res://battle/battle-ui/move/move_button.tscn")

func setMoveButtons(moves: Array[Move]) -> void:
	var i := 0
	for move: Move in moves:
		get_children()[i].setMove(moves[i])
		i += 1
	if i < GlobalVariables.MOVE_COUNT:
		for j in range(i, GlobalVariables.MOVE_COUNT):
			get_children()[j].setEmpty()
	
func clearMoveButtons() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, GlobalVariables.MOVE_COUNT):
		var button := move_button.instantiate()
		button.add_to_group("move_button")
		add_child(button)

func pressed(move: Move) -> void:
	pressedMove.emit(move)
