extends Node2D

@export var mapUiScenes: Array[PackedScene]

var _mapScenes: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in mapUiScenes:
		get_tree().get_root().add_child.call_deferred(n.instantiate())
		


# Scenarios
# Main -> Area
# Area -> Area - Let Mapmanager handle
# Area -> Battle
# Battle -> Area
func startScene(newScene: Node) -> void:
	var oldScene = get_tree().current_scene
	if oldScene is MapManager and newScene is Battle:
		#hide ui/map elements
		_mapScenes = get_tree().get_nodes_in_group("area")
		var root = get_tree().get_root()
		root.add_child(newScene)
		get_tree().set_current_scene(newScene)
		for c in _mapScenes:
			root.remove_child(c)
		return
	if oldScene is Battle and newScene is MapManager:
		# show UI elements
		# refresh UI elements
		return
	if oldScene is MapManager and newScene is MapManager:
		# show UI elements
		# refresh UI elements
		return
	assert(false, "No scenes configured for going to " + str(oldScene.get_class()) + " from " + str(newScene.get_class()))
		
func endScene() -> void:
	var oldScene = get_tree().current_scene
	if oldScene is Battle:
		if _mapScenes == null or _mapScenes.size() == 0:
			assert(false, "No old scene to switch to")
		for n in _mapScenes:
			# refresh map UI
			if n.is_in_group("ui"):
				n.refresh()
			get_tree().get_root().add_child(n)
			if n.get_scene_file_path() == PlayerManager.getCurrentScene():
				get_tree().set_current_scene(n)

		oldScene.queue_free()

func reloadGame() -> void:
	# set player pos from player info
	# start scene from player info
	_mapScenes = get_tree().get_nodes_in_group("area")
	var root = get_tree().get_root()
	# Switch to empty scene so currentScene isn't deleted
	var blank = Node2D.new()
	get_tree().get_root().add_child(blank)
	get_tree().set_current_scene(blank)
	for c in _mapScenes:
		if !c.is_in_group("ui"):
			c.queue_free()
	get_tree().change_scene_to_file(PlayerManager.getCurrentScene())
