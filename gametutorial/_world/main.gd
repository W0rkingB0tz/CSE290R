extends Node2D

@onready var start_button = $CanvasLayer/CenterContainer/Start
@onready var game_over = $CanvasLayer/CenterContainer/GameOver
@onready var wave_label = $CanvasLayer/CenterContainer/Label

var enemy_scene = preload("res://_enemy/enemy.tscn")
var score = 0
var enemy_amount = 0
var wave_counter = 1

var changed_freq_low = 5
var changed_freq_high = 20

@export var freq_mod = 0.95

func _ready():
	$Player.hide()
	$Player.can_shoot = false
	start_button.show()
	game_over.hide()
	wave_label.hide()

func spawn_enemies():
	enemy_amount = 0  # Reset enemy amount before spawning new wave
	for x in range(9):
		for y in range(3):
			var enemy = enemy_scene.instantiate()
			var pos = Vector2(x * (16 + 8) + 24, 16 * 4 + y * 16)
			enemy.set_position(pos)  # Set position before adding as a child
			add_child(enemy)
			call_deferred("initialize_enemy", enemy, pos)
			enemy_amount += 1  # Increment enemy amount for each enemy added

func initialize_enemy(enemy, pos):
	enemy.start(pos)
	enemy.died.connect(_on_enemy_died)
	enemy.fire_rate(changed_freq_low, changed_freq_high)

func _on_enemy_died(value):
	score += value
	$CanvasLayer/UI.update_score(score)
	enemy_amount -= 1
	if enemy_amount == 0:
		wave_counter += 1
		wave_label.text = "Wave: " + str(wave_counter)
		wave_label.show()
		await get_tree().create_timer(1.0).timeout  # Small delay before spawning the next wave
		wave_label.hide()
		update_freq()
		spawn_enemies()

func _on_start_pressed() -> void:
	$Player.show()
	$Player.can_shoot = true
	start_button.hide()
	new_game()

func new_game():
	score = 0
	$CanvasLayer/UI.update_score(score)
	$Player.start()
	$Player.shield = $Player.max_shield
	spawn_enemies()

func _on_player_died() -> void:
	get_tree().call_group("enemies", "queue_free")
	$Player.can_shoot = false
	game_over.show()
	await get_tree().create_timer(2).timeout
	game_over.hide()
	start_button.show()

func update_freq():
	changed_freq_low *= freq_mod
	changed_freq_high *= freq_mod
