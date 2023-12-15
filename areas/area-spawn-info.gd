extends Resource
class_name AreaSpawnInfo

@export var critter: CritterInfo
@export var frequency: float = 1
@export var levelMin: int
@export var levelMax: int

func getRandomCritter():
	var level = randf_range(levelMin, levelMax+1) # exclusive
	# set baseAdd stats, min 0 max 15
	# generate moves randomly from level list <
	# get random weight
	# get random
	# Create critter, set critterInfo
	
	
