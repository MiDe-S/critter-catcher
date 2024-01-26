extends ColorRect

@export var spawnInfo: Array[AreaSpawnInfo]
@export var critter_scene: PackedScene
@export var spawn_cap := 1
@onready
var battle_scene := preload("res://battle/battle-single/Battle.tscn")
var total_spawned := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while total_spawned <= int(spawn_cap / 2.0):
		_on_critter_spawner_timeout()
	
func getRandomPoint() -> Vector2:
	var x := randf_range(0, get_size().x)
	var y := randf_range(0, get_size().y)
	var pos := get_position()
	return pos + Vector2(x,y)

func _on_critter_spawner_timeout() -> void:
	if total_spawned < spawn_cap:
		var critter := critter_scene.instantiate()
		critter.initialize(get_parent().get_node("NavigationRegion2D"))
		critter.position = getRandomPoint()
		
		# consider frequency later
		var i := randf_range(0, spawnInfo.size())
		critter.setCritter(spawnInfo[i].generateCritter())
		critter.setTimer(randf_range(.10, .35))
		critter.connect("battle_start", _initiateCombat)
		get_parent().get_node("YSortHelper").add_child(critter)
		total_spawned += 1

func _initiateCombat(critter: Critter) -> void:
	$BattleFactory.startWildBattle(critter)
	total_spawned -= 1
