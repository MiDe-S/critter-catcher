extends Resource
class_name PlayerInfo

@export var name: String
@export var team: Team
@export var local_position: Vector2
@export var current_scene: String

func getCritters() -> Array[Critter]:
	return team.getCritters()

func isDefeated() -> bool:
	return team.isDefeated()
	
func addCritter(critter: Critter):
	team.addCritter(critter)

func getTeam() -> Team:
	return team

func setTeam(teamInput: Team) -> void:
	team = teamInput

func setCurrentScene(scene: String) -> void:
	current_scene = scene
	
func setPlayerPosition(pos: Vector2) -> void:
	local_position = pos

func getCurrentScene() -> String:
	return current_scene
	
func getPlayerPosition() -> Vector2:
	return local_position
