extends Node3D
class_name CardLayout

@export var hand_cards: Node3D # Узел, куда будут помещаться карты

var card_collection: Array[Card3D] = []  # Коллекция карт
var selected_card: Card3D = null  # Выбранная в данный момент карта
var selected_card_z: float = 0  # Смещение по z выбранной карты
var card_count: int = 0  # Кол-во карт в руке (перетаскиваемая в данный момент карта считается)


var existing_ids = [] 
var char_pool = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@export var current_lenght = 5
var mouse_pos : Vector3


func generate_random_string(lenght : int) -> String:
	var result = ""
	for i in lenght:
		result += char_pool[randi() % char_pool.length()]
	return result


func generate_id() -> String:
	while true:
		var new_id = generate_random_string(current_lenght)
		if new_id not in existing_ids:
			existing_ids.append(new_id)
			return new_id
		if len(existing_ids) >= pow(char_pool.length(), current_lenght):
			current_lenght +=1
	return ""


func _ready():
	hand_cards = Node3D.new()
	hand_cards.name = "Cards"
	add_child(hand_cards)


func _get_cards_distribution():
	assert(false, "Not Implemented")


func recalculate_all_card_position(coords):
	
	if coords == null:
		return
		
	for index in range(len(card_collection)):
		if card_collection[index] == selected_card:
			continue
		card_collection[index].position.z = (index + 1) * 0.001


func add_card(new_card3d: Card3D):
	
	new_card3d.mouse_entered.connect(card_selected)
	new_card3d.mouse_exited.connect(card_unselected)
	
	var old_coords = _get_cards_distribution()
	var l = get_l_neightboor(old_coords, new_card3d)

	hand_cards.add_child(new_card3d)
	if l == -1:
		card_collection.insert(0, new_card3d)
	else:
		card_collection.insert(l + 1, new_card3d)
		
	card_count += 1

	var coords = _get_cards_distribution()
	recalculate_all_card_position(coords)


func get_l_neightboor(old_coords, card: Card3D):
	var curren_pos_x = card.over_field_coord_x

	if len(card_collection) == 0:
		return -1
	
	if curren_pos_x <= old_coords[0]:
		return -1
		
	elif old_coords[-1] <= curren_pos_x:
		return len(old_coords) - 1
		
	for i in range(len(old_coords)):
		if old_coords[i] > curren_pos_x:
			return i - 1
	
	assert(false, "Ошибка в функции определения граничных карт")
	


func remove_card(card: Card3D):
	card.mouse_entered.disconnect(card_selected)
	card.mouse_exited.disconnect(card_unselected)
	card_unselected(card)
	
	card_collection.erase(card)
	hand_cards.remove_child(card)
	card_count -= 1
	
	var coords = _get_cards_distribution()
	recalculate_all_card_position(coords)
	
	
func card_selected(card: Card3D):
	card_highlight(card)


func card_unselected(card: Card3D):
	card_unhighlight(card)
	card.is_drag = false
	selected_card = null
	
	# Располагаем карты по определённому порядку
	var coords = _get_cards_distribution()
	recalculate_all_card_position(coords)


func card_highlight(card: Card3D):
	card.highlight()
	

func card_unhighlight(card: Card3D):
	card.unhighlight()
