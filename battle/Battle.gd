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
	if critter == null:
		# nothing selected, refocus button
		get_tree().get_nodes_in_group("move_button")[0].grab_focus()
		selectedMove = null
		return;
	var action = Action.new(get_tree().get_nodes_in_group("p1")[p1CritterIndex], selectedMove, [critter])
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
			
func startTurn():
	p1CritterIndex = 0
	$BattleUI.setMoves(get_tree().get_nodes_in_group("p1")[p1CritterIndex].getMoves())
	get_tree().get_nodes_in_group("move_button").front().grab_focus()

func handleNextCritterTurn():
	p1CritterIndex += 1
	if p1CritterIndex >= get_tree().get_nodes_in_group("move_button").size():
		for action in turnActions:
			action.printInfo()
		return 
	$BattleUI.setMoves(get_tree().get_nodes_in_group("p1")[p1CritterIndex].getMoves())
	get_tree().get_nodes_in_group("move_button").front().grab_focus()

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
		critUi.initialize(critter.getName(), critter.getLevel(), critter.getHealth())
		
		self.add_child(critInstance)
		i += 1
