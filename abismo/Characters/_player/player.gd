extends CharacterBody2D

@export var speed = 500

func _ready():
	speed = speed * 40

func _process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed * delta
	
	move_and_slide()

func _on_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("pickable"):
		area.queue_free()
