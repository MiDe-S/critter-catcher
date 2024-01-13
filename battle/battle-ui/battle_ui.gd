extends CanvasLayer
class_name BattleUI

signal actionChosen(event)

@export var isWildBattle := false
@export var debugMode := false

@onready var moveGrid := $ButtonContainer/MoveGrid
@onready var container := $Container
@onready var wildContainer := $ButtonContainer/WildContainer
@onready var buttonContainer := $ButtonContainer

enum BattleUIActions {
	SWITCH,
	SCAN,
	RUN
}

func setMoves(moves):
	moveGrid.setMoveButtons(moves)

# Called when the node enters the scene tree for the first time.
func _ready():
	_toggleWildBattleUI()
	moveGrid.connect("pressedMove", move_pressed)
	container.connect("back", _partyInfoBack)

	
func move_pressed(move):
	actionChosen.emit(move)
	
func switch_pressed():
	container.show()
	container.refresh()
	_toggleButtons()
	actionChosen.emit(BattleUIActions.SWITCH)
	
func scan_pressed():
	actionChosen.emit(BattleUIActions.SCAN)
	
func run_pressed():
	actionChosen.emit(BattleUIActions.RUN)
	
func setWildBattle(isWild: bool):
	isWildBattle = isWild

func _toggleWildBattleUI():
	if isWildBattle:
		wildContainer.show()
	else:
		wildContainer.hide()
		
func _toggleButtons():
	buttonContainer.visible = !buttonContainer.visible

func printText(msg: String):
	$ColorRect/RichTextLabel.add_text(msg + '\n')
	if debugMode:
		print(msg)

func _partyInfoBack():
	_toggleButtons()
	container.hide()
