extends Control

@export var moveExp: Move

@onready var accuracy := $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/Accuracy
@onready var damage := $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/Damage
@onready var uses := $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/Uses 
@onready var type := $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Type
@onready var targeting := $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Targeting
@onready var nameLabel := $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Name
@onready var description := $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Desc

func _ready() -> void:
	if moveExp != null:
		_initialize(moveExp)
	else:
		_initializeEmpty()

func setMove(moveIn: Move) -> void:
	moveExp = moveIn

func _initialize(move: Move) -> void:
	accuracy.text = str(move.getAccuracy()) + "\nAccuracy"
	damage.text = str(move.getPower()) + "\nDamage"
	type.texture = load(move.getTypeIcon())
	# add targeting
	nameLabel.text = move.getName()
	description.text = move.getDescription()

func _initializeEmpty() -> void:
	accuracy.text = ""
	damage.text = ""
	type.texture = null
	uses.text = ""
	# add targeting
	nameLabel.text = ""
	description.text = ""
