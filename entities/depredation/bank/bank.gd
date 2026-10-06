class_name Bank
extends PanelContainer


var method_scene = preload('uid://b17pieyxi25xn')

var data: BankData:
	set(value_):
		data = value_
		
		init_methods()


func init_methods() -> void:
	for method_data in data.methods:
		add_method(method_data)

func add_method(method_data_: MethodData) -> void:
	var method = method_scene.instantiate()
	%Methods.add_child(method)
	method.data = method_data_
