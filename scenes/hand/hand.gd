class_name Hand 
extends CardLayout

var hand_radius = 11.5

var hand_circle = CircleLayoutLogic.new(hand_radius)  # Класс круга "руки"
var card3d_scene: PackedScene = preload("res://scenes/card3d/Card3D.tscn") #  Запакованная сцена карты




	
func _process(delta: float) -> void:
	if selected_card != null and selected_card.is_drag:
		var pos: Vector3 = Global.CAMERA.get_look_cords()
		selected_card.follow(pos)
	else:
		set_process(false)


func dragged_card(card: Card3D):
	card.stop_all_tween_animations()
	set_process(true)  # Включаем _process для следования карты


func dropped_card(card: Card3D):
	
	if card.over_field:
		var field = card.over_field
		remove_card(card)
		field.add_card(card)
		return
	
	if selected_card:
		var selected_card_index = card_collection.find(selected_card)
		var coords = hand_circle.move_apart(card_count, selected_card_index)
		recalculate_all_card_position(coords)
	
	else:
		var coords = _get_cards_distribution()
		recalculate_all_card_position(coords)


func _get_cards_distribution():
	
	var current_card_count = len(card_collection)
	if current_card_count == 0:
		return null
	
	# Определение точек на отезке
	var coords = hand_circle.distribute_points_with_max_distance(current_card_count)
	return coords


# Получение координат на которые нужно вернуть карту
# y - позиция карты в руке 
# Example: Мы навели курсор на карту, она стала hightlight, затем мы её перетащили и отпустили.
# :В этом случае карту нужно будет вернуть на ту высоту, на которой она была как hightlight карта.
# :Затем она сама сделается unhighlight и опуститься.
func recalculate_coords_for_return_card(card: Card3D, y):
	if card.is_highlight:
		return y + card.hightlight_height + card.height_offset
	return y


func recalculate_all_card_position(coords):
	
	if coords == null:
		return
		
	super.recalculate_all_card_position(coords)	

	for index in range(len(coords)):
		var card: Card3D = card_collection[index]
		var card_pos = hand_circle.get_card_position(coords[index]) # Определяем координаты карты на "круге" руки
		
		card.pos_in_hand_y = card_pos[1]  # Записываем в карту её исходную позицию на oY в руке.
		var hightlight_pos_offset = recalculate_coords_for_return_card(card, card_pos[1])  # Пересчитываем позицию карты на oY, исходя из данных о том, была ли текущая карта hightlight
		card.set_anim_pos(card_pos[0], hightlight_pos_offset)  # Перемещаем карту на нужные координаты

		var angle = Vector3(0, 0, -card_pos[2])  # Вектор наклона карты в руке
		
		# Если текущая карта selected, то мы не будем менять её наклон
		if card != selected_card:
			card.set_anim_rotation_degrees(angle)
			
		card.angle_in_hand = angle
		card.height_offset = hand_circle.circle_radius - card_pos[1]
	
	
func add_card(new_card3d: Card3D):
	super.add_card(new_card3d)
	
	randomize()
	new_card3d.card_id = generate_id()
	new_card3d.set_card_name(str(new_card3d.card_id))
	
	new_card3d.dragging.connect(dragged_card)
	new_card3d.dropped.connect(dropped_card)


func remove_card(card: Card3D):
	card.dragging.disconnect(dragged_card)
	card.dropped.disconnect(dropped_card)
	super.remove_card(card)

	
func card_selected(card: Card3D):
	# При перетаскивании карты она selected пока не будет отпущена игроком. Значит мы не можем сделать новой select
	if selected_card and selected_card.is_drag:
		return
		
	selected_card_z = card.position.z  
	card.position.z = 0.1  # Выносим карту на передний план
	selected_card = card  # переопределяем selected_card
	super.card_selected(card)

	var selected_card_index = card_collection.find(selected_card)
	var coords = hand_circle.move_apart(card_count, selected_card_index)
	recalculate_all_card_position(coords)


func card_unselected(card: Card3D):
	# При перетаскивании карты она selected пока не будет отпущена игроком. Значит мы не можем сделать unselect
	if selected_card and selected_card.is_drag:
		return
		
	card.position.z = selected_card_z  # Возвращаем карту на своё место в руке (по оси Z)
	selected_card_z = 0 
	super.card_unselected(card)


func card_highlight(card: Card3D):
	super.card_highlight(card)
	card.highlight_with_up()


func card_unhighlight(card: Card3D):
	super.card_unhighlight(card)
	card.unhighlight_with_up()
