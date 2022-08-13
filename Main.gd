extends Node2D

const BATTLEFIELD_SCENE_PATH = "res://Battlefield.tscn"
onready var welcome_screen_scene = $"WelcomeScreen"

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_fullscreen = true
	welcome_screen_scene.connect("change_from_welcome_screen", self, "change_scene_to_battlefield")

func change_scene_to_battlefield():
	welcome_screen_scene.queue_free()
	
	var battlefield_scene = preload(BATTLEFIELD_SCENE_PATH).instance()
	add_child(battlefield_scene)
	
	battlefield_scene.set_start_label()
