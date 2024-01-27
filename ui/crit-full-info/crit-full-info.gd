extends CanvasLayer

@onready var moveFullInfo := preload("res://ui/crit-full-info/move-full-info.tscn")
@onready var moveContainer := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MoveContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	var move := moveFullInfo.instantiate()
	moveContainer.add_child(move)
	var move2 := moveFullInfo.instantiate()
	moveContainer.add_child(move2)
	var move3 := moveFullInfo.instantiate()
	moveContainer.add_child(move3)
	var move4 := moveFullInfo.instantiate()
	moveContainer.add_child(move4)
	pass # Replace with function body.
