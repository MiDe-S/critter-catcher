extends Node
class_name Selector

signal selection(obj: Variant)
signal changeHover(obj: Variant)

var optionsNodes: Array[Variant] = []
var options: Array[Variant] = []
var currentSelected: int = 0
var active := false

enum Direction {
	LEFT,
	UP,
	RIGHT,
	DOWN
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.

func hide() -> void:
	for node in self.get_children():
		node.hide()
		
func show() -> void:
	for node in self.get_children():
		node.show()
		node.get_child(0).play()
		
func select(index: int) -> void:
	if index >= options.size():
		index = 0
	var coords: Array[Vector2] = options[index]
	
	$TopLeft.set_global_position(coords[0])
	$TopRight.set_global_position(coords[1])
	$BottomLeft.set_global_position(coords[2])
	$BottomRight.set_global_position(coords[3])
	currentSelected = index
	changeHover.emit(optionsNodes[currentSelected])

func setFocus(focusableList: Array[Variant], index: int = 0) -> void:
	show()
	active = true
	options = []
	optionsNodes = focusableList;
	for node: Variant in focusableList:
		var coords: Array[Vector2] = []
		var scaleX: float = node.get_scale().y
		var scaleY: float = node.get_scale().y
		var size: Vector2 = getNodeSize(node)
		var pos: Vector2 = getNodePosition(node)
		
		coords.append(Vector2(pos.x - scaleX * size.x / 2, pos.y - scaleY * size.y / 2))
		coords.append(Vector2(pos.x + scaleX * size.x / 2, pos.y - scaleY * size.y / 2))
		coords.append(Vector2(pos.x - scaleX * size.x / 2, pos.y + scaleY * size.y / 2))
		coords.append(Vector2(pos.x + scaleX * size.x / 2, pos.y + scaleY * size.y / 2))
		options.append(coords)
	select(index)
	
func _input(event: InputEvent) -> void:
	if active and event is InputEventKey:
		get_tree().get_root().set_input_as_handled()
		if event.is_action_pressed("ui_left"):
			_directionChooser(Direction.LEFT)
		if event.is_action_pressed("ui_right"):
			_directionChooser(Direction.RIGHT)
		if event.is_action_pressed("ui_down"):
			_directionChooser(Direction.DOWN)
		if event.is_action_pressed("ui_up"):
			_directionChooser(Direction.UP)
		if event.is_action_released("ui_accept"):
			deactivate()
			selection.emit(optionsNodes[currentSelected])
		if event.is_action_pressed("ui_back"):
			deactivate()
			selection.emit(null)


func _directionChooser(direction: Direction) -> void:
	var curSelectedPos: Vector2 = getNodePosition(optionsNodes[currentSelected])
	var i: int = 0
	var minIndex: int
	var minDistance: float = 2000
	for node: Node in optionsNodes:
		var comparPosition: Vector2 = getNodePosition(node)
		var comparDirection: Vector2 = comparPosition - curSelectedPos
		# current node
		if comparDirection == Vector2.ZERO:
			i += 1
			continue
		comparDirection *= Vector2(1, -1) # godot y cord is inverse of regular
		match direction:
			# if comparPosition in range, do min distance check
			Direction.LEFT:
				if comparDirection.angle() >= 3 * PI / 4 or comparDirection.angle() <= -3 * PI / 4:
					if curSelectedPos.distance_to(comparPosition) < minDistance:
						minIndex = i
						minDistance = curSelectedPos.distance_to(comparPosition)
			Direction.UP:
				if comparDirection.angle() >=  PI / 4 and comparDirection.angle() <= 3 * PI / 4:
					if curSelectedPos.distance_to(comparPosition) < minDistance:
						minIndex = i
						minDistance = curSelectedPos.distance_to(comparPosition)
			Direction.RIGHT:
				if comparDirection.angle() <=  PI / 4 and comparDirection.angle() >= - PI / 4:
					if curSelectedPos.distance_to(comparPosition) < minDistance:
						minIndex = i
						minDistance = curSelectedPos.distance_to(comparPosition)
			Direction.DOWN:
				if comparDirection.angle() <=  -PI / 4 and comparDirection.angle() >= -3 * PI / 4:
					if curSelectedPos.distance_to(comparPosition) < minDistance:
						minIndex = i
						minDistance = curSelectedPos.distance_to(comparPosition)
		i += 1
	if minIndex != null:
		select(minIndex)
	#select(currentSelected + 1)

func deactivate() -> void:
	active = false
	hide()
	
func getNodeSize(node: Variant) -> Vector2:
	if node.has_node("CollisionShape2D"):
		return node.get_node("CollisionShape2D").shape.get_size()
	if node is PanelContainer or node is ColorRect:
		return node.get_size()
	# TODO change to use object type
	assert(false, "Unknown group in selecter options")
	return Vector2.ZERO

func getNodePosition(node: Variant) -> Vector2:
	if node is PanelContainer or node is ColorRect:
		# pos is top left corner, return center
		return node.get_global_position() + node.get_size() / 2
	return node.get_global_position()

func getCurrentSelection() -> Variant:
	return optionsNodes[currentSelected]
