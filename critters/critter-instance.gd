extends Resource
class_name Critter

@export var nickname: String
@export var moves: Array[Move]
@export var abilityIndex: int
@export var level: int
@export var experience: int
@export var weight: int

@export var critterInfo: CritterInfo

# add EVs
# add IVs?

func _init(levelInput = 1, abilityIndexInput = 0):
	level = levelInput
	abilityIndex = abilityIndexInput

func getMoves():
	return moves
	
func getNickname():
	if nickname == null:
		return critterInfo.getName()
	return nickname

func getName():
	return critterInfo.getName()
