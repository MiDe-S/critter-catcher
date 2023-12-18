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
		
		# consider frequency later
		var i = randf_range(0, spawnInfo.size())
		critter.setCritter(spawnInfo[i].generateCritter())
		critter.connect("battle_start", _initiateCombat)
		get_tree().current_scene.get_node("YSortHelper").add_child(critter)
		total_spawned += 1

func _initiateCombat(critter: Critter):
	$BattleFactory.startWildBattle(critter)
