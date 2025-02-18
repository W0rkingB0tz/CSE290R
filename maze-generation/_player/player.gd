extends CharacterBody3D

const gravity = 9.8

@export var speed = 5
@export var jump_speed = 5
@export var mouse_sensitivity = 0.002


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _physics_process(delta: float) -> void:
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	
	move_and_slide()
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump_speed
