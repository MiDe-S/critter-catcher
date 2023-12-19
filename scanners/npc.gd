extends CharacterBody2D

@export var team: Team

func setTeam(teamInput):
	team = teamInput

func getCritters():
	return team.getCritters()

func isDefeated():
	return team.isDefeated()
