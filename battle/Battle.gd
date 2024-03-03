extends Node
class_name Battle

const SWITCH_BATTLE_POS := -10
const critterUIPath := "res://battle/battle-ui/critter-ui/critter_ui.tscn"
# on init spawn people from people

var p1CritterIndex := 0
var selectedMove: Move = null
var turnActions: Array[Action]

@export var leftPositions: Array[Node2D]
@export var rightPositions: Array[Node2D]

@export var opposingSide: Array[Node2D]
@export var all: Array[Node2D]

var critterBattleBase: PackedScene = load("res://critters/critter-battle.tscn")

var enemy: NPC
var typeManager: TypeManger = TypeManger.new()

var leftCritters: Array[CritterInstance]
var rightCritters: Array[CritterInstance]

### Turn
## Select Move on critter 1
# Select Target
## Select Move on critter 2
# Select Target
## Get AI Actions
### Resolve turn
### Repeat
	
func setEnemy(enemyInput: NPC) -> void:
	remove_child($Enemy)
	add_child(enemyInput)
	enemy = enemyInput

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.get_node("Camera2D").enabled = false
	
	$Selector.selection.connect(_critterChosen)
	$BattleUI.actionChosen.connect(_actionChosen)
	
	if enemy == null:
		enemy = $Enemy
	
	setUpPlayers($Player.getCritters())
	setUpPlayers(enemy.getCritters(), false)
	startTurn()

func setUpPlayers(critters: Array[Critter], p1: bool = true) -> void:
	if p1:
		leftCritters = _setUpCritters(critters, "p1")
		# Put critters on battlefield
		for i in range(leftPositions.size()):
			leftCritters[i].setIsInBattle(true)
			leftCritters[i].position = leftPositions[i].position
			leftCritters[i].setBattlePosition(i)
			self.add_child(leftCritters[i])
	else:
		rightCritters = _setUpCritters(critters, "p2")
		for critter in rightCritters:
			critter.faceLeft()
		# Put critters on battlefield
		for i in range(rightPositions.size()):
			rightCritters[i].setIsInBattle(true)
			rightCritters[i].position = rightPositions[i].position
			rightCritters[i].setBattlePosition(i+leftPositions.size())
			self.add_child(rightCritters[i])

func _setUpCritters(critters: Array[Critter], group: String) -> Array[CritterInstance]:
	var output: Array[CritterInstance] = []
	for critter in critters:
		var critInstance: CritterInstance = critterBattleBase.instantiate()
		critInstance.setCritter(critter)
		critInstance.add_to_group(group)
		
		var critUi: CritterUI = load(critterUIPath).instantiate()
		critInstance.add_child(critUi)
		critUi.initialize(critter, critInstance.getSigName())
		critInstance.connect("battleMessage", printText)
		output.append(critInstance)
	return output
	
func startTurn() -> void:
	p1CritterIndex = 0
	turnActions = []
	$BattleUI.setMoves(getCrittersInGroupByActiveIndex("p1", p1CritterIndex).getMoves())
	get_tree().get_nodes_in_group("move_button").front().grab_focus()
	
func _actionChosen(action: Variant, metadata: Variant = null) -> void:
	if action is Move:
		_moveChosen(action)
	match action:
		BattleUI.BattleUIActions.SWITCH:
			var crit: CritterInstance = null
			for critter in leftCritters:
				if critter.getCritter() == metadata:
					crit = critter
			if crit == null:
				Log.error("Could not find matching critter for " + metadata.getName())
			crit.setBattlePosition(SWITCH_BATTLE_POS)
			turnActions.append(Action.new(getCrittersInGroupByActiveIndex("p1", p1CritterIndex), null, [crit.getBattlePosition()]))
			handleNextCritterTurn()
			
		BattleUI.BattleUIActions.RUN:
			endBattle()
		BattleUI.BattleUIActions.SCAN:
			catchCritter()

