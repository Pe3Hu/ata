class_name Wasteland
extends Node2D


var ruin_scene = preload('uid://be7e3woi3dihb')
var mine_scene = preload('uid://c6muhtgmpfhws')

var data: WastelandData:
	set(value_):
		data = value_
		
		init_ruins()
		init_mines()
		position = data.center * Catalog.MAINLAND_CELL_SIZE


#region init
func init_ruins() -> void:
	for ruin_data in data.ruins:
		add_ruin(ruin_data)

func add_ruin(ruin_data_: RuinData) -> void:
	var ruin = ruin_scene.instantiate()
	%Ruins.add_child(ruin)
	ruin.data = ruin_data_

func init_mines() -> void:
	for mine_data in data.mines:
		add_mine(mine_data)

func add_mine(mine_data_: MineData) -> void:
	var mine = mine_scene.instantiate()
	%Mines.add_child(mine)
	mine.data = mine_data_
#endregion
