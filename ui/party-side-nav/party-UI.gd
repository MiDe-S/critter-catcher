extends Control

@export var cellScene: PackedScene
@export var infoScene: PackedScene
@onready var container := $CanvasLayer/Path2D/PathFollow2D/ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh()

func refresh() -> void:
	clear()
	var critters: Array[Critter] = PlayerManager.getPlayerInfo().getCritters()
	var cell_size: Vector2
	var i := 0
	for critter: Critter in critters:

		
		# create cell
		var cell := cellScene.instantiate()
		cell.initialize(critter)
		cell.orderChanged.connect(changePartyOrder)
		cell.showCritInfo.connect(showCritterInfo)
		container.add_child(cell)
		cell.position.y += i * cell.size.y
		i += 1
		# save to set conainer size
		cell_size = cell.size
	container.size = cell_size * Vector2(1, GlobalVariables.PARTY_SIZE)

func clear() -> void:
	for n in container.get_children():
		n.queue_free()

func changePartyOrder() -> void:
	# reorder team based on y positions
	var team := Team.new()
	var child_nodes := container.get_children()
	child_nodes.sort_custom(sortCellsByHeight)
	for node in child_nodes:
		team.addCritter(node.getCritter())
	PlayerManager.getPlayerInfo().setTeam(team)
	refresh()
	
func sortCellsByHeight(a: Variant, b: Variant) -> bool:
	return a.global_position.y < b.global_position.y

func freeSelf() -> void:
	$CanvasLayer/Path2D/PathFollow2D.reverse = true
	await $CanvasLayer/Path2D/PathFollow2D.finished
	self.queue_free()

func showCritterInfo(critter: Critter) -> void:
	if critter == null:
		for n in get_tree().get_root().get_children():
			if n is CritterInfoUI:
				n.queue_free()
	else:
		var info := infoScene.instantiate()
		info.setCritter(critter)
		get_tree().get_root().add_child(info)