func _moveChosen(move: Move) -> void:
	selectedMove = move
	# if 1v1 skip selection phase
	if leftPositions.size() == 1:
		match move.getTarget():
			Move.targetType.SELF:
				_critterChosen(getActiveCrittersInGroup("p1")[0])
			Move.targetType.SINGLE:
				_critterChosen(getActiveCrittersInGroup("p2")[0])
			Move.targetType.ENEMIES:
				_critterChosen(opposingSide[0])
			Move.targetType.ALL:
				_critterChosen(all[0])
				
	else:
		match move.getTarget():
			Move.targetType.SELF:
				$Selector.setFocus([getCrittersInGroupByActiveIndex("p1", p1CritterIndex)])
			Move.targetType.SINGLE:
				var options: Array[Node] = castArrayIns(getActiveCrittersInGroup("p2"))
				var others: Array[Node] = castArrayIns(getActiveCrittersInGroup("p1"))
				others.pop_at(p1CritterIndex)
				options += others
				$Selector.setFocus(options)
			Move.targetType.ENEMIES:
				$Selector.setFocus(opposingSide)
			Move.targetType.ALL:
				$Selector.setFocus(all)
			
func _critterChosen(critter: Variant) -> void:
	var targets: Array[Node] = []
	if critter == null:
		# nothing selected, refocus button
		get_tree().get_nodes_in_group("move_button")[0].grab_focus()
		selectedMove = null
		return;
	elif critter in opposingSide:
		targets = castArrayIns(getActiveCrittersInGroup("p2"))
	elif critter in all:
		targets = castArrayIns(getActiveCrittersInGroup("p1") + getActiveCrittersInGroup("p2"))
	else:
		targets.append(critter)
	var targetPos: Array[int] = []
	targetPos.assign(targets.map(func(cri: Variant) -> int: return cri.getBattlePosition()))
	var action := Action.new(getCrittersInGroupByActiveIndex("p1", p1CritterIndex), selectedMove, targetPos)
	turnActions.append(action)
	handleNextCritterTurn()

func handleNextCritterTurn() -> void:
	p1CritterIndex += 1
	if p1CritterIndex >= getActiveCrittersInGroup("p1").size():
		endTurn()
		return 
	$BattleUI.setMoves(getCrittersInGroupByActiveIndex("p1", p1CritterIndex).getMoves())
	get_tree().get_nodes_in_group("move_button").front().grab_focus()
	
func endTurn() -> void:
	# determine who goes first with speed + effects
	# calculate damage for all
	turnActions.sort_custom(sortTurnActions)
	while !turnActions.is_empty():
		var action := turnActions[0]
		$BattleUI.printText(action.actionInfo())
		if action.getMove() == null:
			switchCritter(getCrittersByBattlePosition(action.getDefenders())[0], getActiveCrittersInGroup("p1").find(action.getAttacker()), true)
			turnActions.erase(action)
			turnActions.sort_custom(sortTurnActions)
			continue

		var movePower: float = action.getMove().getPower() * min((0.3 + action.getAttacker().getLevel() / 100.0), 1.0)
		# check physical vs range
		var atk: float
		match action.getMove().getAttribute():
			Move.attributeType.DIRECT:
				atk = action.getAttacker().getCritter().getAttackForCalc()
			Move.attributeType.RANGE:
				atk = action.getAttacker().getCritter().getRangeAttackForCalc()
		# check for STAB
		for defender in getCrittersByBattlePosition(action.getDefenders()):
			if randf_range(0, 100) <= action.getMove().getAccuracy():
				var randomness := randf_range(.96, 1.04)
				var def: float
				match action.getMove().getAttribute():
					Move.attributeType.DIRECT:
						def = defender.getCritter().getDefenseForCalc()
					Move.attributeType.RANGE:
						def = defender.getCritter().getRangeDefenseForCalc()
						
				if action.getMove().getAttribute() != Move.attributeType.STATUS:
					var typeAdvantage: float = typeManager.getAdvantage(action.getMove().getType(), defender.getCritter().getType())
					defender.dealDamage(movePower * typeAdvantage * atk / def * randomness)
				defender.getCritter().applyEffects(action.getMove().getEffects())
				if defender.isDefeated():
					$BattleUI.printText(defender.getName() + " was defeated. " + action.getAttacker().getName() + " gained " + str(defender.getExpGiven()) + " exp.")
					action.getAttacker().gainExperience(defender.getExpGiven())
			else:
				$BattleUI.printText("Move missed")
		turnActions.erase(action)
		turnActions.sort_custom(sortTurnActions)
		checkForDefeatedCritters()
	# check arena conditions + 
	# advance turn counter 1
	for critter in getActiveCrittersInGroup("p1"):
		critter.incrementTurn()
	for critter in getActiveCrittersInGroup("p2"):
		critter.incrementTurn()
	startTurn()
	pass
	
