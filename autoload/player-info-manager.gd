extends Node2D

@export var playerInfo: PlayerInfo

const FILE_PATH := "user://game1.res"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# load player from save file, otherwise
	if get_tree().current_scene is MapManager:
		playerInfo.setCurrentScene(get_tree().current_scene.get_scene_file_path())

func getPlayerInfo() -> PlayerInfo:
	return playerInfo

func setCurrentScene(scene: String) -> void:
	playerInfo.setCurrentScene(scene)
	
func setPlayerPosition(local_position: Vector2) -> void:
	playerInfo.setPlayerPosition(local_position)

func getCurrentScene() -> String:
	return playerInfo.getCurrentScene()
	
func getPlayerPosition() -> Vector2:
	return playerInfo.getPlayerPosition()
	
func healParty() -> void:
	playerInfo.healParty()
	SceneManager.refreshUI()
	
func saveGame() -> void:
	var result := ResourceSaver.save(playerInfo, FILE_PATH)
	assert(result == OK, "Failed to save")
	
func loadGame() -> void:
	if ResourceLoader.exists(FILE_PATH):
		var player := ResourceLoader.load(FILE_PATH)
		if player is PlayerInfo: # Check that the data is valid
			print(PlayerManager.getPlayerPosition(), player.getPlayerPosition())
			playerInfo = player.duplicate(true)
			SceneManager.reloadGame()
