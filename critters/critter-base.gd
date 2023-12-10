extends Resource
class_name CritterInfo

@export var id: int
@export var name: String
@export var type: Array[Type]
@export var description: String
#@export var size: Enum
@export var catch_rate: int

# Insert image/animation
# Insert moves map of levels and moves
# Insert evo map of levels and mon
# Insert list of possible abilites

@export var health: int
@export var attack: int
@export var defense: int
@export var range_attack: int
@export var range_defense: int
@export var speed: int

func getName():
	return name

func getHealth():
	return health

func getAttack():
	return attack
	
func getDefense():
	return defense

func getRangeAttack():
	return range_attack
	
func getRangeDefense():
	return range_defense
	
func getSpeed():
	return speed
	
func getType():
	return type
