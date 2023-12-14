extends Node2D

@export var critter_scene: PackedScene
@onready var spawn_cap = $GrassMap.get_spawn_cap()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$GrassMap.is_vector_inside_rect($Player.get_position())
	pass
	


func _on_critter_spawner_timeout():
	var critters = get_tree().get_nodes_in_group("critter")
	if critters.size() < spawn_cap:
		var critter = critter_scene.instantiate()
		critter.position = $GrassMap.get_random_point()
		$YSortHelper.add_child(critter)
