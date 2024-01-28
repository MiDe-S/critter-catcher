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

@export var alive: bool = true
@export var health: float

# done so health can be set when it is first read
@export var healthInit: bool = false

var attackMultiplier := 1.0
var rangeAttackMultiplier := 1.0
var defenseMultiplier := 1.0
var rangeDefenseMultiplier := 1.0
var speedMultiplier := 1.0

var damageReduction := 1.0

var currentEffects: Array[Effect] = []

func initialize() -> void:
	if !healthInit:
		setHealth(getMaxHealth())
		alive = true

func getMoves() -> Array[Move]:
	return moves
	
func getNickname() -> String:
	if nickname == null or nickname == '':
		return critterInfo.getName()
	return nickname

func getName() -> String:
	return critterInfo.getName()

func getLevel() -> int:
	return level
	
func getDamageReduction() -> float:
	return damageReduction

func getHealth() -> float:
	if !healthInit:
		health = getMaxHealth()
		healthInit = true
	return health
	
func setHealth(input: float) -> void:
	if !healthInit:
		healthInit = true
	health = snapped(input, .1)
	if health < 0:
		alive = false
	else:
		alive = true
	
func getMaxHealth() -> float:
	return calcStat(critterInfo.getHealth(), healthBase, healthAdd, 1)
	
func getAttackForCalc() -> float:
	return calcStat(critterInfo.getAttack(), attackBase, attackAdd, attackMultiplier)
	
func getDefenseForCalc() -> float:
	return calcStat(critterInfo.getDefense(), defenseBase, defenseAdd, defenseMultiplier)

func getRangeAttackForCalc() -> float:
	return calcStat(critterInfo.getRangeAttack(), rangeAttackBase, rangeAttackAdd, rangeAttackMultiplier)

func getRangeDefenseForCalc() -> float:
	return calcStat(critterInfo.getRangeDefense(), rangeDefenseBase, rangeDefenseAdd, rangeDefenseMultiplier)
	
func getSpeedForCalc() -> float:
	return calcStat(critterInfo.getSpeed(), speedBase, speedAdd, speedMultiplier)

func calcStat(base: int, baseAdd: int, add: int, multiplier: float) -> float:
	var baseTotal := base + float(baseAdd) / GlobalVariables.BASE_STAT_ADD_MAX * 0.2 + 1
	var additional := add / 100.0 * 0.25 + 1
	var lvl := level / 100.0 * 2 + 0.3
	return snapped(lvl * baseTotal * additional * multiplier, .1)

func getType() -> Array[Type]:
	return critterInfo.getType()
	
func isDefeated() -> bool:
	return !alive

func resetMultipliers() -> void:
	#clear effects array
	attackMultiplier = 1.0
	rangeAttackMultiplier = 1.0
	defenseMultiplier = 1.0
	rangeDefenseMultiplier = 1.0
	speedMultiplier = 1.0
	damageReduction = 1.0

func applyEffects(effects: Array[Effect]) -> void:
	for effect in effects:
		effect.applyEffect(self)
		currentEffects.append(effect)

func incrementTurn() -> void:
	for effect in currentEffects:
		var remove: bool = effect.incrementTurn()
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

func getCritterIcon() -> Texture2D:
	return critterInfo.getCritterIcon()

func getExperience() -> int:
	return experience

func healFull() -> void:
	setHealth(getMaxHealth())
