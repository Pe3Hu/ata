class_name Quotum
extends PanelContainer


var data: QuotumData:
	set(value_):
		data = value_
		
		%Shard.data = data.shard
		%Amount.text = 'x%d' % data.amount
