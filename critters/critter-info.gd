extends Resource
class_name CritterInfo

@export var id: int
@export var name: String
@export var type: Array[Type]
@export var description: String
#@export var size: Enum
@export var catch_rate: int

# Insert image/animation
@export_file("*.png") var icon:
	set(value):
		icon = load(value)
# Insert moves map of levels and moves
# Insert evo map of levels and moves

@export var moveList: Array[CritterMove]

@export_category("Base Stats")
@export var health: int
@export var attack: int
@export var defense: int
@export var range_attack: int
@export var range_defense: int
@export var speed: int

const EXP_NEEDED_MODIFIER = 1.1
const EXP_GIVEN_MODIFIER = 1.05

func getName() -> String:
	return name

func getHealth() -> int:
	return health

func getAttack() -> int:
	return attack
	
func getDefense() -> int:
	return defense

func getRangeAttack() -> int:
	return range_attack
	
func getRangeDefense() -> int:
	return range_defense
	
func getSpeed() -> int:
	return speed
	
func getType() -> Array[Type]:
	return type
	
func getCritterMove():
	return moveList
	
func getCritterIcon():
	return icon
	
func getBaseStatTotal() -> int:
	return health + attack + defense + range_attack + range_defense + speed
	
# How much needed to to level up @ given level
func getExpNeeded(level: int) -> int:
	return floor(pow(level, EXP_NEEDED_MODIFIER) * getBaseStatTotal())

# How much exp this mon is worth at this level
func getExpGiven(level: int) -> int:
	return floor(pow(level, EXP_GIVEN_MODIFIER) * getBaseStatTotal())
	
