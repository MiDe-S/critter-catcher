#extends Resource
extends Area2D
#class_name Critter

@export var nickName: String
# replace with list of moves please
@export var moves: Array[Move]


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func getMoveNames():
	return moves
