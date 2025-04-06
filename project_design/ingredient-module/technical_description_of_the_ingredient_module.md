# Ingredient Generation Structure

This document describes the structure and process of ingredient generation. __Beware__ the .jpg file that shows this structure is obsolete!

## Components of Ingredient Generation

### MeshComponent
- **Description**: Class for generating a mesh of a part of a mushroom or its whole body. The mesh is divided into parts so different materials can be applied afterwards.
- **Methods**:
  - `generate_mesh(parameters: Dictionary, seed: int) -> Mesh`
    - **parameters**: A dictionary of parameters specific to the mesh component.
    - **seed**: Seed for random generation. If not provided, a random seed should be generated and a warning prompted.

### MaterialComponent
- **Description**: Class for procedurally generating a material, including texture, height map, and normal map.
- **Methods**:
  - `generate_material(parameters: Dictionary, seed: int) -> Material`
    - **parameters**: A dictionary of parameters specific to the material component.
    - **seed**: Seed for random generation. If not provided, a random seed should be generated and a warning prompted.

### ComponentConnector (Interface)
- **Description**: Interface for connecting `MeshComponent` and `MaterialComponent` to generate a model. Each class inheriting from this interface will decide which components to use.
- **Methods**:
  - `generate_model(parameters: ComponentConnectorParameters, seed: int) -> MeshInstance3D`
    - **parameters**: An instance of `ComponentConnectorParameters` for model generation.
    - **seed**: Seed for random generation.

### ComponentConnectorDistribution
- **Description**: Class that encapsulates all the parameter distributions for `ComponentConnector`.
- **Methods**:
  - `generate_parameters(seed: int) -> ComponentConnectorParameters`
    - Generates and returns an instance of `ComponentConnectorParameters` based on the seed.

### ComponentConnectorParameters
- **Description**: Class that encapsulates all the parameters for `ComponentConnector`.
- **Methods**:
  - `get_parameters() -> Dictionary`
    - Returns a dictionary of parameters.

### IngredientFamily
- **Description**: Interface for the procedural generation of ingredient species. This allows for the generation of species of mushrooms or other ingredients based on a seed.
- **Methods**:
  - `generate_species(seed: int) -> IngredientSpecies`
  - `get_probability_weight() -> float`

### FamilyRandomizer
- **Description**: Class (potentially static in Godot) that aggregates all ingredient families and provides the functionality of selecting one at random based on their probability weights and generating a species of that family based on a seed.
- **Methods**:
  - `generate_random_species(seed: int) -> IngredientSpecies`

### IngredientSpecies
- **Description**: Class representing a species of ingredients. It provides the functionality of generating a mushroom based on a seed and contains distributions of alchemical properties.
- **Methods**:
  - `generate_specimen(seed: int) -> IngredientSpecimen`

### IngredientSpecimen
- **Description**: Class containing a reference to `ComponentConnector`, specific parameters, and a seed to generate its mesh and alchemical properties. This class should inherit from the Item interface.
- **Methods**:
  - `generate_mesh_and_properties()`
