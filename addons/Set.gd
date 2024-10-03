
class_name Set extends Resource

var elements: Dictionary = {}

func add(item) -> void:
	elements[item] = true

func remove(item) -> void:
	elements.erase(item)

func has(item) -> bool:
	return elements.has(item)

func size() -> int:
	return elements.size()

func clear() -> void:
	elements.clear()

func to_array() -> Array:
	return elements.keys()
