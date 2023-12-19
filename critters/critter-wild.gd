extends CharacterBody2D

signal battle_start(critterOut: Critter)

const SLOW = 5.0
const SPEED = 100.0
const TIMER = 1
var current_time = TIMER
var state = MOVEMENT_STATES.IDLE
var tracking
var critter: Critter

@onready var start_position: Vector2 = get_position()
@onready var target_position: Vector2 = generateTarget()
@onready var nav_agent = $NavigationAgent2D

enum MOVEMENT_STATES {
	IDLE,
	WANDER,
	FOLLOW,
	RUN
} 

func setCritter(critterInput: Critter):
	critter = critterInput

func generateTarget():
	var dis = randf_range(0, 20)
	return Vector2(randf_range(start_position.x-dis, start_position.x+dis), randf_range(start_position.y-dis, start_position.y+dis))

func _physics_process(delta):
	match state:
		MOVEMENT_STATES.IDLE:
			velocity.x = move_toward(velocity.x, 0, SLOW)
			velocity.y = move_toward(velocity.y, 0, SLOW)
			current_time -= delta
			if current_time < 0:
				target_position = generateTarget()
				state = MOVEMENT_STATES.WANDER
		MOVEMENT_STATES.WANDER:
			if (get_position() - target_position).length() > 1:
				var direction = (target_position - get_position()).normalized()
				velocity = direction * SPEED
			else:
				state = MOVEMENT_STATES.IDLE
				current_time = TIMER
		MOVEMENT_STATES.FOLLOW:
			var direction = to_local(nav_agent.get_next_path_position()).normalized()
			velocity = direction * SPEED

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

func _on_target_detection_body_entered(body):
	tracking = body
	nav_agent.target_position = body.global_position
	# if player is higher level than self, run
	# have target range increased based on player level ? 
	state = MOVEMENT_STATES.FOLLOW
	$Timer.start()

func _on_timer_timeout():
	nav_agent.target_position = tracking.global_position
	
func _battleStart():
	print("Battle Init")
	battle_start.emit(critter)
	queue_free()
