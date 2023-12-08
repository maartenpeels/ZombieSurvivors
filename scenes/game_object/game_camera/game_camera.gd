extends Camera2D

var target_position = Vector2.ZERO
var smoothing_value = 20


func _ready():
	make_current()


func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * smoothing_value))


func acquire_target():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		target_position = player_node.global_position
