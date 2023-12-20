extends CanvasLayer
class_name BattleUI

signal actionChosen(event)

@export var isWildBattle := false

enum BattleUIActions {
	SWITCH,
	SCAN,
	RUN
}

func setMoves(moves):
	$MoveGrid.setMoveButtons(moves)

# Called when the node enters the scene tree for the first time.
func _ready():
	_toggleWildBattleUI()

	
func move_pressed(move):
	actionChosen.emit(move)
	
func switch_pressed():
	actionChosen.emit(BattleUIActions.SWITCH)
	
func scan_pressed():
	actionChosen.emit(BattleUIActions.SCAN)
	
func run_pressed():
	actionChosen.emit(BattleUIActions.RUN)
	
func setWildBattle(isWild: bool):
	isWildBattle = isWild

func _toggleWildBattleUI():
	if isWildBattle:
		$WildContainer.show()
	else:
		$WildContainer.hide()
