extends Node2D

@export var playerInfo: PlayerInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	# load player from save file
	pass # Replace with function body.

func getPlayerInfo() -> PlayerInfo:
	return playerInfo

func setCurrentScene(scene: String):
	playerInfo.setCurrentScene(scene)
	
func setPlayerPosition(local_position: Vector2):
	playerInfo.setPlayerPosition(local_position)

func getCurrentScene() -> String:
	return playerInfo.getCurrentScene()
	
func getPlayerPosition() -> Vector2:
	return playerInfo.getPlayerPosition()
