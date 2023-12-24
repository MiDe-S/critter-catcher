extends Resource
class_name AreaSpawnInfo

@export var critter: CritterInfo
@export var frequency: float = 1
@export var levelMin: int
@export var levelMax: int

func generateCritter():
	var level = randi_range(levelMin, levelMax+1) # exclusive
	var healthBase = randi_range(0, GlobalVariables.BASE_STAT_ADD_MAX)
	var attackBase = randi_range(0, GlobalVariables.BASE_STAT_ADD_MAX)
	var defenseBase = randi_range(0, GlobalVariables.BASE_STAT_ADD_MAX)
	var rangeBase = randi_range(0, GlobalVariables.BASE_STAT_ADD_MAX)
	var rangeDefenseBase = randi_range(0, GlobalVariables.BASE_STAT_ADD_MAX)
	var speedBase = randi_range(0, GlobalVariables.BASE_STAT_ADD_MAX)
	
	var moves: Array[Move] = []
	for move in critter.getCritterMove():
		if move.getLevel() <= level:
			if moves.size() >= GlobalVariables.MOVE_COUNT:
				moves.pop_front()
			moves.append(move.getMove())
	# get random weight
	var output = Critter.new()
	output.critterInfo = critter
	output.healthBase = healthBase
	output.attackBase = attackBase
	output.defenseBase = defenseBase
	output.rangeAttackBase = rangeBase
	output.rangeDefenseBase = rangeDefenseBase
	output.speedBase = speedBase
	output.level = level
	output.moves = moves
	
	return output
