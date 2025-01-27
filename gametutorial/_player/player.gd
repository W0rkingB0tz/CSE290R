extends Area2D
signal died
signal shield_changed

@export var speed = 150
@export var cooldown = 0.25
@export var bullet_scene : PackedScene
@export var max_shield = 10
var shield = max_shield:
	set = set_shield

var can_shoot = true

@onready var screensize = get_viewport_rect().size
@onready var ship_sprite = $Ship
@onready var boosters_sprite = $Ship/Boosters


func _ready():
	start()

func start():
	position = Vector2(screensize.x / 2, screensize.y - 64)
	$GunCooldown.wait_time = cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	if input.x > 0:
		ship_sprite.frame = 2
		boosters_sprite.animation = "right"
	elif input.x < 0:
		ship_sprite.frame = 0
		boosters_sprite.animation = "left"
	else:
		ship_sprite.frame = 1
		boosters_sprite.animation = "forward"
	position += input * speed * delta
	position = position.clamp(Vector2(8,8), screensize - Vector2(8,8))
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot():
	if not can_shoot:
		return
	can_shoot = false
	$GunCooldown.start()
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(position + Vector2(0,-8))

func _on_gun_cooldown_timeout() -> void:
	can_shoot = true

func set_shield(value):
	shield = min(max_shield, value)
	shield_changed.emit(max_shield, shield)
	if shield <= 0:
		hide()
		died.emit()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.explode()
		shield -= 4
