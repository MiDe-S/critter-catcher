extends ColorRect

@export var spawnInfo: Array[AreaSpawnInfo]
@export var critter_scene: PackedScene
@export var spawn_cap := 1

var total_spawned = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$GrassMap.is_vector_inside_rect($Player.get_position())
	pass
	
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
	print("Fight")
