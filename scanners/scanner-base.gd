extends Resource
class_name Scanner

@export var name: String
@export var team: Array[Critter]
# add dialog options
# add AI params (?)

func getCritters():
	return team
