extends Node


var isle: IsleData
var mainland: MainlandData
var guild: GuildData


func _ready() -> void:
	isle = IsleData.new()
	mainland = MainlandData.new()
	guild = GuildData.new()
