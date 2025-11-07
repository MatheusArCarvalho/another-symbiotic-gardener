extends Node

signal loading_progress_updated(percentage:float)
signal scene_loaded(scene:PackedScene)
#var LOADING_SCREEN
var loading_screen_instance:Node
var scene_path_to_load:String
var is_loading:bool


func load_scene(caller:Node, path:String) -> void:
	if is_loading:
		return
	scene_path_to_load = path
	is_loading = true
	#loading_screen_instance = LOADING_SCREEN.instantiate()
	get_tree().root.add_child(loading_screen_instance)
	ResourceLoader.load_threaded_request(scene_path_to_load)
	caller.queue_free()

func _process(_delta: float) -> void:
	if not is_loading:
		return
	
	var progress: Array = []
	var status = ResourceLoader.load_threaded_get_status(scene_path_to_load, progress)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			loading_progress_updated.emit(progress[0])
			
		ResourceLoader.THREAD_LOAD_LOADED:
			is_loading = false
			
			var loaded_scene:PackedScene = ResourceLoader.load_threaded_get(scene_path_to_load)
			
			loading_screen_instance.queue_free()
			#get_tree().root.add_child(loaded_scene.instantiate())
			scene_loaded.emit(loaded_scene)
			
			scene_path_to_load = ""

		ResourceLoader.THREAD_LOAD_FAILED:
			
			is_loading = false
			print("Failed to load scene: ", scene_path_to_load)
			# Here you can add logic to return to the main menu, for example.
			get_tree().quit()