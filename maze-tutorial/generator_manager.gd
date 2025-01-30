extends Node3D

var wall = preload("res://_assets/wall.tscn")
var floor = preload("res://_assets/floor.tscn")

var parent = get_parent()

func _ready():
	var wall1 = wall.instantiate()
	var wall2 = wall.instantiate()
	var floor = floor.instantiate()
	
	add_child(wall1)
	add_child(floor)
	wall2.rotation.y = 60
	add_child(wall2)
