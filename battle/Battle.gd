extends Node

var critterPath = "res://critters/critters/"
var critterFormat = ".tscn"

var critterUIPath = "res://battle/battle-ui/critter-ui/critter_ui.tscn"
# on init spawn people from people

var p1CritterIndex = 0
var selectedMove: Move = null
var turnActions: Array[Action]

@export var leftPositions: Array[Node2D]
@export var rightPositions: Array[Node2D]

@export var opposingSide: Array[Node2D]
@export var all: Array[Node2D]

var typeManager: TypeManger = TypeManger.new()

var _mapScene
### Turn
## Select Move on critter 1
# Select Target
## Select Move on critter 2
# Select Target
## Get AI Actions
### Resolve turn
### Repeat

func setMapScene(scene):
	_mapScene = scene
	
func setEnemy(enemy: CharacterBody2D):
	remove_child($Enemy)
	add_child(enemy)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.get_node("Camera2D").enabled = false
	
	$Selector.connect("selection", _critterChosen)
	$BattleUI.connect("actionChosen", _actionChosen)
	
	setUpPlayers($Player.getCritters())
	setUpPlayers($Enemy.getCritters(), false)
	startTurn()
	# global position might work for button?

func setUpPlayers(critters, p1: bool = true):
	var i = 0
	for pos in leftPositions:
		var critter = critters[i]
		var critInstance = load(critterPath + critter.getName().to_lower() + critterFormat).instantiate()
		critInstance.setCritter(critter)
		if p1:
			critInstance.add_to_group("p1")
			critInstance.position = leftPositions[i].position
		else:
			critInstance.add_to_group("p2")
			critInstance.position = rightPositions[i].position
			critInstance.faceLeft()
			
		var critUi = load(critterUIPath).instantiate()
		critInstance.add_child(critUi)
		critUi.initialize(critter.getName(), critter.getLevel(), critter.getMaxHealth(), critInstance.getSigName())
		
		self.add_child(critInstance)
		i += 1



			
func startTurn():
	p1CritterIndex = 0
	turnActions = []
	$BattleUI.setMoves(get_tree().get_nodes_in_group("p1")[p1CritterIndex].getMoves())
	get_tree().get_nodes_in_group("move_button").front().grab_focus()
	
func _actionChosen(action):
	if action is Move:
		_moveChosen(action)
	match action:
		BattleUI.BattleUIActions.SWITCH:
			print("switch")
		BattleUI.BattleUIActions.RUN:
			endBattle()
		BattleUI.BattleUIActions.SCAN:
			catchCritter()

func _moveChosen(move):
	selectedMove = move
	# if 1v1 skip selection phase
	if leftPositions.size() == 1:
		match move.getTarget():
			Move.targetType.SELF:
				_critterChosen(get_tree().get_nodes_in_group("p1")[0])
			Move.targetType.SINGLE:
				_critterChosen(get_tree().get_nodes_in_group("p2")[0])
			Move.targetType.ENEMIES:
				_critterChosen(opposingSide[0])
			Move.targetType.ALL:
				_critterChosen(all[0])
			
				
	else:
		match move.getTarget():
			Move.targetType.SELF:
				$Selector.setFocus([get_tree().get_nodes_in_group("p1")[p1CritterIndex]])
			Move.targetType.SINGLE:
				var options = get_tree().get_nodes_in_group("p2")
				var i = 0
				for node in get_tree().get_nodes_in_group("p1"):
					if i != p1CritterIndex:
						options.insert(0, node)
					i += 1
				$Selector.setFocus(options)
			Move.targetType.ENEMIES:
				$Selector.setFocus(opposingSide)
			Move.targetType.ALL:
				$Selector.setFocus(all)
			
func _critterChosen(critter):
	var targets: Array[Node] = []
	if critter == null:
		# nothing selected, refocus button
		get_tree().get_nodes_in_group("move_button")[0].grab_focus()
		selectedMove = null
		return;
	elif critter in opposingSide:
		targets = get_tree().get_nodes_in_group("p2")
	elif critter in all:
		targets = get_tree().get_nodes_in_group("p1") + get_tree().get_nodes_in_group("p2")
	else:
		targets.append(critter)
	var action = Action.new(get_tree().get_nodes_in_group("p1")[p1CritterIndex], selectedMove, targets)
	turnActions.append(action)
	handleNextCritterTurn()

func handleNextCritterTurn():
	p1CritterIndex += 1
	if p1CritterIndex >= get_tree().get_nodes_in_group("p1").size():
		endTurn()
		return 
	$BattleUI.setMoves(get_tree().get_nodes_in_group("p1")[p1CritterIndex].getMoves())
	get_tree().get_nodes_in_group("move_button").front().grab_focus()
	
func endTurn():
	var rng = RandomNumberGenerator.new()
	# determine who goes first with speed + effects
	# calculate damage for all
	for action in turnActions:
		action.printInfo()
		var movePower = action.getMove().getPower()  * min((0.3 + action.getAttacker().getLevel() / 100.0), 1.0)
		# check physical vs range
		var atk
		match action.getMove().getAttribute():
			Move.attributeType.DIRECT:
				atk = action.getAttacker().getCritter().getAttackForCalc()
			Move.attributeType.RANGE:
				atk = action.getAttacker().getCritter().getRangeAttackForCalc()
		# check for STAB
		for defender in action.getDefenders():
			if rng.randf_range(0, 100) <= action.getMove().getAccuracy():
				var randomness = rng.randf_range(.96, 1.04)
				
				
				var def
				match action.getMove().getAttribute():
					Move.attributeType.DIRECT:
						def = defender.getCritter().getDefenseForCalc()
					Move.attributeType.RANGE:
						def = defender.getCritter().getRangeDefenseForCalc()
						
				if action.getMove().getAttribute() != Move.attributeType.STATUS:
					var typeAdvantage = typeManager.getAdvantage(action.getMove().getType(), defender.getCritter().getType())
					defender.dealDamage(movePower * typeAdvantage * atk / def * randomness)
				defender.getCritter().applyEffects(action.getMove().getEffects())
			else:
				print("Move missed")
		checkBattleOver()
	# check arena conditions + 
	# advance turn counter 1
	for critter in get_tree().get_nodes_in_group("p1"):
		critter.incrementTurn()
	for critter in get_tree().get_nodes_in_group("p2"):
		critter.incrementTurn()
	startTurn()
	pass
	
func catchCritter():
	# switch to mini game here
	$Player.addCritter($Enemy.getCritters()[0])
	endBattle()
	
func checkBattleOver():
	if $Player.isDefeated() or $Enemy.isDefeated():
		endBattle()
	
func endBattle():
	var current = get_tree().get_current_scene()
	get_tree().get_root().add_child(_mapScene)
	get_tree().set_current_scene(_mapScene)
	current.queue_free()
	
