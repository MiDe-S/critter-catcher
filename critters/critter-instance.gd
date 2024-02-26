extends Area2D
class_name CritterInstance

signal healthUpdater
signal battleMessage(msg: String)

@export var critter: Critter

var isInBattle := false
var battlePosition: int = -1 # -1 is out of battle since no null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if critter == null:
		assert(false, "No critter was set for critter instance")
	critter.initialize()
	$Sprite2D.set_texture(critter.getCritterIcon())
	
func getMoves() -> Array[Move]:
	return critter.getMoves()
	
func setCritter(critterInput: Critter) -> void:
	critter = critterInput
	if has_node("Sprite2D"):
		$Sprite2D.set_texture(critter.getCritterIcon())

func getCritter() -> Critter:
	return critter
	
func faceLeft() -> void:
	$Sprite2D.set_flip_h(true)
	
func getName() -> String:
	return critter.getName()

func getSigName() -> String:
	return "healthUpdater"

func dealDamage(healthInput: float) -> void:
	var dmg: float = healthInput * critter.getDamageReduction()
	battleMessage.emit("Health was " + str(snappedf(critter.getHealth(), .01)) + " now " + str(snappedf(critter.getHealth() - dmg, .01)) + ": " + str(snappedf(dmg, .01)) + " damage")
	healthUpdater.emit(dmg)
	critter.setHealth(critter.getHealth() - dmg)
	
func getType() -> Array[Type]:
	return critter.getType()

func getLevel() -> int:
	return critter.getLevel()

func incrementTurn() -> void:
	critter.incrementTurn()
	
func isDefeated() -> bool:
	return critter.isDefeated()

func getExpGiven() -> int:
	return critter.getExpGiven()

func gainExperience(experience: int) -> void:
	var oldLevel := getLevel()
	var newLevel := critter.gainExperience(experience)
	if newLevel != oldLevel:
		battleMessage.emit(getName() + " leveled up to " + str(newLevel) + ".")

func getSpeedForCalc() -> float:
	return critter.getSpeedForCalc()

func setIsInBattle(active: bool) -> void:
	isInBattle = active
	
func getIsInBattle() -> bool:
	return isInBattle

func setBattlePosition(pos: int) -> void:
	battlePosition = pos
	
func getBattlePosition() -> int:
	return battlePosition
