extends Resource
class_name Team

@export var team: Array[Critter]

func getCritters():
	return team

func addCritter(critter: Critter):
	team.append(critter)
