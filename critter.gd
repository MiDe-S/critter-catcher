#extends Resource
extends Area2D
#class_name Critter

@export var nickName: String
# replace with list of moves please
@export var move1: Move
@export var move2: Move
@export var move3: Move
@export var move4: Move

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _init(name = ""):
	nickName = name
	move1 = Move.new("Fireblast", 0)
	move2 = Move.new("Hydropump", 1)
	move3 = Move.new("Earthquake", 2)
	move4 = Move.new("Bravebird", 3)
	
func getMoveNames():
	return [move1.getName(), move2.getName(), move3.getName(), move4.getName()]
