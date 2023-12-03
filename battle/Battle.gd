extends Node

var critterPath = "res://critters/critters/"
var critterFormat = ".tscn"
# on init spawn people from people

var p1CritterIndex = 0
var selectedMove: Move = null
var turnActions: Array[Action]

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
	var s1 = load(critterPath + critters[0].getName() + critterFormat).instantiate()
	s1.setCritter(critters[0])
	if p1:
		s1.position = $LeftSpawnTop.position
	else:
		s1.position = $RightSpawnTop.position
		s1.faceLeft()
	var s2 = load(critterPath + critters[1].getName() + critterFormat).instantiate()
	s2.setCritter(critters[1])
	if p1:
		s2.position = $LeftSpawnBottom.position
	else:
		s2.position = $RightSpawnBottom.position
		s2.faceLeft()
	self.add_child(s1)
	self.add_child(s2)
	
	if p1:
		s1.add_to_group("p1")
		s2.add_to_group("p1")
	else:
		s1.add_to_group("p2")
		s2.add_to_group("p2")
