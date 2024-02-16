class_name WeightedTable

var rows: Dictionary = {}
var weight_sum = 0


# Insert new row. Overwrite if exists.
func put_row(item, weight: int) -> void:
	assert(weight > 0)
	weight_sum -= 0 if not rows.has(item) else rows[item] # Sub. prev. weight if exists
	weight_sum += weight
	rows[item] = weight


# Update weight of item.
# Callable can have one argument that is current weight of the item.
# Callable should return new positive weight for the item.
# Return false if weight for item is not found or the callable returns wrong variant.
func update_weight(item, update_fn: Callable) -> bool:
	if not rows.has(item): return false
	var before = rows[item]
	var after = update_fn.call(rows[item], item)
	assert(after is int and after > 0)
	rows[item] = after
	weight_sum += after - before
	return true


func pick_or_default(default = null):
	var rand_weight = randi_range(1, weight_sum)
	var acc = 0
	for item in rows.keys():
		var weight = rows[item]
		acc += weight
		if rand_weight <= acc:
			return item
	return default
