extends Node

signal selection(obj: Variant)

var optionsNodes: Array[Variant] = []
var options: Array[Variant] = []
var currentSelected: int = 0
var active := false

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
	
func _unhandled_input(event: InputEvent) -> void:
	if active and event is InputEventKey:
		get_tree().get_root().set_input_as_handled()
		if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right") or event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up"):
			select(currentSelected + 1)
		if event.is_action_released("ui_accept"):
			deactivate()
			selection.emit(optionsNodes[currentSelected])
		if event.is_action_pressed("ui_back"):
			deactivate()
			selection.emit(null)


func deactivate() -> void:
	active = false
	hide()
	
func getNodeSize(node: Variant) -> Vector2:
	if node.has_node("CollisionShape2D"):
		return node.get_node("CollisionShape2D").shape.get_size()
	if node is PanelContainer:
		return node.get_size()
	# TODO change to use object type
	assert(false, "Unknown group in selecter options")
	return Vector2.ZERO

func getNodePosition(node: Variant) -> Vector2:
	if node is PanelContainer:
		# pos is top left corner, return center
		return node.get_global_position() + node.get_size() / 2
	return node.get_global_position()
