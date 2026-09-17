class_name Mine
extends Structure


var data: MineData:
	set(value_):
		data = value_
		
		position = Vector2(data.cell) * Catalog.MAINLAND_CELL_SIZE * 0.75
		Helper.update_colors(%Body, data.matter)
