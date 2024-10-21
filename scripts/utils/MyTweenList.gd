extends Resource
class_name MyTweenList

var tween_list: Array[Tween] = []


func get_list():
	return tween_list
	
	
func add_tween(tween: Tween):
	tween_list.append(tween)
	tween.finished.connect(func(): _remove_tween(tween))
	
	
func _remove_tween(tween: Tween):
	tween_list.erase(tween)


func kill_all():
	for t in tween_list:
		t.kill()
