extends Area2D
class_name CritterInstance

signal healthUpdater

@export var critter: Critter

# Called when the node enters the scene tree for the first time.
func _ready():
	if critter == null:
		assert(false, "No critter was set for critter instance")
	critter.initialize()
	$Sprite2D.set_texture(critter.getCritterIcon())
	
func getMoves():
	return critter.getMoves()
	
func setCritter(critterInput: Critter):
	critter = critterInput
	$Sprite2D.set_texture(critter.getCritterIcon())

func getCritter():
	return critter
	
func faceLeft():
	$Sprite2D.set_flip_h(true)
	
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
	
func isDefeated() -> bool:
	return critter.isDefeated()

func getExpGiven() -> int:
	return critter.getExpGiven()

func gainExperience(experience: int) -> void:
	return critter.gainExperience(experience)
