extends PanelContainer
class_name PartyInfoCell

signal health
signal exp

@export var critter: Critter

@onready var nameLabel := $MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/Name
@onready var levelLabel := $MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/Level
@onready var critterSprite := $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Sprite
@onready var itemLabel := $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Item
@onready var moveLabel := $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Moves
@onready var abilityLabel := $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Ability
@onready var healthBar := $MarginContainer/VBoxContainer/VBoxContainer/Health
@onready var expBar := $MarginContainer/VBoxContainer/VBoxContainer/Exp

var isInit := false

# Called when the node enters the scene tree for the first time.
func _ready():
	if critter != null and isInit:
		initialize()

func setCritter(critterInput: Critter):
	critter = critterInput
	isInit = true
	

func initialize():
	nameLabel.text = critter.getName()
	levelLabel.text = str(critter.getLevel())
	critterSprite.texture = critter.getCritterIcon()
	itemLabel.text = "None"
	abilityLabel.text = "None"
	healthBar.initialize("health", critter.getHealth())
	healthBar.set_max(critter.getMaxHealth())
	expBar.initialize("exp", critter.getExperience())
	expBar.set_max(critter.getExpNeeded())
	
	var moves := critter.getMoves()
	var output: String = ""
	for move in moves:
		output += move.getName() + "\n"
	output = output.rstrip("\n") # remove extra \n from end
	moveLabel.text = output
