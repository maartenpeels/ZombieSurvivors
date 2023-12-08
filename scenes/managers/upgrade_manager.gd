extends Node

const MAX_AMOUNT_OF_UPGRADES_ON_SCREEN = 3

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if not has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity >= upgrade.max_quantity:
			upgrade_pool = upgrade_pool.filter(func(pool_upgrade: AbilityUpgrade): return pool_upgrade.id != upgrade.id)
	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func pick_upgrades():
	var choosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades = upgrade_pool.duplicate()
	for i in MAX_AMOUNT_OF_UPGRADES_ON_SCREEN:
		if filtered_upgrades.size() == 0:
			break
		
		var choosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		choosen_upgrades.append(choosen_upgrade)
		
		filtered_upgrades = filtered_upgrades.filter(func(upgrade: AbilityUpgrade): return upgrade.id != choosen_upgrade.id)
	
	return choosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


func on_level_up(current_level: int):
	if upgrade_pool.size() == 0:
		print("No upgrades left")
		return
	
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	
	var choosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(choosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
