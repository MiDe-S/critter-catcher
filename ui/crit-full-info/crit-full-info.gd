extends CanvasLayer
class_name CritterInfoUI

signal exp

@export var critter: Critter

@onready var moveFullInfo := preload("res://ui/crit-full-info/move-full-info.tscn")
@onready var moveContainer := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MoveContainer
@onready var critName := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Name
@onready var typeContainer := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/TypeContainer
@onready var critImage := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/TextureRect
@onready var expBar := $PanelContainer/MarginContainer/VBoxContainer/Control/ExpBar
@onready var level := $PanelContainer/MarginContainer/VBoxContainer/Control/Label

@onready var health := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/StatsContainer/Health
@onready var atk := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/StatsContainer/Attack
@onready var def := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/StatsContainer/Defense
@onready var rnge := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/StatsContainer/Range
@onready var rnge_def := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/StatsContainer/RangeDefense
@onready var speed := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/StatsContainer/Speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if critter != null:
		critName.text = critter.getNickname()
		var types := critter.getType()
		for type in types:
			var label := Label.new()
			label.text = type.getName()
			typeContainer.add_child(label)
		critImage.texture = critter.getCritterIcon()
		# add item
		# add abilities
		var moves := critter.getMoves()
		for move in moves:
			var moveObj := moveFullInfo.instantiate()
			moveObj.setMove(move)
			moveContainer.add_child(moveObj)
		while moveContainer.get_child_count() < 4:
			var moveObj := moveFullInfo.instantiate()
			moveContainer.add_child(moveObj)
		# set exp
		expBar.initialize("exp", critter.getExperience())
		expBar.set_max(critter.getExpNeeded())
		level.text = "Level: " + str(critter.getLevel())
		
		# stats
		health.text = str(critter.getHealth()) + " / " + str(critter.getMaxHealth()) + " HP"
		atk.text = str(critter.getAttackForCalc()) + " ATK"
		def.text = str(critter.getDefenseForCalc()) + " DEF"
		rnge.text = str(critter.getRangeAttackForCalc()) + " RANGE"
		rnge_def.text = str(critter.getRangeDefenseForCalc()) + " RANGE DEF"
		speed.text = str(critter.getSpeedForCalc()) + " SPEED"

func setCritter(critterInput: Critter) -> void:
	critter = critterInput
