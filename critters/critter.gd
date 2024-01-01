extends Resource
class_name Critter

@export var nickname: String
@export var moves: Array[Move]
@export var abilityIndex: int

@export var weight: int

@export var critterInfo: CritterInfo

@export_category("Exp")
@export var level: int
@export var experience: int

@export_category("Base Modifiers")
@export var healthBase: int
@export var attackBase: int
@export var defenseBase: int
@export var rangeAttackBase: int
@export var rangeDefenseBase: int
@export var speedBase: int

@export_category("Additional Modifiers")
@export var healthAdd: int
@export var attackAdd: int
@export var defenseAdd: int
@export var rangeAttackAdd: int
@export var rangeDefenseAdd: int
@export var speedAdd: int


# done so health can be set when it is first read
var healthInit: bool = false
var health: float

var attackMultiplier = 1.0
var rangeAttackMultiplier = 1.0
var defenseMultiplier = 1.0
var rangeDefenseMultiplier = 1.0
var speedMultiplier = 1.0

var damageReduction = 1.0

var currentEffects: Array[Effect] = []

func initialize():
	setHealth(getMaxHealth())

func getMoves():
	return moves
	
func getNickname():
	if nickname == null:
		return critterInfo.getName()
	return nickname

func getName():
	return critterInfo.getName()

func getLevel():
	return level
	
func getDamageReduction():
	return damageReduction

func getHealth():
	if !healthInit:
		health = getMaxHealth()
		healthInit = true
	return health
	
func setHealth(input: float):
	if !healthInit:
		healthInit = true
	health = input
	
func getMaxHealth():
	return calcStat(critterInfo.getHealth(), healthBase, healthAdd, 1)
	
func getAttackForCalc():
	return calcStat(critterInfo.getAttack(), attackBase, attackAdd, attackMultiplier)
	
func getDefenseForCalc():
	return calcStat(critterInfo.getDefense(), defenseBase, defenseAdd, defenseMultiplier)

func getRangeAttackForCalc():
	return calcStat(critterInfo.getRangeAttack(), rangeAttackBase, rangeAttackAdd, rangeAttackMultiplier)

func getRangeDefenseForCalc():
	return calcStat(critterInfo.getRangeDefense(), rangeDefenseBase, rangeDefenseAdd, rangeDefenseMultiplier)
	
func getSpeedForCalc():
	return calcStat(critterInfo.getSpeed(), speedBase, speedAdd, speedMultiplier)

func calcStat(base, baseAdd, add, multiplier):
	var baseTotal = base + baseAdd / GlobalVariables.BASE_STAT_ADD_MAX * 0.2 + 1
	var additional = add / 100.0 * 0.25 + 1
	var lvl = level / 100.0 * 2 + 0.3
	return lvl * baseTotal * additional * multiplier

func getType():
	return critterInfo.getType()
	
func isDefeated() -> bool:
	return health <= 0

func resetMultipliers():
	#clear effects array
	attackMultiplier = 1.0
	rangeAttackMultiplier = 1.0
	defenseMultiplier = 1.0
	rangeDefenseMultiplier = 1.0
	speedMultiplier = 1.0
	damageReduction = 1.0

func applyEffects(effects: Array[Effect]):
	for effect in effects:
		effect.applyEffect(self)
		currentEffects.append(effect)

func incrementTurn():
	for effect in currentEffects:
		var remove = effect.incrementTurn()
		if remove:
			currentEffects.erase(effect)
			
func gainExperience(experienceInput: int) -> int:
	experience += experienceInput
	while experience >= getExpNeeded() and level <= GlobalVariables.LEVEL_CAP:
		experience -= getExpNeeded()
		level += 1
	return level

func getExpGiven() -> int:
	return critterInfo.getExpGiven(level)
	
func getExpNeeded() -> int:
	return critterInfo.getExpNeeded(level)

func getCritterIcon():
	return critterInfo.getCritterIcon()

func getExperience() -> int:
	return experience
