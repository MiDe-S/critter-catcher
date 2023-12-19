extends Area2D
class_name CritterInstance

signal healthUpdater

@export var critter: Critter

# Called when the node enters the scene tree for the first time.
func _ready():
	critter.initialize()
	
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
	var dmg = healthInput * critter.getDamageReduction()
	healthUpdater.emit(dmg)
	critter.health -= dmg
	
func getType():
	return critter.getType()

func getLevel():
	return critter.getLevel()

func incrementTurn():
	return critter.incrementTurn()
