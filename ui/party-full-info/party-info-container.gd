extends CanvasLayer

signal back
signal switch(critter: Critter)

@export var cellScene: PackedScene
@export var infoScene: PackedScene
@export var team: Team

@onready var gridContainer := $PanelContainer/MarginContainer/GridContainer

var infoChild: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Selector.selection.connect(_critterChosen)
	$Selector.changeHover.connect(_changeInfoChar)
	refresh()

func freeSelf() -> void:
	queue_free()

func refresh() -> void:
	for child in gridContainer.get_children():
		child.free()
	team = PlayerManager.getPlayerInfo().getTeam()
	for i: int in range(0, GlobalVariables.PARTY_SIZE):
		var cell := cellScene.instantiate()
		if team != null and team.size() > i:
			cell.setCritter(team.getCritters()[i])
		gridContainer.add_child(cell)
	
func startSelector() -> void:
	var selectableCrits: Array[PartyInfoCell] = []
	for child in gridContainer.get_children():
		if child.isActive() and !child.getCritter().isDefeated():
			selectableCrits.append(child)
	$Selector.setFocus(selectableCrits)
	
func _emitInfo() -> void:
	var info := infoScene.instantiate()
	info.setCritter($Selector.getCurrentSelection().getCritter())
	infoChild = info
	get_tree().get_root().add_child(infoChild)
		
func hideInfo() -> void:
	if infoChild != null:
		get_tree().get_root().remove_child(infoChild)
		infoChild.queue_free()
		infoChild = null

	
func _emitBack() -> void:
	if infoChild == null:
		back.emit()
	else:
		hideInfo()
	
func _critterChosen(critter: Node) -> void:
	if infoChild != null:
		hideInfo()
	if critter == null:
		back.emit()
	else:
		switch.emit(critter.getCritter())
	
func _changeInfoChar(critter: Node) -> void:
	if infoChild != null:
		infoChild.changeCritter(critter.getCritter())

func _on_swap_pressed() -> void:
	_critterChosen($Selector.getCurrentSelection())
