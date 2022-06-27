extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var shape = ConvexPolygonShape2D.new()
	shape.set_point_cloud(PoolVector2Array([
		.get_parent().coord_D,
		.get_parent().coord_C,
		.get_parent().coord_B,
		.get_parent().coord_A,
		.get_parent().coord_E,
		.get_parent().coord_F
		]))

	var collision = CollisionShape2D.new()
	collision.set_shape(shape)

	add_child(collision)

#func _input_event(viewport, event, shape_idx):
	#if event.type == InputEvent.MOUSE_BUTTON \
	#and event.button_index == BUTTON_LEFT \
	#and event.pressed:
		#print("Clicked")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if  event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == BUTTON_LEFT:
		if .get_parent().base_color == Color.blue:
			.get_parent().color = Color.red
		else: 
			.get_parent().color = Color.blue

func _on_Tile_mouse_entered():
	print("Clicked --------------")
