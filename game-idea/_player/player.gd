extends CharacterBody2D

@export var speed = 20000
var score = 0

func _process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed * delta
	
	move_and_slide()

func update_score():
	score += 1
	print(score)
