extends CharacterBody2D


const SPEED = 300.0

@onready var start_position: Vector2 = get_position()
@onready var target_position: Vector2 = generate_target()

func generate_target():
	return Vector2(randf_range(start_position.x-32, start_position.x+32), randf_range(start_position.y-32, start_position.y+32))

func _physics_process(delta):
	if (get_position() - target_position).length() > 1:
		var direction = (target_position - get_position()).normalized()
		var acceleration_vector = direction * SPEED * delta
		velocity += acceleration_vector
	else:
		target_position = generate_target()

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
