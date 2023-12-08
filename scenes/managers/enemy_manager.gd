extends Node

const SPAWN_RADIUS = 375 # Window width is 640. We spawn outside the window

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer: Timer = $Timer

var base_spawn_rate = 0


func _ready():
	base_spawn_rate = timer.wait_time
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spwan_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for direction in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		
		var params = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(params)
		
		if result.is_empty():
			break
		
		random_direction = random_direction.rotated(deg_to_rad(90))
		
	return spawn_position


func _on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemy = basic_enemy_scene.instantiate() as Node2D
	enemy.global_position = get_spwan_position()
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)


func on_arena_difficulty_increased(arena_difficulty: int):
	# 0.1 a minute (12 chunks of 5 seconds)
	var time_decrease = (0.1 / 12) * arena_difficulty
	time_decrease = min(time_decrease, 0.7)
	timer.wait_time = base_spawn_rate - time_decrease
