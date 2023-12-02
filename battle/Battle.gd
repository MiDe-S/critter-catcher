extends Node

var critterPath = "res://critters/critters/"
var critterFormat = ".tscn"
# on init spawn people from people

func setUpPlayers(critters, p1: bool = true):
	var s1 = load(critterPath + critters[0].getName() + critterFormat).instantiate()
	s1.setCritter(critters[0])
	if p1:
		s1.position = $LeftSpawnTop.position
	else:
		s1.position = $RightSpawnTop.position
		s1.faceLeft()
	var s2 = load(critterPath + critters[1].getName() + critterFormat).instantiate()
	s2.setCritter(critters[1])
	if p1:
		s2.position = $LeftSpawnBottom.position
	else:
		s2.position = $RightSpawnBottom.position
		s2.faceLeft()
	self.add_child(s1)
	self.add_child(s2)


# Called when the node enters the scene tree for the first time.
func _ready():
	setUpPlayers($Player.getCritters())
	setUpPlayers($Enemy.getCritters(), false)
		

	
	
	
	#$BattleUI.setMoves(names)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
