extends Polygon2D

const DEGREE_60 = PI / 3
const DEGREE_120 = 2 * DEGREE_60
const DEGREE_240 = 4 * DEGREE_60
const DEGREE_300 = 5 * DEGREE_60

var coord_A = null
var coord_B = null
var coord_C = null
var coord_D = null
var coord_E = null
var coord_F = null

var central_coord = null
var radius = null
var base_color = Color.blue

func _draw():
	central_coord = Vector2(150, 150)
	
	draw_hexagon(central_coord, 50, base_color)
	
func draw_hexagon(central_coord, radius, color):
	coord_A = Vector2(central_coord.x + radius, central_coord.y)
	coord_B = Vector2(central_coord.x + radius * cos(DEGREE_60), central_coord.y + radius * sin(DEGREE_60))
	coord_C = Vector2(central_coord.x + radius * cos(DEGREE_120), central_coord.y + radius * sin(DEGREE_120))
	coord_D = Vector2(central_coord.x - radius, central_coord.y)
	coord_E = Vector2(central_coord.x + radius * cos(DEGREE_300), central_coord.y + radius * sin(DEGREE_300))
	coord_F = Vector2(central_coord.x + radius * cos(DEGREE_240), central_coord.y + radius * sin(DEGREE_240))
	
	draw_polygon_simplified(get_hexagon_points(), color)
	
func get_hexagon_points():
	return PoolVector2Array([coord_D, coord_C, coord_B, coord_A, coord_E, coord_F])

func draw_polygon_simplified(coordinates, color):
	draw_colored_polygon(coordinates, color, coordinates, null, null, false)
