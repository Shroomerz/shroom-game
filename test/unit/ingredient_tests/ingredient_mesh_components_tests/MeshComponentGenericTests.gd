extends GutTest
class_name MeshComponentGenericTests

var component_script_path
var component

var tested_seeds = [1623, 1526, 72346, 213678, 26378356854, 12612, 342, 63427, 232423, 4223]
var performance_test_seed_count = 3
var performance_test_seeds = []

func before_all():
	var script = load(component_script_path)
	component = script.new()
	performance_test_seeds = tested_seeds.slice(0, performance_test_seed_count)

## This function should be overridden when writing a test for a realization of the MeshComponent interface
func get_default_parameters() -> Dictionary:
	return {}

func test_generate_mesh():
	var parameters = get_default_parameters()
	for seed in tested_seeds:
		var mesh = component.generate_mesh(parameters, seed)
		assert_not_null(mesh.mesh)

func test_verticies_exist():
	var parameters = get_default_parameters()
	for seed in tested_seeds:
		var generated_mesh_instance :MeshInstance3D = component.generate_mesh(parameters, seed)
		assert_not_null(generated_mesh_instance.mesh, "The ComponentMesh must generate a mesh")
		if generated_mesh_instance.mesh != null:
			var mesh_instance :ArrayMesh = generated_mesh_instance.mesh
			if mesh_instance.get_surface_count() == 0:
				fail_test("MeshComponent returns an empty ArrayMesh object")
			else:
				for i in range(mesh_instance.get_surface_count() + 1):
					assert_gt(mesh_instance.surface_get_array_len(i), 0, "Surface " + mesh_instance.surface_get_name(i) + " is empty")

func test_meshes_are_identical():
	var parameters = get_default_parameters()
	for seed in tested_seeds:
		var mesh1 = component.generate_mesh(parameters, seed)
		var mesh2 = component.generate_mesh(parameters, seed)
		var mesh3 = component.generate_mesh(parameters, seed + 1)
		
		assert_not_null(mesh1.mesh, "Generated mesh may not be empty") 
		assert_not_null(mesh2.mesh, "Generated mesh may not be empty") 
		assert_not_null(mesh3.mesh, "Generated mesh may not be empty")
		if (mesh1.mesh == null or mesh2.mesh == null or mesh3.mesh == null):
			continue
		
		var model1 = MeshDataTool.new()
		model1.create_from_surface(mesh1.mesh, 0)
		var model2 = MeshDataTool.new()
		model2.create_from_surface(mesh2.mesh, 0)
		var model3 = MeshDataTool.new()
		model3.create_from_surface(mesh3.mesh, 0)
		
		# Check if mesh1 and mesh2 are identical
		assert_eq(model1.get_vertex_count(), model2.get_vertex_count(), "Vertex count mismatch for seed %d" % seed)
		for i in range(min(model1.get_vertex_count(), model2.get_vertex_count())):
			assert_eq(model1.get_vertex(i), model2.get_vertex(i), "Vertex mismatch at index %d for seed %d" % [i, seed])
		
		# Check if mesh1 and mesh3 are different
		if model1.get_vertex_count() == model3.get_vertex_count():
			var different = false
			for i in range(model1.get_vertex_count()):
				if model1.get_vertex(i) != model3.get_vertex(i):
					different = true
					break
			assert_true(different, "Meshes with different seeds should be different, but they are identical for seed %d and seed %d" % [seed, seed + 1])
		else:
			assert_true(true) # Different vertex count implies meshes are different

func test_performance():
	var parameters = get_default_parameters()
	for seed in performance_test_seeds:
		var start_time = Time.get_ticks_msec()
		component.generate_mesh(parameters, seed)
		var end_time = Time.get_ticks_msec()
		var elapsed_time = end_time - start_time
		assert_lt(elapsed_time, 100, "Mesh generation took too long for seed %d: %s ms" % [seed, elapsed_time])
