extends CharacterBody2D
class_name Player

@onready var ray = $ShapeCast2D

const SPEED = 150
var playerInfo: PlayerInfo

func _ready():
	playerInfo = PlayerManager.getPlayerInfo()
	$TerrainDetector.connect("terrain_event", _handleTerrainEvent)
	$MovementController.connect("Facing", _updateRayCast)

func getCritters():
	return playerInfo.getCritters()
	
func addCritter(critter: Critter):
	playerInfo.addCritter(critter)

func isDefeated():
	return playerInfo.isDefeated()

func _physics_process(_delta):
	PlayerManager.setPlayerPosition(position)

	var directionX = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var directionY = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	$MovementController.move(Vector2(directionX, directionY), SPEED)
	move_and_slide()

func _handleTerrainEvent(key: int):
	$MovementController.terrainEvent(key, SPEED)

func _updateRayCast(facing: MovementController.Directions):
	ray.setFacing(facing)
	
func _input(event):
	if event.is_action_pressed("overworld_interact"):
		if ray.is_colliding():
			ray.interactClosest()
			print("Start Battle")
