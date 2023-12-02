extends Area2D

@export var critter: Critter

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func getMoveNames():
	return critter.getMoves()
	
func setCritter(critter: Critter):
	critter = critter
	
func faceLeft():
	$AnimatedSprite2D.set_flip_h(true)

