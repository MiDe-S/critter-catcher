extends CharacterBody2D

@export var team: Team


func getCritters():
	return team.getCritters()
