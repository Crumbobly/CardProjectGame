extends CardLayout
class_name Field


@onready var shape: BoxShape3D = $Area3D/CollisionShape3D.shape
var circle_layut = CircleLayoutLogic.new(11.5)
@onready var collision_shape = $Area3D/CollisionShape3D
var line_layoyt = LineLayoutLogic.new()
@export var card_size : float = .7

var mouse_pos : Vector3



func recalculate_all_card_position(coords):
	var scale_tween : Tween = create_tween()
	if coords == null:
		return
	
	
	adjust_coords_pos(coords)	
	super.recalculate_all_card_position(coords)	
	0
	for index in range(len(coords)):
		var card: Card3D = card_collection[index]
		card.my_tween_list.add_tween(scale_tween)
		scale_tween.set_ease(Tween.EASE_OUT).set_parallel(true)
		
		
		card.position.x = coords[index]
		card.global_position.y = self.position.y
		scale_tween.tween_property(card, "scale",Vector3(0.4,0.4,0.4), 0.2)

func adjust_coords_pos(coord):
	if(len(coord) % 2 == 0):
		return 0
	else :
		for i in range(len(coord)):
			if coord[i] == 0:
				pass
			if coord[i] < 0:
				coord[i] -= card_size
			if coord[i] > 0:
				coord[i] += card_size

func _get_cards_distribution():
	line_layoyt._get_collider_corner(collision_shape)
	var current_card_count = len(card_collection)
	if current_card_count == 0:
		return null
	
	# Определение точек на отезке
	var coords = line_layoyt.distribute_points_with_max_distance(current_card_count, collision_shape)
	return coords
	
	
	


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseMotion:
		mouse_pos = event_position
