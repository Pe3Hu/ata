class_name Trod
extends Line2D


var data: TrodData:
	set(value_):
		data = value_
		
		connect_signals()
		init_points()


func connect_signals() -> void:
	data.type_chaned.connect(_on_type_changed)
	_on_type_changed()
	data.clockwise_chaned.connect(_on_clockwise_changed)
	_on_clockwise_changed()

func _on_type_changed() -> void:
	visible = data.type != Bozo.Trod.NONE
	var is_selected = data.type == data.mainland.route.selected_type
	var frequency = Catalog.TROD_FREQUENCY
	var speed = Catalog.TROD_SPEED
	
	if is_selected:
		frequency *= Catalog.TROD_SELECTED_FACTOR
		speed *= Catalog.TROD_SELECTED_FACTOR
	
	material.set_shader_parameter("frequency", frequency)
	material.set_shader_parameter("speed", speed)
	
	#var color_even: Color
	#
	#match data.type:
		#Bozo.Trod.PRIMARY:
			#color_even = Color.WHITE
		#Bozo.Trod.SECONDARY:
			#color_even = Color.BLACK
		#Bozo.Trod.TERTIARY:
			#color_even = Color.DIM_GRAY
	#
	#material.set_shader_parameter("color_even", color_even)

func _on_clockwise_changed() -> void:
	var direction = -1
	
	if not data.is_clockwise:
		direction *= -1
	
	material.set_shader_parameter("direction", direction)

func init_points() -> void:
	var a = Helper.get_structure_position(data.structures[0], true)
	var b = Helper.get_structure_position(data.structures[1], true)
	
	var offset = (b - a) * 0.1
	points = [a + offset, b - offset]
	
	#material.set_shader_parameter("line_start", a)
	#material.set_shader_parameter("line_end", b)
