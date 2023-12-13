extends Node2D

@export var critter_scene: PackedScene 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$GrassMap.is_vector_inside_rect($Player.get_position())
	pass
	


func _on_critter_spawner_timeout():
	pass # Replace with function body.
	var critter = critter_scene.instantiate()
	# pick random area in square
	# set critter position to that point
	# mob.position = mob_spawn_location.position
	add_child(critter)
