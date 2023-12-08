extends Node

var critterPath = "res://critters/critters/"
var critterFormat = ".tscn"

var critterUIPath = "res://battle/battle-ui/critter-ui/critter_ui.tscn"
# on init spawn people from people

var p1CritterIndex = 0
var selectedMove: Move = null
var turnActions: Array[Action]

var leftPositions = ["LeftSpawnTop", "LeftSpawnBottom"]
var rightPositions = ["RightSpawnTop", "RightSpawnBottom"]

### Turn
## Select Move on critter 1
# Select Target
## Select Move on critter 2
# Select Target
## Get AI Actions
### Resolve turn
### Repeat

# Called when the node enters the scene tree for the first time.
func _ready():
	setUpPlayers($Player.getCritters())
	setUpPlayers($Enemy.getCritters(), false)
	#$Selector.setFocus(selectableOptions)
	startTurn()
	# global position might work for button?
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _critterChosen(critter):
	var targets: Array[Node] = []
	if critter == null:
		# nothing selected, refocus button
		get_tree().get_nodes_in_group("move_button")[0].grab_focus()
		selectedMove = null
		return;
	elif critter.is_in_group("side"):
		targets = get_tree().get_nodes_in_group("p2")
	elif critter.is_in_group("all"):
		targets = get_tree().get_nodes_in_group("p1") + get_tree().get_nodes_in_group("p2")
	else:
		targets.append(critter)
	var action = Action.new(get_tree().get_nodes_in_group("p1")[p1CritterIndex], selectedMove, targets)
	turnActions.append(action)
	handleNextCritterTurn()
	
func _moveChosen(move):
	selectedMove = move
	match move.getTarget():
		Move.targetType.SINGLE:
			var options = get_tree().get_nodes_in_group("p2")
			var i = 0
			for node in get_tree().get_nodes_in_group("p1"):
				if i != p1CritterIndex:
					options.insert(0, node)
				i += 1
			$Selector.setFocus(options)
		Move.targetType.ENEMIES:
			$Selector.setFocus(get_tree().get_nodes_in_group("side"))
		Move.targetType.ALL:
			$Selector.setFocus(get_tree().get_nodes_in_group("all"))
			
func startTurn():
	p1CritterIndex = 0
	turnActions = []
	$BattleUI.setMoves(get_tree().get_nodes_in_group("p1")[p1CritterIndex].getMoves())
	get_tree().get_nodes_in_group("move_button").front().grab_focus()

func handleNextCritterTurn():
	p1CritterIndex += 1
	if p1CritterIndex >= get_tree().get_nodes_in_group("move_button").size():
		endTurn()
		return 
	$BattleUI.setMoves(get_tree().get_nodes_in_group("p1")[p1CritterIndex].getMoves())
	get_tree().get_nodes_in_group("move_button").front().grab_focus()
	
func endTurn():
	# determine who goes first with speed + effects
	# calculate damage for all
	for action in turnActions:
		action.printInfo()
		# check accuracy
		var typeAdvantage = 1
		var movePower = action.getMove().getPower()
		# check physical vs range
		var atk = action.getAttacker().getCritter().getAttackForCalc()
		# do our level / their level as multiplier ??
		for defender in action.getDefenders():
			var def = defender.getCritter().getDefenseForCalc()
			defender.dealDamage(movePower * typeAdvantage * atk / def)
	# check arena conditions + 
	# advance turn counter 1
	startTurn()
	pass
	

func setUpPlayers(critters, p1: bool = true):
	var i = 0
	for critter in critters:
		var critInstance = load(critterPath + critter.getName() + critterFormat).instantiate()
		critInstance.setCritter(critter)
		if p1:
			critInstance.add_to_group("p1")
			critInstance.position = get_node(leftPositions[i]).position
		else:
			critInstance.add_to_group("p2")
			critInstance.position = get_node(rightPositions[i]).position
			critInstance.faceLeft()
			
		var critUi = load(critterUIPath).instantiate()
		critInstance.add_child(critUi)
		critUi.initialize(critter.getName(), critter.getLevel(), critter.getMaxHealth(), critInstance.getSigName())
		
		self.add_child(critInstance)
		i += 1
