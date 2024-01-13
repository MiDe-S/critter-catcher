extends Node

signal selection(index)

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
	
	$TopLeft.set_position(coords[0])
	$TopRight.set_position(coords[1])
	$BottomLeft.set_position(coords[2])
	$BottomRight.set_position(coords[3])
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
		var x = node.get_global_position().x
		var y = node.get_global_position().y
		
		coords.append(Vector2(x - scaleX * size.x / 2, y - scaleY * size.y / 2))
		coords.append(Vector2(x + scaleX * size.x / 2, y - scaleY * size.y / 2))
		coords.append(Vector2(x - scaleX * size.x / 2, y + scaleY * size.y / 2))
		coords.append(Vector2(x + scaleX * size.x / 2, y + scaleY * size.y / 2))
		options.append(coords)
	select(index)
	
func _input(event):
	if active:
		if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right") or event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up"):
			select(currentSelected + 1)
		if event.is_action_pressed("ui_accept"):
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
