extends Resource
class_name Action

var attacker: CritterInstance
var move: Move
var defenders: Array[CritterInstance]

func _init(attackerInput: CritterInstance, moveInput: Move, defendersInput: Array[CritterInstance]) -> void:
	attacker = attackerInput
	move = moveInput
	defenders = defendersInput

func actionInfo() -> String:
	var output := ""
	output += attacker.getName()
	if move == null:
		output += " switched to "
	else:
		output += " used "
		output += move.getName()
		output += " against "
	for critter in defenders:
		output += critter.getName() + ", "
	output[-2] = "." # change last comma to period
	return output
	
func getMove() -> Move:
	return move

func getAttacker() -> CritterInstance:
	return attacker
	
func getDefenders() -> Array[CritterInstance]:
	return defenders
