class_name Counter

signal limit_reached

var limit: int
var current: int


func _init(_limit: int, _current: int = 0):
	limit = _limit
	current = _current


func increase(step: int = 1):
	current += step
	if current >= limit:
		for over in range(float(current) / limit):
			limit_reached.emit()
		current = current % limit
