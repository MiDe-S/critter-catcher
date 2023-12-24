extends Node2D

@onready var animationPlayer = get_parent().get_node("AnimationPlayer")

func move(direction: Vector2, speed: int):
	var velocityValue = get_parent().velocity
			
	if direction.x:
		velocityValue.x = direction.x * speed
	else:
		velocityValue.x = move_toward(velocityValue.x, 0, speed)
			
	if direction.y:
		velocityValue.y = direction.y * speed
	else:
		velocityValue.y = move_toward(velocityValue.y, 0, speed)
	velocityValue = velocityValue.normalized() * speed
	
	get_parent().velocity = velocityValue
	
	if velocityValue == Vector2.ZERO:
		animationPlayer.stop()
	elif velocityValue.x > 0:
		animationPlayer.play("right")
	elif velocityValue.y < 0:
		animationPlayer.play("up")
	elif velocityValue.x < 0:
		animationPlayer.play("left")
	elif velocityValue.y > 0:
		animationPlayer.play("down")
		
func terrainEvent(key: int, speed: int):
	var velocityValue = get_parent().velocity
	match key:
		TerrainDetector.DIRECTIONS.EAST:
			if velocityValue.x > 0:
				velocityValue.y = move_toward(velocityValue.y, -speed*1.4, speed*2)
			elif velocityValue.x < 0:
				velocityValue.y = move_toward(velocityValue.y, speed*1.4, speed*2)
		TerrainDetector.DIRECTIONS.WEST:
			if velocityValue.x < 0:
				velocityValue.y = move_toward(velocityValue.y, -speed*1.4, speed*2)
			elif velocityValue.x > 0:
				velocityValue.y = move_toward(velocityValue.y, speed*1.4, speed*2)
	get_parent().velocity = velocityValue
