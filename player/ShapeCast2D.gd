extends ShapeCast2D

var collided: Array[Object] = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var amount: int = get_collision_count()
	if amount > 0 or !collided.is_empty():
		var newList: Array[Object] = []
		for i in amount:
			var a: Object = get_collider(i)
			newList.append(a)
		for c in collided:
			if newList.has(c):
				newList.erase(c)
			else:
				collided.erase(c)
				if c.has_node("Interactable"):
					c.get_node("Interactable").unseen()
		if !newList.is_empty():
			for n in newList:
				if n.has_node("Interactable"):
					n.get_node("Interactable").seen()
			collided.append_array(newList)

func _convertDegreesRadians(degrees: float) -> float:
	return degrees * PI / 180
	
func setFacing(facing: MovementController.Directions) -> void:
	match facing:
		MovementController.Directions.UP:
			rotation = _convertDegreesRadians(180)
		MovementController.Directions.DOWN:
			rotation = 0
		MovementController.Directions.RIGHT:
			rotation = _convertDegreesRadians(270)
		MovementController.Directions.LEFT:
			rotation = _convertDegreesRadians(90)

func interactClosest() -> void:
	# logic to pick closest
	if collided.is_empty():
		assert(false, "Nothing to interact with")
	var minVal: float
	var closestIndex: int
	var i: int = 0
	for collider in collided:
		var delta := position.distance_to(collider.position)
		if delta < minVal:
			minVal = delta
			closestIndex = i
		i += 1
	collided[closestIndex].get_node("Interactable").interact()
