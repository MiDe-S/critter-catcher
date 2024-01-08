extends CharacterBody2D
class_name NPC

@export var team: Team

func setTeam(teamInput):
	team = teamInput

func getTeam() -> Team:
	return team

func getCritters():
	return team.getCritters()

func isDefeated():
	return team.isDefeated()

func interact():
	print("Here me roar")
	$BattleFactory.startScannerBattle(self)

func seen():
	$Interactable.show()
	
func unseen():
	$Interactable.hide()
