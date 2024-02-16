class_name ArrayExt


static func find_or_default(arr: Array, predicate: Callable, default: int = -1) -> int:
	for i in arr.size():
		if predicate.call(arr[i]):
			return i
	return default


static func first_or_default(arr: Array, predicate: Callable, default = null):
	for e in arr:
		if predicate.call(e):
			return e
	return default


static func first_or_else(arr: Array, predicate: Callable, default: Callable = get_null):
	var first = first_or_default(arr, predicate, null)
	return first if first != null else default.call()


static func pop_first_or_default(arr: Array, predicate: Callable, default = null):
	var first_item = first_or_default(arr, predicate, default)
	arr.erase(first_item)
	return first_item


static func pop_first_or_else(arr: Array, predicate: Callable, default: Callable = get_null):
	var first = first_or_default(arr, predicate, null)
	return first if first != null else default.call()


static func get_null():
	return null
