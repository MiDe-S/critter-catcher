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

func setMoves(moves) -> void:
	moveGrid.setMoveButtons(moves)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_toggleWildBattleUI()
	moveGrid.connect("pressedMove", move_pressed)
	container.connect("back", _partyInfoBack)
	container.connect("switch", _switchCritter)

	
func move_pressed(move) -> void:
	actionChosen.emit(move)
	
func switch_pressed() -> void:
	container.show()
	container.refresh()
	container.startSelector()
	_toggleButtons()
	
func scan_pressed() -> void:
	actionChosen.emit(BattleUIActions.SCAN, null)
	
func run_pressed() -> void:
	actionChosen.emit(BattleUIActions.RUN, null)
	
func setWildBattle(isWild: bool) -> void:
	isWildBattle = isWild

func _toggleWildBattleUI() -> void:
	if isWildBattle:
		wildContainer.show()
	else:
		wildContainer.hide()
		
func _toggleButtons() -> void:
	buttonContainer.visible = !buttonContainer.visible

func printText(msg: String):
	$ColorRect/RichTextLabel.add_text(msg + '\n')
	if debugMode:
		print(msg)

func _partyInfoBack() -> void:
	_toggleButtons()
	container.hide()
	
func _switchCritter(critter: Critter) -> void:
	_partyInfoBack()
	if critter != null:
		actionChosen.emit(BattleUIActions.SWITCH, critter)
