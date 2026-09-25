class_name KernelData
extends RefCounted


#var mother: Mother

var usurer: UsurerData
var pie: PieData
var maelstrom: MaelstromData
var stepladder: StepladderData


#func _init(mother_: Mother) -> void:
	#mother = mother_
func _init() -> void:
	usurer = UsurerData.new(self)
	pie = PieData.new(self)
	maelstrom = MaelstromData.new(self)
	stepladder = StepladderData.new(self)
