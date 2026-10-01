class_name Spark
extends PanelContainer


var data: SparkData:
	set(value_):
		data = value_
		
		%Volume.frame_coords = Helper.get_coord_based_on_value(data.volume)
		%Amount.text = 'x%d' % data.amount
