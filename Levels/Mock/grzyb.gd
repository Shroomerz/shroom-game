extends Node3D

var marcher

var _new_mesh

func _on_button_button_down() -> void:
	#_new_mesh = MeshInstance3D.new()
	var shroom_shape_reference = get_node("ShroomShape")
	print(shroom_shape_reference.get_script())
	#shroom_shape_reference.set_cap(BezierCap.new())
	#get_node("ShroomShape").set_leg(BezierLeg.new())
	var time_beginning = Time.get_unix_time_from_system()
	get_node("ShroomShape").commit()
	#_new_mesh.mesh = marcher.get_mesh()
	#_new_mesh.mesh = ParametricPolarMesher.get_mesh(SampleSolid.new(), 0.01, 30)
	#_new_mesh.mesh = ParametricPolarMesher.get_mesh(FunnyCap.new(), 0.1, 15)
	#_new_mesh.mesh = ParametricPolarMesher.get_mesh(BezierLeg.new(), 0.01, 6)
	var time_end = Time.get_unix_time_from_system()
	print("Grib henerathion time: ", (time_end - time_beginning) * 1000.0, "ms")
	#_new_mesh.material_override = load("res://new_standard_material_3d.tres")
	#add_child(_new_mesh)
	

func _on_generate_and_save_button_pressed() -> void:
	#print(ResourceSaver.save(_new_mesh.mesh, "res://ParametricMeshing/saved/" + Time.get_datetime_string_from_system() + ".res"))
	#get_node("LastGribPreview").mesh = _new_mesh
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var cap = BezierStipe.new()
	#var model = cap.generate_mesh({"length": 5.0, "thickness": 0.2, "max incline": 1.0, "number of segments": 5}, 1)
	
	var cap = ExponentialCap.new()
	var model = cap.generate_mesh({"thickness": 0.4, "radius": 1.4, "exponent": 0.4, "height": 0.5}, 0)
	
	#var material = StripesMaterial.new()
	#model.material_override = material.generate_material({"base color": Color(0.2, 0.3, 0.1), "stripe color": Color(0.4, 0.7, 0.2), "number of stripes": 3, "blend": 0.3}, 0)
	
	var material = SpeclesMaterial.new()
	model.material_override = material.generate_material({"base color": Color(0.8, 0.05, 0.1), "specle color": Color(1.0, 0.95, 0.9), "number of specles": 12, "max specle diameter": 0.3, "min specle diameter": 0.05, "steepness": 0.7}, Time.get_ticks_msec())
	
	add_child(model)
	
	#marcher = CubeMarcher.new()
	#marcher.set_precision(Vector3(0.04,0.04,0.04))
	#marcher.set_SDF(specific_shroom.new(Vector3(0.19,0.4,0), 0.2, Vector2(1.77,1.63), Vector2(0.02,-0.3),Vector3(0.11,0,0), Vector3(0.24,0.22,0.0) ,Vector3(0.16,0.09,0.14),Vector4(0.1, 0.1, 0.1, 0.1), Vector3(0.05,0,0)))
	#marcher.set_SDF(Ball.new())
	##										    cap_pos	    cap_height  cap ratios		cap_propeties			leg pos			    leg mid				leg elip					leg_r 				leg_cap_offset	   	
	#marcher.set_SDF(specific_shroom.new(Vector3(0.0,0.8,0.0), 0.5, Vector2(0.9,0.8), Vector2(0.03,-0.2),Vector3(0,0,0), Vector3(0.0,0.3,0.0) ,Vector3(0.3,0.3,0.3),Vector4(0.2, 0.2, 0.2, 0.2), Vector3(0,0,0)))
	#marcher.set_SDF(Ball.new())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
