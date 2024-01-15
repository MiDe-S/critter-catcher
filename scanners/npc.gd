extends CharacterBody2D
class_name NPC

@export var team: Team

func _ready() -> void:
	if has_node("Interactable"):
		$Interactable.interacted.connect(interact)

func setTeam(teamInput: Team) -> void:
	team = teamInput

func getTeam() -> Team:
	return team

func getCritters() -> Array[Critter]:
	return team.getCritters()

func isDefeated() -> bool:
	return team.isDefeated()

func interact() -> void:
	$BattleFactory.startScannerBattle(self)
