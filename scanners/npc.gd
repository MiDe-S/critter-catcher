extends CharacterBody2D
class_name NPC

@export var team: Team

@onready var interactable = $Interactable

func _ready():
	if interactable != null:
		interactable.interacted.connect(interact)

func setTeam(teamInput):
	team = teamInput

func getTeam() -> Team:
	return team

func getCritters():
	return team.getCritters()

func isDefeated():
	return team.isDefeated()

func interact():
	$BattleFactory.startScannerBattle(self)
