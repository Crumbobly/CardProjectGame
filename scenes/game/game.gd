extends Node3D

@onready var card3d_scene: PackedScene = preload("res://scenes/card3d/Card3D.tscn") #  Запакованная сцена карты
@onready var hand = $Hand


func _on_button_pressed() -> void:
	hand.add_card(card3d_scene.instantiate())


func _on_button_2_pressed() -> void:
	pass
