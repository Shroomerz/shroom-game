class_name Pathfinding
extends Node2D

@onready var ray = $RayCast2D
@export var vec_length := 20
var number_of_dir := 8
var old_interest_importance := 0.2

var obstacles: Array[float] = [0, 0, 0, 0, 0, 0, 0, 0]
var interest: Array[float] = [0, 0, 0, 0, 0, 0, 0, 0]
var old_interest: Array[float] = [0, 0, 0, 0, 0, 0, 0, 0]
var outcome: Array[float] = [0, 0, 0, 0, 0, 0, 0, 0]
var directions: Array[Vector2] = [
	Vector2(0, -1),
	Vector2(1, -1),
	Vector2(1, 0),
	Vector2(1, 1),
	Vector2(0, 1),
	Vector2(-1, 1),
	Vector2(-1, 0),
	Vector2(-1, -1),
]


func _ready() -> void:
	for i in range(number_of_dir):
		directions[i] = directions[i].normalized()
	ray.enabled = false
		
func prev(i: int) -> int:
	return (i - 1) % number_of_dir

func next(i: int) -> int:
	return (i + 1) % number_of_dir

func get_movement_direction(target: Vector2) -> Vector2:
	
	ray.enabled = true
	for i in range(number_of_dir):
		ray.target_position = directions[i] * vec_length
		ray.force_raycast_update()  
		obstacles[i] = 0
		old_interest[i] = interest[i]
		interest[i] = directions[i].dot(target)
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider is not Player:
				obstacles[i] += 5
				obstacles[prev(i)] += 3
				obstacles[next(i)] += 3
	ray.enabled = false
	if obstacles.max() == 0:
		return target.normalized()
	for i in range(number_of_dir):
		interest[i] -= obstacles[i]
		outcome[i] = interest[i] + old_interest_importance * old_interest[i]
	return directions[outcome.find(outcome.max())].normalized()
	
	
