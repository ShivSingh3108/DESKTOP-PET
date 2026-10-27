extends Node2D

const PETS=[
	preload("res://scene/guard.tscn"),
	preload("res://scene/main.tscn"),
]
func _ready():
	add_child(PETS.pick_random().instantiate())
