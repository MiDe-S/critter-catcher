extends ColorRect

@export var spawnInfo: Array[AreaSpawnInfo]
@export var critter_scene: PackedScene
@export var spawn_cap := 1

var battle_scene = preload("res://battle/battle-single/Battle.tscn")
var total_spawned = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func getRandomPoint():
	var x = randf_range(0, get_size().x)
	var y = randf_range(0, get_size().y)
	return get_position() + Vector2(x,y)

func _on_critter_spawner_timeout():
	if total_spawned < spawn_cap:
		var critter = critter_scene.instantiate()
		critter.position = getRandomPoint()
		critter.connect("battle_start", _initiateCombat)
		get_tree().current_scene.get_node("YSortHelper").add_child(critter)
		total_spawned += 1

func _initiateCombat():
	var battle = battle_scene.instantiate()
	var current = get_tree().current_scene
	battle.setMapScene(current)
	get_tree().get_root().add_child(battle)
	get_tree().get_root().remove_child(current)
