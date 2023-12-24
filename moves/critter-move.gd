extends Resource
class_name CritterMove

@export_range(0,100,1) var level: int
@export var move: Move

func getMove():
	return move
	
func getLevel():
	return level
