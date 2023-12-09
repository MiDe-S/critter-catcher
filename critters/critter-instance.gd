extends Resource
class_name Critter

@export var nickname: String
@export var moves: Array[Move]
@export var abilityIndex: int
@export var level: int
@export var experience: int
@export var weight: int



@export var healthAdd: int
@export var healthBase: int

@export var attackAdd: int
@export var defenseAdd: int

@export var attackBase: int
@export var defenseBase: int


@export var critterInfo: CritterInfo

@export var health: float = 100

# add EVs
# add IVs?

func initialize():
	health = getMaxHealth()

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
	
func getHealth():
	return health
	
func getAttackForCalc():
	return calcStat(critterInfo.getAttack(), attackBase, attackAdd)
	
func getDefenseForCalc():
	return calcStat(critterInfo.getDefense(), defenseBase, defenseAdd)

func calcStat(base, baseAdd, add):
	var baseTotal = base + baseAdd
	var additional = add / 100.0 * 0.25 + 1
	var lvl = level / 100.0 * 1 + 0.3
	return lvl * baseTotal * additional

func getMaxHealth():
	return calcStat(critterInfo.getHealth(), healthBase, healthAdd)

func getType():
	return critterInfo.getType()
