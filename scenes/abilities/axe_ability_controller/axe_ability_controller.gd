extends Node

@export var axe_ability_scene: PackedScene

var damage: int = 10


func _on_timer_timeout():
	var axe_ability_instance = axe_ability_scene.instantiate() as Node2D
	var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	foreground.add_child(axe_ability_instance)
	axe_ability_instance.global_position = player.global_position
	axe_ability_instance.hitbox_component.damage = damage
