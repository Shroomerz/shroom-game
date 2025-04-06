extends MeshGenericTests

func before_all():
	model_script_path = "res://test/unit/ingredient_tests/ingredient_mesh_tests/Ball.gd"
	generate_model()

func test_verticies_lie_on_ball():
	for i in range(0, model.get_vertex_count()):
		assert_almost_eq(model.get_vertex(i).length(), 1.0, 0.000001)
