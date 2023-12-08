extends Node2D


func _on_area_2d_area_entered(area):
	GameEvents.emit_experience_vial_collected(1)
	queue_free()
