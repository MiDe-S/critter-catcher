extends CanvasLayer

signal back
signal switch(critter: Critter)

@export var cellScene: PackedScene
@export var infoScene: PackedScene
@export var team: Team

@onready var gridContainer := $PanelContainer/MarginContainer/GridContainer

var showInfo: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Selector.connect("selection", _critterChosen)
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
	showInfo = true
	var info := infoScene.instantiate()
	info.setCritter($Selector.getCurrentSelection().getCritter())
	add_child(info)
		
func hideInfo() -> void:
	showInfo = false
	for n in get_children():
		if n is CritterInfoUI:
			n.queue_free()
	
func _emitBack() -> void:
	if !showInfo:
		back.emit()
	else:
		hideInfo()
	
func _critterChosen(critter: Node) -> void:
	if critter == null:
		back.emit()
	else:
		switch.emit(critter.getCritter())
	
