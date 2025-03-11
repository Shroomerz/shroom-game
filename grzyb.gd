extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var marcher = CubeMarcher.new()
	marcher.set_SDF(specific_shroom.new(Vector3(0.19,0.4,0), 0.2, Vector2(1.77,1.63), Vector2(0.02,-0.3),Vector3(0.11,0,0), Vector3(0.24,0.22,0.0) ,Vector3(0.16,0.09,0.14),Vector4(0.1, 0.1, 0.1, 0.1), Vector3(0.05,0,0)))
	##										    cap_pos	    cap_height  cap ratios		cap_propeties			leg pos			    leg mid				leg elip					leg_r 				leg_cap_offset	   	
	#marcher.set_SDF(specific_shroom.new(Vector3(0.0,0.8,0.0), 0.5, Vector2(0.9,0.8), Vector2(0.03,-0.2),Vector3(0,0,0), Vector3(0.0,0.3,0.0) ,Vector3(0.3,0.3,0.3),Vector4(0.2, 0.2, 0.2, 0.2), Vector3(0,0,0)))
	#marcher.set_SDF(Ball.new())
	var m = MeshInstance3D.new()
	m.mesh = marcher.get_mesh()
	add_child(m)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
