extends Node2D

var black_box_scene = preload("res://Object/_blackBox/black_box_piece.tscn")

@export var border = Vector2(200, 200)
@export var amount_of_pieces = 5

func _ready():
	for pieces in amount_of_pieces:
		var black_box_piece = black_box_scene.instantiate()
		var x_pos = randf_range(-border.x, border.x)
		var y_pos = randf_range(-border.y, border.y)
		black_box_piece.position = Vector2(x_pos, y_pos)
		get_parent().add_child.call_deferred(black_box_piece)
