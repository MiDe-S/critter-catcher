extends CanvasLayer

signal back
signal switch(critter: Critter)

@export var cellScene: PackedScene
@export var team: Team

@onready var gridContainer := $PanelContainer/MarginContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	team = PlayerManager.getPlayerInfo().getTeam()
	for i: int in range(0, GlobalVariables.PARTY_SIZE):
		var cell := cellScene.instantiate()
		if team != null and team.size() > i:
			cell.setCritter(team.getCritters()[i])
		gridContainer.add_child(cell)
	$Selector.connect("selection", _critterChosen)

func freeSelf() -> void:
	queue_free()
	
func refresh() -> void:
	print("Implement Refresh")
	
func startSelector() -> void:
	var selectableCrits: Array[PartyInfoCell] = []
	for child in gridContainer.get_children():
		if child.isActive() and !child.getCritter().isDefeated():
			selectableCrits.append(child)
	$Selector.setFocus(selectableCrits)
	
func _emitInfo() -> void:
	print("ImplementCritterInfo")
	
func _emitBack() -> void:
	back.emit()
	
func _critterChosen(critter: Node) -> void:
	if critter == null:
		back.emit()
	else:
		switch.emit(critter.getCritter())
	
