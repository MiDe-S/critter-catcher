extends Node2D
class_name MapManager

@warning_ignore("untyped_declaration")
@export_file("*.tscn") var north:
	set(value):
		north = load(value)
@warning_ignore("untyped_declaration")
@export_file("*.tscn") var east:
	set(value):
		east = load(value)
@warning_ignore("untyped_declaration")
@export_file("*.tscn") var south:
	set(value):
		south = load(value)
@warning_ignore("untyped_declaration")
@export_file("*.tscn") var west:
	set(value):
		west = load(value)
		
@export var debugMode := true

@onready var mapSize := GlobalVariables.AREA_PIXEL_SIZE
@onready var cameraSize: Vector2 = get_viewport().size / 3

var playerInfo: PlayerInfo

var northScene: MapManager
var eastScene: MapManager
var southScene: MapManager
var westScene: MapManager



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerInfo = PlayerManager.getPlayerInfo()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !$YSortHelper.has_node("Player"):
		return
	var pos: Vector2 = $YSortHelper/Player.get_position()
	
	# North
	if pos.y < cameraSize.y:
		if (northScene == null and north != null):
			Log.debug("Loaded north map")
			northScene = north.instantiate()
			createNeighbor(northScene, Vector2(0, -mapSize))
		# player is on other scene, do transfer
		if pos.y < 0 and northScene != null:
			transferPlayer(northScene, Vector2(0, -mapSize), Vector2(0, 5))
			northScene.southScene = self
	elif northScene != null:
		Log.debug("Unloaded north map")
		northScene.queue_free()
		northScene = null
	
	# East
	if pos.x > (mapSize - cameraSize.x):
		if (eastScene == null and east != null):
			Log.debug("Loaded east map")
			eastScene = east.instantiate()
			createNeighbor(eastScene, Vector2(mapSize, 0))
	# player is on other scene, do transfer
		if pos.x > mapSize and eastScene != null:
			transferPlayer(eastScene, Vector2(mapSize, 0), Vector2(-5, 0))
			eastScene.westScene = self
	elif eastScene != null:
		Log.debug("Unloaded east map")
		eastScene.queue_free()
		eastScene = null

	# South
	if pos.y > (mapSize - cameraSize.y):
		if (southScene == null and south != null):
			Log.debug("Loaded south map")
			southScene = south.instantiate()
			createNeighbor(southScene, Vector2(0, mapSize))
		# player is on other scene, do transfer
		if pos.y > mapSize and southScene != null:
			transferPlayer(southScene, Vector2(0, mapSize), Vector2(0, -5))
			southScene.northScene = self
	elif southScene != null:
		Log.debug("Unloaded south map")
		southScene.queue_free()
		southScene = null
		
	# West
	if pos.x < cameraSize.x:
		if (westScene == null and west != null):
			Log.debug("Loaded west map")
			westScene = west.instantiate()
			createNeighbor(westScene, Vector2(-mapSize, 0))
	# player is on other scene, do transfer
		if pos.x < 0 and westScene != null:
			transferPlayer(westScene, Vector2(-mapSize, 0), Vector2(5, 0))
			westScene.eastScene = self
	elif westScene != null:
		Log.debug("Unloaded west map")
		westScene.queue_free()
		westScene = null

		
func createNeighbor(sceneNode: Node, posTransfer: Vector2) -> void:
	sceneNode.position = position + posTransfer
	sceneNode.removePlayer()
	sceneNode.set("z_index", -1)
	get_tree().get_root().add_child(sceneNode)
		
func transferPlayer(scene: Node, posTransfer: Vector2, cameraOffsetVector: Vector2) -> void:
	Log.debug("Moved to different map tile")
	var player: Player = removePlayer()
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
	var player: Player = $YSortHelper/Player
	$YSortHelper.remove_child(player)
	return player

func get_navigation_map() -> RID:
	return $NavigationRegion2D.get_navigation_map()

func setPlayerPosition(pos: Vector2) -> void:
	$YSortHelper/Player.position = pos
