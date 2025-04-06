extends GutTest

var save_system

func before_each():
	save_system = load("res://Globals/SaveSystem.gd").new()

func after_each():
	save_system = null

func test_save_and_load_data():
	# Mock data to save
	var data_to_save = {
		"category1": ["item1", "item2"],
		"category2": ["item3", "item4"],
		"category3": ["item5"]
	}
	
	# Save data to slot 1
	save_system.save_data(1, data_to_save)
	
	# Load data from slot 1
	var loaded_data = save_system.load_data(1)
	
	# Assert that the loaded data matches the saved data
	assert_eq(loaded_data["category1"], ["item1", "item2"])
	assert_eq(loaded_data["category2"], ["item3", "item4"])
	assert_eq(loaded_data["category3"], ["item5"])

func test_multiple_save_slots():
	# Mock data for different slots
	var slot1_data = {
		"category1": ["item1"],
		"category2": ["item2"]
	}
	var slot2_data = {
		"category1": ["item3", "item4"],
		"category2": ["item5"]
	}
	
	# Save to slot 1
	save_system.save_data(1, slot1_data)
	
	# Save to slot 2
	save_system.save_data(2, slot2_data)
	
	# Load from slot 1
	var loaded_slot1 = save_system.load_data(1)
	
	# Load from slot 2
	var loaded_slot2 = save_system.load_data(2)
	
	# Assert that the loaded data matches the saved data for each slot
	assert_eq(loaded_slot1["category1"], ["item1"])
	assert_eq(loaded_slot1["category2"], ["item2"])
	
	assert_eq(loaded_slot2["category1"], ["item3", "item4"])
	assert_eq(loaded_slot2["category2"], ["item5"])

func test_load_non_existent_slot():
	# Attempt to load from a non-existent slot
	var loaded_data = save_system.load_data(3)
	
	# Assert that it returns null or an empty dictionary
	assert_eq(loaded_data, null)  # or assert_eq(loaded_data, {}) if you prefer empty dict

func test_add_item_to_existing_save():
	# Initial data
	var initial_data = {
		"category1": ["item1"],
		"category2": ["item2"]
	}
	
	# Save initial data
	save_system.save_data(1, initial_data)
	
	# Add a new item
	save_system.add_item(1, "category1", "item3")
	save_system.add_item(1, "category2", "item4")
	
	# Load the updated data
	var updated_data = save_system.load_data(1)
	
	# Assert that the new items are added
	assert_eq(updated_data["category1"], ["item1", "item3"])
	assert_eq(updated_data["category2"], ["item2", "item4"])

func test_remove_item_from_existing_save():
	# Initial data
	var initial_data = {
		"category1": ["item1", "item2"],
		"category2": ["item3", "item4"]
	}
	
	# Save initial data
	save_system.save_data(1, initial_data)
	
	# Remove an item
	save_system.remove_item(1, "category1", "item2")
	save_system.remove_item(1, "category2", "item4")
	
	# Load the updated data
	var updated_data = save_system.load_data(1)
	
	# Assert that the items are removed
	assert_eq(updated_data["category1"], ["item1"])
	assert_eq(updated_data["category2"], ["item3"])
