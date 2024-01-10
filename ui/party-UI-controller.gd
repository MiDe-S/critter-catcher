extends Node2D

@export var uiElement: PackedScene
var showUi = false
var element = null

func _input(event: InputEvent):
	if !event.is_action("party_ui_toggle"):
		return

	if event.is_action_pressed("party_ui_toggle"):
		print(get_tree().get_current_scene())
		showUi = !showUi
		if showUi and element == null:
			element = uiElement.instantiate()
			add_child(element)
		elif element != null:
			element.freeSelf()
			element = null

func refresh():
	if element != null:
		element.refresh()
