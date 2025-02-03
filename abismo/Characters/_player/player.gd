extends CharacterBody2D

@export var speed = 500

func _ready():
	speed = speed * 40

func _process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed * delta
	
	move_and_slide()
