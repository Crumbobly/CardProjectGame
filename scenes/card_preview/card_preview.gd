extends Node3D
class_name CardPreview

@onready var container_2d = $SubViewportContainer
@onready var timer = $Timer

var card_preview = null
var current_card = null

func _ready() -> void:
	
	card_preview = $"."
	Global.CARD_PREVIEW = card_preview
	
	timer.timeout.connect(_on_button_button_up)
	hide_content()


func add_card_preview(card: Card3D):
	
	if current_card:
		remove_child(current_card)
		stop_timer()
		
	var copy: Card3D = card.duplicate()
	current_card = copy
	
	copy.mouse_entered.connect(stop_timer)
	copy.mouse_exited.connect(start_timer)
	copy.unhighlight()
	copy.set_position(Vector3(0, 0, 0))
	copy.set_rotation(Vector3(0, 0, 0))
	copy.set_scale(Vector3(1.4, 1.4, 1.4))
	
	add_child(copy)
	
	show_content()
	start_timer()
	

func start_timer(card: Card3D = null):
	timer.set_wait_time(3)
	timer.start()


func stop_timer(card: Card3D = null):
	timer.stop()
	

func hide_content():
	container_2d.set_visible(false)


func show_content():
	container_2d.set_visible(true)


func remove_content():
	remove_child(current_card)
	current_card = null

	
func _on_button_button_up() -> void:
	stop_timer()
	hide_content()
	remove_content()
