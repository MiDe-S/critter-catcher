extends CharacterBody2D
class_name Player

var playerInfo

func _ready():
	playerInfo = PlayerManager.getPlayerInfo()

func getCritters():
	return playerInfo.getCritters()

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

func _physics_process(_delta):
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

