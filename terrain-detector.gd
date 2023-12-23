extends Area2D

signal terrain_event(int)

var current_map = TileMap
var current_mask: int 

var queue: Array[RID]

enum DIRECTIONS {
	NORTH = 1,
	EAST = 2,
	SOUTH = 3,
	WEST = 4
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_mask != 0:
		terrain_event.emit(current_mask)

func tileMapCollision(body: Node2D, body_rid: RID) -> void:
	current_map = body	
	var tile_coords = current_map.get_coords_for_body_rid(body_rid)
	
	for index in current_map.get_layers_count():
		var tile_data = current_map.get_cell_tile_data(index, tile_coords)
		if !tile_data is TileData:
			continue
		var terrain_mask = tile_data.get_custom_data_by_layer_id(0)
		if terrain_mask > 0:
			current_mask = terrain_mask
			queue.append(body_rid)
			break

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		tileMapCollision(body, body_rid)

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	queue.erase(body_rid)
	if queue.size() <= 0:
		current_mask = 0 # Replace with function body.

