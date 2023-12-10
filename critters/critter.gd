extends Area2D
class_name CritterInstance

signal healthUpdater

@export var critter: Critter

# Called when the node enters the scene tree for the first time.
func _ready():
	critter.initialize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func getMoves():
	return critter.getMoves()
	
func setCritter(critterInput: Critter):
	critter = critterInput

func getCritter():
	return critter
	
func faceLeft():
	$AnimatedSprite2D.set_flip_h(true)
	
func getName():
	return critter.getName()

func getSigName():
	return "healthUpdater"

func dealDamage(healthInput: float):
	healthUpdater.emit(healthInput * critter.getDamageReduction())
	
func getType():
	return critter.getType()

func getLevel():
	return critter.getLevel()

func incrementTurn():
	return critter.incrementTurn()
