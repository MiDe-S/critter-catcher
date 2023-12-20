extends Node2D

@export var uiElement: PackedScene
var showUi = false
var element = null

func _input(event: InputEvent):
	if !event.is_action("party_ui_toggle"):
		return

	if event.is_action_pressed("party_ui_toggle"):
		showUi = !showUi
		if showUi and element == null:
			element = uiElement.instantiate()
			add_child(element)
		elif element != null:
			remove_child(element)
			element.queue_free()
			element = null
