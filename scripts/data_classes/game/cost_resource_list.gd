extends Resource
class_name CostResourceList

# Можно конечно сделать через enum, но я (Валерий) не вижу смысла.
var resource_list: Array[int] = [0, 0, 0]

func get_material_esource():
	return resource_list[0]

func get_money_resource():
	return resource_list[1]
	
func get_mana_resource():
	return resource_list[2]

# TODO("set")
