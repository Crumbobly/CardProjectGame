class_name Card extends Node2D

@export var card_name: String = "card_name"
@export var _angle: float = 0.0
@export var is_highlight: bool = false
@export var height_offset: float = 0.0

@onready var CardNameLabel: Label = $CardNameLabel
@onready var CardFrame: Sprite2D = $CardFrame
@onready var CardArea: Area2D = $CardArea

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)


func _ready() -> void:
	CardNameLabel.set_text(card_name)


"""
Использовать шейдер?
Установка scale при добавлении карты = 0.4, увеличение до 0.5
Желательно сделать как глобальные переменные или ...
То же самое касается unhighlight
"""
func highlight():
	is_highlight = true
	self.set_scale(Vector2(0.5,0.5))
	self.global_position.y -= 150 + height_offset
	_angle = self.rotation
	self.set_rotation(0)


func unhighlight():
	is_highlight = false
	self.set_scale(Vector2(0.4,0.4))
	self.global_position.y += 150 + height_offset
	self.set_rotation(_angle)
	

func _on_card_area_mouse_entered() -> void:
	mouse_entered.emit(self)


func _on_card_area_mouse_exited() -> void:
	mouse_exited.emit(self)
