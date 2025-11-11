class_name PlantData
extends Resource

enum PLANT_RESOURCE_TYPES {
    WATER,
    SUNLIGHT,
    NUTRIENTS,
    POLLEN,
    SHADE,
    FRAGRANCE
}


@export var plant_id: String
@export var plant_name: String
@export var provides: Array[PLANT_RESOURCE_TYPES] = []
@export var needs: Array[PLANT_RESOURCE_TYPES] = []