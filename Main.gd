extends Node2D

const BATTLEFIELD_SCENE_PATH = "res://Battlefield.tscn"
onready var first_scene = $"WelcomeScreen"

# Called when the node enters the scene tree for the first time.
func _ready():
	first_scene.connect("change_scene", self, "handle_scene_change")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func handle_scene_change():
	first_scene.queue_free()
	
	var battlefield_scene = load(BATTLEFIELD_SCENE_PATH).instance()
	add_child(battlefield_scene)
	
	transfer_data_between_scenes(first_scene, battlefield_scene)
	battlefield_scene.set_start_label()
	
func transfer_data_between_scenes(old_scene, new_scene):
	new_scene.parameters = old_scene.parameters
