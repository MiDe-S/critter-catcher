extends Resource
class_name TypeManger

var typeMap
var fp := 'res://types/types.json'

func read_json(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	return JSON.parse_string(file.get_as_text())


func _init() -> void:
	#load enum from file
	typeMap = read_json(fp)
	
func getAdvantage(attackType: Type, defenseType: Array[Type]) -> float:
	var output = 1
	for type in defenseType:
		output = output * typeMap[attackType.getName()][type.getName()]
	return output
