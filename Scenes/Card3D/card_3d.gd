class_name Card3D extends Node3D

@onready var card_name_lbl = $CardNameLbl

@export var card_data: CardData = Spell.new()

var is_highlight: bool = false  # подсвечена ли карта 
var height_offset: float = 0.0 # велечина на которую нужно дополнительно поднять картуучитывая её позицию на "круге" руки. (Карты расположенные правее будут ниже)
var is_drag = false  # перетаскивается ли карта
var angle_in_hand = Vector3(0, 0, 0)  # угол карты в руке в момент её добавления. Нужен чтобы мы смогли вернуть карту в исходную позицию.
var pos_in_hand_y: float   # координаты карты в руке в момент её добавления. Нужены чтобы мы смогли вернуть карту в исходную позицию.
var over_field: Field
const hightlight_height = 1.5  # высота подьёма выбранной карты (можно сделать глобальной)

var my_tween_list: MyTweenList = MyTweenList.new() # Список активных твинов. Нужен для оставноки всех активных анимаций карты.

var pos_duration : float = .2
var rotate_duration : float = .2
var hightlight_daration : float = .2


signal mouse_entered(card: Card3D)
signal mouse_exited(card: Card3D)
signal dragging(card: Card3D)
signal dropped(card: Card3D)


func set_card_name(name):
	card_name_lbl.set_text(name)


# Функция "следования за мышкой".
# Принимает на вход координаты мышки и устанавливает меняет позицию карты
func follow(pos):  
	
	var my_tween_list_lenght = len(my_tween_list.get_list())
	my_tween_list.kill_all() # Останавливаем все анимации которые проиходят в данный момент

	if my_tween_list_lenght > 0: # Если такие анимации есть, то после их прерывания необходимо привести их в конечное состояние. Перетаскиваемая карта - selected. А значит hightlight.
		self.set_scale(Vector3(1.2, 1.2, 1.2)) # Делаем карту подсвеченной
		self.set_rotation_degrees(Vector3(0, 0, 0))
		self.set_position(Vector3(self.position[0], pos_in_hand_y + hightlight_height + height_offset, self.position[2]))
	
	self.global_position.x = pos[0] # Меняем позицию карты. 
	self.global_position.y = pos[1]


# TODO("Подумать о переносе в класс руки на основании того, что карта может быть hightlight только в руке")
func highlight():
	if is_drag:
		return
		
	self.is_highlight = true
	
	var tween = create_tween().set_parallel(true)
	my_tween_list.add_tween(tween)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3(1.2, 1.2, 1.2) , hightlight_daration)
	tween.tween_property(self, "rotation_degrees", Vector3(0, 0, 0) , rotate_duration)
	tween.tween_property(self, "position:y", pos_in_hand_y + hightlight_height + height_offset, pos_duration)


func hi():
	var mesh_instance = $CardMesh/FrontMesh
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1, 0, 0)  # Устанавливаем красный цвет
	mesh_instance.material_override = material


func unhi():
	var mesh_instance = $CardMesh/FrontMesh
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1, 1, 1)  # Устанавливаем красный цвет
	mesh_instance.material_override = material


func unhighlight():
	if is_drag:
		return
		
	self.is_highlight = false
	
	var tween = create_tween().set_parallel(true)
	my_tween_list.add_tween(tween)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3(1, 1, 1) , hightlight_daration)
	tween.tween_property(self, "rotation_degrees", angle_in_hand , rotate_duration)
	tween.tween_property(self, "position:y", pos_in_hand_y , pos_duration)


func set_anim_pos(x, y):
	var tween = create_tween().set_parallel(true)
	my_tween_list.add_tween(tween)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:x", x, pos_duration)
	tween.tween_property(self, "position:y", y, pos_duration)


func set_anim_rotation_degrees(angle):
	var tween = create_tween()
	my_tween_list.add_tween(tween)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation_degrees", angle, rotate_duration)



func _on_static_body_3d_mouse_entered() -> void:
	mouse_entered.emit(self)


func _on_static_body_3d_mouse_exited() -> void:
	mouse_exited.emit(self)



func _on_area_3d_area_entered(area: Area3D) -> void:
	var parent = area.get_parent_node_3d()
	
	if parent is Field:
		over_field = parent


func _on_area_3d_area_exited(area: Area3D) -> void:
	var parent = area.get_parent_node_3d()
	if parent is Field:
		over_field = null


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:
			
			if event.pressed:
				dragging.emit(self)
				is_drag = true

			else:
				if is_drag:
					dropped.emit(self)
				is_drag = false
		
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			Global.CARD_PREVIEW.add_card_preview(self)