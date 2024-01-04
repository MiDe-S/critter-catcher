extends Node2D

@export var playerInfo: PlayerInfo

const FILE_PATH := "user://game1.res"

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
	
func saveGame() -> void:
	var result = ResourceSaver.save(playerInfo, FILE_PATH)
	assert(result == OK, "Failed to save")
	
func loadGame() -> void:
	if ResourceLoader.exists(FILE_PATH):
		var player = ResourceLoader.load(FILE_PATH)
		if player is PlayerInfo: # Check that the data is valid
			playerInfo = player
			SceneManager.reloadGame()
