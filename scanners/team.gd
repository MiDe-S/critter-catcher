extends Resource
class_name Team

@export var team: Array[Critter]

func getCritters():
	return team

func addCritter(critter: Critter):
	team.append(critter)

func isDefeated():
	for critter in team:
		if critter.health >= 0:
			return false
	return true
