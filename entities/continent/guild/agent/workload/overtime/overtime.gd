class_name Overtime
extends Sprite2D



var coord: Vector2i:
	set(value_):
		coord = value_
		
		update_position()


func update_position() -> void:
	var gap = Catalog.OVERTIME_OFFSET + Catalog.OVERTIME_SIZE
	var x = gap.x * coord.x + (coord.y % Catalog.OVERTIME_GRID.y) *Catalog.OVERTIME_OFFSET.y * 2 
	var y = -gap.y * coord.y
	position = Vector2(x, y)
