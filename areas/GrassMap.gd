extends TileMap

var area: Rect2

# Called when the node enters the scene tree for the first time.
func _ready():
	find_bounds(get_used_cells(0))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Function to find the bounds of a rectangle from a list of vectors
func find_bounds(vectors: Array):
	# Ensure that the list is not empty
	if vectors.size() == 0:
		print("Error: Empty vector list.")
		area = Rect2()

	# Initialize min and max values with the first vector in the list
	var min_x = vectors[0].x
	var min_y = vectors[0].y
	var max_x = vectors[0].x
	var max_y = vectors[0].y

	# Iterate through the rest of the vectors
	for v in vectors:
		var vector = map_to_local(v)
		min_x = min(min_x, vector.x)
		min_y = min(min_y, vector.y)
		max_x = max(max_x, vector.x)
		max_y = max(max_y, vector.y)

	# Create and return a Rect2 representing the bounds
	area = Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))
	
func is_vector_inside_rect(vector: Vector2) -> bool:
	return area.has_point(vector)

func get_random_point() -> Vector2:
	var x = area.position.x + randf_range(0, area.size.x)
	var y = area.position.y + randf_range(0, area.size.y)
	return Vector2(x, y)

func get_spawn_cap():
	return floor(area.size.x * area.size.y / 3500)
