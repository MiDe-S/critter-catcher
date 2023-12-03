extends Node2D

# Need to be added to use the HealthBar2D
signal health_changed

var maxHealth: int = 100
var health := 100
var _offset: Vector2 = Vector2(0, -100)


func _ready() -> void:
	pass

func _process(delta) -> void:
	pass

func initialize(nameInput, levelInput: int, maxHealthInput):
	maxHealth = maxHealthInput
	health = maxHealth
	
	$Name.text = nameInput
	$Level.text = "Lvl: " + str(levelInput)
	$HealthBar2D.initialize("health_changed", health)
	$HealthBar2D.set_max(maxHealth)
	set_global_position(get_parent().position + _offset)
	
