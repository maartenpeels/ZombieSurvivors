extends CanvasLayer


func _ready():
	get_tree().paused = true


func set_defeat():
	$%TitleLabel.text = "Defeat"
	$%DescLabel.text = "You lost!"


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_quit_button_pressed():
	# TODO: go to main menu
	get_tree().quit()
