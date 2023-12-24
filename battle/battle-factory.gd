extends Node

var enemy_scene = preload("res://battle/enemy.tscn")
var single_scene = preload("res://battle/battle-single/Battle.tscn")

func startWildBattle(critter: Critter):
	var battle = single_scene.instantiate()
	var current = get_tree().get_nodes_in_group("area")
	battle.setMapScene(current)
	
	var enemy = enemy_scene.instantiate()
	var team = Team.new()
	team.addCritter(critter)
	enemy.setTeam(team)
	battle.setEnemy(enemy)
	var root = get_tree().get_root()
	root.add_child(battle)
	get_tree().set_current_scene(battle)
	for c in current:
		root.remove_child(c)


