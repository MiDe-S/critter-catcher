extends CharacterBody2D
class_name Player

@onready var ray: ShapeCast2D = $ShapeCast2D

const SPEED := 150
var playerInfo: PlayerInfo

func _ready() -> void:
	playerInfo = PlayerManager.getPlayerInfo()
	$TerrainDetector.connect("terrain_event", _handleTerrainEvent)
	$MovementController.connect("Facing", _updateRayCast)

func getCritters() -> Array[Critter]:
	return playerInfo.getCritters()
	
func addCritter(critter: Critter) -> void:
	playerInfo.addCritter(critter)

func isDefeated() -> bool:
	return playerInfo.isDefeated()

func _physics_process(_delta: float) -> void:
	PlayerManager.setPlayerPosition(position)

	var directionX: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var directionY: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	$MovementController.move(Vector2(directionX, directionY), SPEED)
	move_and_slide()

func _handleTerrainEvent(key: int) -> void:
	$MovementController.terrainEvent(key, SPEED)

func _updateRayCast(facing: MovementController.Directions) -> void:
	ray.setFacing(facing)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("overworld_interact"):
		if ray.is_colliding():
			ray.interactClosest()
			print("Start Battle")
