extends Node2D
class_name MapManager

@export_file("*.tscn") var north:
	set(value):
		north = load(value)
@export_file("*.tscn") var east:
	set(value):
		east = load(value)
@export_file("*.tscn") var south:
	set(value):
		south = load(value)
@export_file("*.tscn") var west:
	set(value):
		west = load(value)
		
@export var debugMode := true

@onready var mapSize := GlobalVariables.AREA_PIXEL_SIZE
@onready var cameraSize: Vector2 = get_viewport().size / 3

var playerInfo

var northScene: MapManager
var eastScene: MapManager
var southScene: MapManager
var westScene: MapManager



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerInfo = PlayerManager.getPlayerInfo()
	# Load position from manager
	if has_node("YSortHelper/Player") and !debugMode:
		$YSortHelper/Player.position = PlayerManager.getPlayerPosition()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if !$YSortHelper.has_node("Player"):
		return
	var pos = $YSortHelper/Player.get_position()
	
	# North
	if pos.y < cameraSize.y:
		if (northScene == null and north != null):
			northScene = north.instantiate()
			createNeighbor(northScene, Vector2(0, -mapSize))
		# player is on other scene, do transfer
		if pos.y < 0 and northScene != null:
			transferPlayer(northScene, Vector2(0, -mapSize), Vector2(0, 5))
			northScene.southScene = self
	elif northScene != null:
		northScene.queue_free()
		northScene = null
	
	# East
	if pos.x > (mapSize - cameraSize.x):
		if (eastScene == null and east != null):
			eastScene = east.instantiate()
			createNeighbor(eastScene, Vector2(mapSize, 0))
	# player is on other scene, do transfer
		if pos.x > mapSize and eastScene != null:
			transferPlayer(eastScene, Vector2(mapSize, 0), Vector2(-5, 0))
			eastScene.westScene = self
	elif eastScene != null:
		eastScene.queue_free()
		eastScene = null

	# South
	if pos.y > (mapSize - cameraSize.y):
		if (southScene == null and south != null):
			southScene = south.instantiate()
			createNeighbor(southScene, Vector2(0, mapSize))
		# player is on other scene, do transfer
		if pos.y > mapSize and southScene != null:
			transferPlayer(southScene, Vector2(0, mapSize), Vector2(0, -5))
			southScene.northScene = self
	elif southScene != null:
		southScene.queue_free()
		southScene = null
		
	# West
	if pos.x < cameraSize.x:
		if (westScene == null and west != null):
			westScene = west.instantiate()
			createNeighbor(westScene, Vector2(-mapSize, 0))
	# player is on other scene, do transfer
		if pos.x < 0 and westScene != null:
			transferPlayer(westScene, Vector2(-mapSize, 0), Vector2(5, 0))
			westScene.eastScene = self
	elif westScene != null:
		westScene.queue_free()
		westScene = null

		
func createNeighbor(sceneNode: Node, posTransfer: Vector2) -> void:
	sceneNode.position = position + posTransfer
	sceneNode.removePlayer()
	sceneNode.set("z_index", -1)
	get_tree().get_root().add_child(sceneNode)
		
func transferPlayer(scene: Node, posTransfer: Vector2, cameraOffsetVector: Vector2) -> void:
	var player = removePlayer()
	# set relative position
	player.position -= posTransfer
	scene.addPlayer(player)
	get_tree().set_current_scene(scene)
	PlayerManager.setCurrentScene(get_tree().current_scene.get_scene_file_path())
	# fix for camera jumping
	player.get_node("Camera2D").offset = cameraOffsetVector * player.get_node("Camera2D").get_position_smoothing_speed()
	scene.set("z_index", 0)
	set("z_index", -1)
	
func addPlayer(player: CharacterBody2D) -> void:
	$YSortHelper.add_child(player)
	
func removePlayer() -> CharacterBody2D:
	var player = $YSortHelper/Player
	$YSortHelper.remove_child(player)
	return player

func get_navigation_map():
	return $NavigationRegion2D.get_navigation_map()

func setPlayerPosition(pos: Vector2) -> void:
	$YSortHelper/Player.position = pos
