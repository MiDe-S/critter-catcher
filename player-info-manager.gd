extends Node2D

@export var playerInfo: PlayerInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	# load player from save file
	pass # Replace with function body.


func getPlayerInfo():
	return playerInfo
