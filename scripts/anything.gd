extends Node


func _ready():
	var default = {"a": {"aa": "aa", "bb": "bb"}, "b": "c"}
	var setting = default.duplicate(true)
	var other = {"a": {"aa": "bb"}, "c": "b"}
	var temp = default.duplicate(true)
	temp.merge(other, true)
	print(temp)
