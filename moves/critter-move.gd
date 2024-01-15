extends Resource
class_name CritterMove

@export_range(0,100,1) var level: int
@export var move: Move

func getMove() -> Move:
	return move
	
func getLevel() -> int:
	return level
