extends Area2D
class_name CritterInstance

signal healthUpdater
signal battleMessage(msg: String)

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
	battleMessage.emit("Health was " + str(critter.getHealth()) + " now " + str(snappedf(critter.getHealth() - dmg, .01)) + ": " + str(snappedf(dmg, .01)) + " damage")
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
	var oldLevel = getLevel()
	var newLevel = critter.gainExperience(experience)
	if newLevel != oldLevel:
		battleMessage.emit(getName() + " leveled up to " + str(newLevel) + ".")
