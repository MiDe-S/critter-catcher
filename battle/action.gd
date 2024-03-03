extends Resource
class_name Action

var attacker: CritterInstance
var move: Move
var defenders: Array[int]

func _init(attackerInput: CritterInstance, moveInput: Move, defendersInput: Array[int]) -> void:
	attacker = attackerInput
	move = moveInput
	defenders = defendersInput

func actionInfo() -> String:
	if move == null:
		return ""
	var output := ""
	output += attacker.getName()
	output += " used "
	output += move.getName()
	output += " against "
	for pos in defenders:
		output += str(pos) + ", "
	output[-2] = "." # change last comma to period
	return output
	
func getMove() -> Move:
	return move

func getAttacker() -> CritterInstance:
	return attacker
	
func getDefenders() -> Array[int]:
	return defenders
