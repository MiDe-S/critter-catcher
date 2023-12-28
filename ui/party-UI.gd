extends Control

@export var cellScene: PackedScene
@onready var container := $CanvasLayer/Path2D/PathFollow2D/ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()

func refresh():
	clear()
	var critters = PlayerManager.getPlayerInfo().getCritters()
	var cell_size: Vector2
	$CanvasLayer/Label.text = "Team:\n"
	var i := 0
	for critter in critters:
		# debug info
		var output = ""
		output += critter.getName() + " "
		output += "Lvl." + str(critter.getLevel()) + " "
		output += str(critter.getHealth()) + " / " + str(critter.getMaxHealth()) + " | "
		output += str(critter.getAttackForCalc()) + " | "
		output += str(critter.getDefenseForCalc()) + " | "
		output += str(critter.getRangeAttackForCalc()) + " | "
		output += str(critter.getRangeDefenseForCalc()) + " | "
		output += str(critter.getSpeedForCalc()) + " | "
		for move in critter.getMoves():
			output += move.getName() + " "
		output += "\n"
		$CanvasLayer/Label.text += output
		
		# create cell
		var cell = cellScene.instantiate()
		cell.initialize(critter)
		cell.connect("orderChanged", changePartyOrder)
		container.add_child(cell)
		cell.position.y += i * cell.size.y
		i += 1
		# save to set conainer size
		cell_size = cell.size
	container.size = cell_size * Vector2(1, GlobalVariables.PARTY_SIZE)

func clear():
	for n in container.get_children():
		n.queue_free()

func changePartyOrder(y: int, critter: Critter) -> void:
	# reorder team based on y positions
	var team := Team.new()
	var child_nodes = container.get_children()
	child_nodes.sort_custom(func(a, b): return a.global_position.y < b.global_position.y)
	for node in child_nodes:
		team.addCritter(node.getCritter())
	PlayerManager.getPlayerInfo().setTeam(team)
	refresh()

func freeSelf() -> void:
	$CanvasLayer/Path2D/PathFollow2D.reverse = true
	await $CanvasLayer/Path2D/PathFollow2D.finished
	self.queue_free()
