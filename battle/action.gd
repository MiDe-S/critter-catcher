extends Resource
class_name Action

var attacker: Node
var move: Move
var defenders: Array[Node]

func _init(attackerInput, moveInput, defendersInput: Array[Node]):
	attacker = attackerInput
	move = moveInput
	defenders = defendersInput

func actionInfo() -> String:
	var output = ""
	output += attacker.getName()
	output += " used "
	output += move.getName()
	output += " against "
	for critter in defenders:
		output += critter.getName() + ", "
	output[-2] = "." # change last comma to period
	return output
	
func getMove():
	return move

func getAttacker():
	return attacker
	
func getDefenders():
	return defenders
