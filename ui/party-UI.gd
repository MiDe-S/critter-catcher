extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	var critters := PlayerManager.getPlayerInfo().getCritters()
	$CanvasLayer/Label.text = "Team:\n"
	for critter in critters:
		var output = ""
		output += critter.getName() + " "
		output += str(critter.getHealth()) + " / " + str(critter.getMaxHealth()) + " "
		output += str(critter.getAttackForCalc()) + " "
		output += str(critter.getDefenseForCalc()) + " "
		output += str(critter.getRangeAttackForCalc()) + " "
		output += str(critter.getRangeDefenseForCalc()) + " "
		output += str(critter.getSpeedForCalc()) + " "
		for move in critter.getMoves():
			output += move.getName() + " "
		output += "\n"
		$CanvasLayer/Label.text += output
	

