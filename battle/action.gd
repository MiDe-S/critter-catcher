extends Resource
class_name Action

@export var attacker: CritterInstance
@export var move: Move
@export var defenders: Array[CritterInstance]

func _init(attackerInput, moveInput, defendersInput: Array[CritterInstance]):
	attacker = attackerInput
	move = moveInput
	defenders = defendersInput

func printInfo():
	var output = ""
	output += attacker.getName()
	output += " used "
	output += move.getName()
	output += " against "
	for critter in defenders:
		output += critter.getName() + ", "
	print(output)
