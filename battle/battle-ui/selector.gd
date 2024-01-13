extends Node

signal selection(obj: Node)

var optionsNodes = []
var options = []
var currentSelected: int = 0
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	pass # Replace with function body.


func hide():
	for node in self.get_children():
		node.hide()
		
func show():
	for node in self.get_children():
		node.show()
		node.get_child(0).play()
		
func select(index: int):
	if index >= options.size():
		index = 0
	var coords = options[index]
	
	$TopLeft.set_global_position(coords[0])
	$TopRight.set_global_position(coords[1])
	$BottomLeft.set_global_position(coords[2])
	$BottomRight.set_global_position(coords[3])
	currentSelected = index

func setFocus(focusableList, index: int = 0):
	show()
	active = true
	options = []
	optionsNodes = focusableList;
	for node in focusableList:
		var coords = []
		var scaleX = node.get_scale().y
		var scaleY = node.get_scale().y
		var size = getNodeSize(node)
		var pos = getNodePosition(node)
		
		coords.append(Vector2(pos.x - scaleX * size.x / 2, pos.y - scaleY * size.y / 2))
		coords.append(Vector2(pos.x + scaleX * size.x / 2, pos.y - scaleY * size.y / 2))
		coords.append(Vector2(pos.x - scaleX * size.x / 2, pos.y + scaleY * size.y / 2))
		coords.append(Vector2(pos.x + scaleX * size.x / 2, pos.y + scaleY * size.y / 2))
		options.append(coords)
	select(index)
	
func _unhandled_input(event):
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


func deactivate():
	active = false
	hide()
	
func getNodeSize(node):
	if node.has_node("CollisionShape2D"):
		return node.get_node("CollisionShape2D").shape.get_size()
	if node is PanelContainer:
		return node.get_size()
	# TODO change to use object type
	assert(false, "Unknown group in selecter options")

func getNodePosition(node) -> Vector2:
	if node is PanelContainer:
		# pos is top left corner, return center
		return node.get_global_position() + node.get_size() / 2
	return node.get_global_position()
