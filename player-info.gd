extends Resource
class_name PlayerInfo

@export var name: String
@export var team: Team
var global_position: Vector2
var current_scene: String

func getCritters() -> Array[Critter]:
	return team.getCritters()

func isDefeated():
	return team.isDefeated()
	
func addCritter(critter: Critter):
	team.addCritter(critter)
