extends Resource
class_name Team

@export var team: Array[Critter]

func getCritters() -> Array[Critter]:
	return team

func addCritter(critter: Critter) -> bool:
	if team.size() < GlobalVariables.PARTY_SIZE:
		team.append(critter)
		return true
	return false

func isDefeated() -> bool:
	for critter in team:
		if !critter.isDefeated():
			return false
	return true
