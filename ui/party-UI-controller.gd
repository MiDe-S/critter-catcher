extends Node2D

@export var uiElements: Array[PackedScene]
var showUi := false
var element: Variant = null
var current: int = 0

func _ready() -> void:
	if get_tree().current_scene.is_in_group("area"):
		cycleUI()

func _input(event: InputEvent) -> void:
	if !event.is_action("party_ui_toggle"):
		return

	if event.is_action_pressed("party_ui_toggle"):
		cycleUI()

func cycleUI() -> void:
	if !showUi and current == 0:
		element = uiElements[current].instantiate()
		add_child(element)
		showUi = true
	if showUi:
		if current < uiElements.size():
			if element != null:
				element.freeSelf()
			element = uiElements[current].instantiate()
			add_child(element)
			current += 1
		elif element != null:
			element.freeSelf()
			element = null
			current = 0

func refresh() -> void:
	if element != null:
		element.refresh()
