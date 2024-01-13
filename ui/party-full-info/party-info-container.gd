extends CanvasLayer

signal back
signal switch(critter: Critter)

@export var cellScene: PackedScene
@export var team: Team

@onready var gridContainer := $PanelContainer/MarginContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	var cellList = []
	team = PlayerManager.getPlayerInfo().getTeam()
	for i in range(0, GlobalVariables.PARTY_SIZE):
		var cell := cellScene.instantiate()
		if team != null and team.size() > i:
			cell.setCritter(team.getCritters()[i])
		gridContainer.add_child(cell)
	$Selector.connect("selection", _critterChosen)

func freeSelf():
	queue_free()
	
func refresh():
	print("Implement Refresh")
	
func startSelector():
	$Selector.setFocus(gridContainer.get_children())
	
func _emitInfo():
	print("ImplementCritterInfo")
	
func _emitBack():
	back.emit()
	
func _critterChosen(critter: Node):
	switch.emit(critter.getCritter())
	
