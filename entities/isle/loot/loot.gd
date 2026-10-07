class_name Loot
extends PanelContainer


var spoil_scene = preload('uid://c2j2ueheonqnf')
var spark_scene = preload('uid://dxf630vjxmpad')

var data: LootData:
	set(value_):
		data = value_
		
		init_spoils()
		init_sparks()


func init_spoils() -> void:
	Helper.clear_children(%Spoils)
	
	for spoil_data in data.spoils:
		add_spoil(spoil_data)

func add_spoil(spoil_data_: SpoilData) -> void:
	var spoil = spoil_scene.instantiate()
	%Spoils.add_child(spoil)
	spoil.data = spoil_data_

func init_sparks() -> void:
	Helper.clear_children(%Sparks)
	
	for spark_data in data.sparks:
		add_spark(spark_data)

func add_spark(spark_data_: SparkData) -> void:
	var spark = spark_scene.instantiate()
	%Sparks.add_child(spark)
	spark.data = spark_data_
