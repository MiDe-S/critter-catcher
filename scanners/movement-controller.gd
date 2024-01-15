extends Node2D
class_name MovementController

signal Facing(facing: Directions)

@onready var animationPlayer: AnimationPlayer = get_parent().get_node("AnimationPlayer")

var facing: Directions = -1 # so default isn't 0

enum Directions {
	RIGHT,
	UP,
	DOWN,
	LEFT
}

func move(direction: Vector2, speed: int) -> void:
	var velocityValue: Vector2 = get_parent().velocity
			
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
		if facing != Directions.RIGHT:
			facing = Directions.RIGHT
			animationPlayer.play("right")
			Facing.emit(facing)
	elif velocityValue.y < 0:
		if facing != Directions.UP:
			facing = Directions.UP
			animationPlayer.play("up")
			Facing.emit(facing)
	elif velocityValue.x < 0:
		if facing != Directions.LEFT:
			facing = Directions.LEFT
			animationPlayer.play("left")
			Facing.emit(facing)
	elif velocityValue.y > 0:
		if facing != Directions.DOWN:
			facing = Directions.DOWN
			animationPlayer.play("down")
			Facing.emit(facing)
		
func terrainEvent(key: int, speed: int) -> void:
	var velocityValue: Vector2 = get_parent().velocity
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
	#get_parent().velocity = velocityValue
