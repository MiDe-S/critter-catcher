extends Node

var enemy_scene = preload("res://battle/enemy.tscn")
var single_scene = preload("res://battle/battle-single/Battle.tscn")

func startWildBattle(critter: Critter):
	var battle = single_scene.instantiate()
	
	var enemy = enemy_scene.instantiate()
	var team = Team.new()
	team.addCritter(critter)
	enemy.setTeam(team)
	battle.setEnemy(enemy)
	SceneManager.startScene(battle)

func startScannerBattle(npc: NPC):
	var battle = single_scene.instantiate()
	# Node must have named $Enemy
	var enemy = enemy_scene.instantiate()
	enemy.setTeam(npc.getTeam())
	battle.setEnemy(enemy)
	SceneManager.startScene(battle)
