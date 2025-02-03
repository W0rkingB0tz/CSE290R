extends Node3D

# Chunk size and render distance
var chunk_size = 5
var render_distance = 2

# Reference to the player node
var player

# Track chunks
var chunks = {}

# Preload the chunk scene
var chunk_scene = preload("res://_world/floor.tscn")

func _ready():
	# Find the player node using its path in the scene tree
	player = get_node("/root/World/Player")
	
	# Initial chunk generation around the player
	update_chunks()

func _process(delta):
	if player:
		# Check if player has moved to a new chunk
		var current_chunk = get_current_chunk()
		if current_chunk not in chunks:
			update_chunks()

func get_current_chunk() -> Vector3:
	# Calculate player's current chunk position
	var chunk_x = int(floor(player.global_position.x / chunk_size))
	var chunk_y = int(floor(player.global_position.y / chunk_size))
	var chunk_z = int(floor(player.global_position.z / chunk_size))
	return Vector3(chunk_x, chunk_y, chunk_z)

func update_chunks():
	if not player:
		return
	
	# Get player's current chunk
	var current_chunk = get_current_chunk()
	print("Current chunk: ", current_chunk)

	# Generate chunks around the player within the render distance
	for x in range(-render_distance, render_distance + 1):
		for y in range(-render_distance, render_distance + 1):
			for z in range(-render_distance, render_distance + 1):
				var chunk_pos = current_chunk + Vector3(x, y, z)
				if chunk_pos not in chunks:
					print("Creating chunk at: ", chunk_pos)
					create_chunk(chunk_pos)

	# Remove chunks outside of the render distance
	var chunks_to_remove = []
	for chunk_pos in chunks.keys():
		if chunk_pos.distance_to(current_chunk) > render_distance:
			chunks_to_remove.append(chunk_pos)
	
	for chunk_pos in chunks_to_remove:
		remove_chunk(chunk_pos)

func create_chunk(chunk_pos: Vector3):
	# Instance the existing chunk scene
	var new_chunk = chunk_scene.instantiate()
	new_chunk.scale = Vector3(chunk_size, 1, chunk_size)
	new_chunk.transform.origin = chunk_pos * chunk_size

	chunks[chunk_pos] = new_chunk
	add_child(new_chunk)
	print("Chunk created at: ", chunk_pos)

func remove_chunk(chunk_pos: Vector3):
	# Remove the chunk from the scene tree and the chunks dictionary
	var chunk = chunks[chunk_pos]
	if chunk:
		remove_child(chunk)
		chunk.queue_free()
		chunks.erase(chunk_pos)
