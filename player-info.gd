extends Resource
class_name PlayerInfo

@export var name: String
@export var team: Team
var global_position: Vector2
var current_scene: String

func getCritters():
	return team.getCritters()
