extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var names = $Critter.getMoveNames()
	$BattleUI.setMoves(names)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
