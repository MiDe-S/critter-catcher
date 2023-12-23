extends CharacterBody2D
class_name Player

var playerInfo: PlayerInfo
const SPEED = 150.0



func _ready():
	playerInfo = PlayerManager.getPlayerInfo()
	$TerrainDetector.connect("terrain_event", _handleTerrainEvent)

func getCritters():
	return playerInfo.getCritters()
	
func addCritter(critter: Critter):
	playerInfo.addCritter(critter)

func isDefeated():
	return playerInfo.isDefeated()

func _physics_process(_delta):
	PlayerManager.currentPosition = position
	# Add the gravity.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if directionX:
		velocity.x = directionX * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

			
	var directionY = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		
	if directionY:
		velocity.y = directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if velocity == Vector2.ZERO:
		$AnimationPlayer.stop()
	elif velocity.x > 0:
		$AnimationPlayer.play("right")
	elif velocity.y < 0:
		$AnimationPlayer.play("up")
	elif velocity.x < 0:
		$AnimationPlayer.play("left")
	elif velocity.y > 0:
		$AnimationPlayer.play("down")
		
	move_and_slide()

func _handleTerrainEvent(key: int):
	if (velocity.x > 0):
		velocity.y = move_toward(velocity.y, -SPEED*1.3, SPEED*2)
	elif velocity.x < 0:
		velocity.y = move_toward(velocity.y, SPEED*1.3, SPEED*2)
