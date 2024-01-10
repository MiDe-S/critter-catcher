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

# DEBUG ONLY, NOT AN EXPORT
@export var region: NavigationRegion2D 

enum MOVEMENT_STATES {
	IDLE,
	WANDER,
	FOLLOW,
	RUN
} 

func initialize(nav_region: Node):
	region = nav_region

func setCritter(critterInput: Critter):
	critter = critterInput

func generateTarget():
	var dis = randf_range(0, 20)
	return Vector2(randf_range(start_position.x-dis, start_position.x+dis), randf_range(start_position.y-dis, start_position.y+dis))

func _physics_process(delta):
	match state:
		MOVEMENT_STATES.IDLE:
			current_time -= delta
			$MovementController.move(Vector2.ZERO, SLOW)
			if current_time < 0:
				target_position = generateTarget()
				state = MOVEMENT_STATES.WANDER
		MOVEMENT_STATES.WANDER:
			if (get_position() - target_position).length() > 1:
				$MovementController.move(target_position - get_position(), SPEED)
			else:
				state = MOVEMENT_STATES.IDLE
				current_time = TIMER
		MOVEMENT_STATES.FOLLOW:
			var direction = to_local(nav_agent.get_next_path_position())
			$MovementController.move(direction, SPEED)
	
	move_and_slide()

func _on_target_detection_body_entered(body):
	tracking = body
	nav_agent.set_target_position(tracking.global_position)
	$Timer.start()
	# if player is higher level than self, run
	# have target range increased based on player level ? 

func _on_target_detection_body_exited(body):
	if body == tracking and state != MOVEMENT_STATES.FOLLOW:
		tracking = null
		$Timer.stop()

func _on_timer_timeout():
	nav_agent.set_target_position(tracking.global_position)
	if state != MOVEMENT_STATES.FOLLOW:
		_check_target_distance()
	
func _battleStart():
	print("Battle Init")
	battle_start.emit(critter)
	queue_free()

func _check_target_distance() -> void:
	# temp solution until navagent.get_navigation_path works
	var points: PackedVector2Array = NavigationServer2D.map_get_path(
	region.get_navigation_map(),
	position,
	tracking.global_position,
	true
	)
	var length = 1
	var distance = 0.0
	while length < points.size():
		distance += points[length - 1].distance_to(points[length])
		length += 1
	if distance >= $TargetDetection/CollisionShape2D.get_shape().get_radius():
		state = MOVEMENT_STATES.FOLLOW
