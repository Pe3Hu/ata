class_name Ruin
extends Structure


var data: RuinData:
	set(value_):
		data = value_
		
		position = Vector2(data.cell) * Catalog.MAINLAND_CELL_SIZE * 0.75
		Helper.update_colors(%Body, data.matter)
