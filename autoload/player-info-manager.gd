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
	Log.info("Team Healed")
	playerInfo.healParty()
	SceneManager.refreshUI()
	
func saveGame() -> void:
	Log.info("Starting Save Game")
	var result := ResourceSaver.save(playerInfo, FILE_PATH)
	if result == OK:
		Log.info("Game saved")
	else:
		Log.error("Failed to save game")
	
func loadGame() -> void:
	Log.info("Starting Load Game")
	if ResourceLoader.exists(FILE_PATH):
		var player := ResourceLoader.load(FILE_PATH)
		if player is PlayerInfo: # Check that the data is valid
			Log.info("Player Data Found")
			playerInfo = player.duplicate(true)
			SceneManager.reloadGame()
