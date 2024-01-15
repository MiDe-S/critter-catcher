extends Area2D
class_name TerrainDetector

signal terrain_event(num: int)

var current_map: TileMap
var current_mask: int 

var queue: Array[RID]

enum DIRECTIONS {
	NORTH = 1,
	EAST = 2,
	SOUTH = 3,
	WEST = 4
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_mask != 0:
		terrain_event.emit(current_mask)

func tileMapCollision(body: Node2D, body_rid: RID) -> void:
	current_map = body	
	var tile_coords: Vector2i = current_map.get_coords_for_body_rid(body_rid)
	
	for index in current_map.get_layers_count():
		var tile_data: TileData = current_map.get_cell_tile_data(index, tile_coords)
		if !tile_data is TileData:
			continue
		var terrain_mask: int = tile_data.get_custom_data_by_layer_id(0) as int
		if terrain_mask > 0:
			current_mask = terrain_mask
			queue.append(body_rid)
			break

func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMap:
		tileMapCollision(body, body_rid)

func _on_body_shape_exited(body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	queue.erase(body_rid)
	if queue.size() <= 0:
		current_mask = 0 # Replace with function body.