func catchCritter() -> void:
	# switch to mini game here
	$Player.addCritter(enemy.getCritters()[0])
	endBattle()
	
func checkForDefeatedCritters() -> void:
	for p1Critter in getActiveCrittersInGroup("p1"):
		if p1Critter.isDefeated():
			# Give player option to switch
			pass
			
	var index := 0
	for p2Critter in getActiveCrittersInGroup("p2"):
		if p2Critter.isDefeated():
			printText(p2Critter.getName() + " is defeated.")
			p2Critter.setIsInBattle(false)
			self.remove_child(p2Critter)
			# Add AI picking logic
			for crit in rightCritters:
				if !crit.isDefeated() and !crit.getIsInBattle():
					switchCritter(crit, index, false)
		index += 1
	# if any in group p1 or p2 is defeated
	checkBattleOver()
	
func checkBattleOver() -> void:
	if $Player.isDefeated() or enemy.isDefeated():
		endBattle()
	
func switchCritter(critterSwappedIn: CritterInstance, activeIndex: int, p1: bool = true) -> void:
	var pos: Vector2
	var swappedOut: CritterInstance = getCrittersInGroupByActiveIndex("p1" if p1 else "p2", activeIndex)
	pos = swappedOut.get_position()
	swappedOut.setIsInBattle(false)
	self.remove_child(swappedOut)
	
	$BattleUI.printText("Switched from " + swappedOut.getName() + " to " + critterSwappedIn.getName() + ".")

	critterSwappedIn.position = pos
	critterSwappedIn.setBattlePosition(swappedOut.getBattlePosition())
	critterSwappedIn.setIsInBattle(true)
	
	swappedOut.setBattlePosition(-1)

	self.add_child(critterSwappedIn)
	
func endBattle() -> void:
	SceneManager.endScene()
	
func printText(msg: String) -> void:
	$BattleUI.printText(msg)

func castArray(input: Array[Node]) -> Array[CritterInstance]:
	var output: Array[CritterInstance] = []
	for i in input:
		output.append(i as CritterInstance)
	return output
	
func castArrayIns(input: Array[CritterInstance]) -> Array[Node]:
	var output: Array[Node] = []
	for i in input:
		output.append(i as Node)
	return output

func setIsWild(isWild: bool) -> void:
	$BattleUI.setIsWild(isWild)

func sortTurnActions(a: Action, b: Action) -> bool:
	# switched critters
	if a.getMove() == null:
		return true
	if b.getMove() == null:
		return false
	if a.getMove().getAdvantage() == b.getMove().getAdvantage():
		if a.getAttacker().getSpeedForCalc() > b.getAttacker().getSpeedForCalc():
			return true
		else:
			return false
	elif a.getMove().getAdvantage() > b.getMove().getAdvantage():
		return true
	else:
		return false

func getCrittersInGroupByActiveIndex(group: String, activeIndex: int) -> CritterInstance:
	var i := 0
	for critter: CritterInstance in get_tree().get_nodes_in_group(group):
		if critter.getIsInBattle():
			if i == activeIndex:
				return critter
			i += 1
	Log.error("Could not find valid critter for index" + str(p1CritterIndex))
	return null

func getActiveCrittersInGroup(group: String) -> Array[CritterInstance]:
	var output: Array[CritterInstance] = []
	for critter: CritterInstance in get_tree().get_nodes_in_group(group):
		if critter.getIsInBattle():
			output.append(critter)
	return output
	
func getCrittersByBattlePosition(posList: Array[int]) -> Array[CritterInstance]:
	var allCritters: Array[CritterInstance] = leftCritters + rightCritters
	var output: Array[CritterInstance] = []
	for pos in posList:
		if pos == -1:
			Log.error("Trying to attack critter with battle position -1")
		for crit in allCritters:
			if crit.getBattlePosition() == pos:
				output.append(crit)
	return output
