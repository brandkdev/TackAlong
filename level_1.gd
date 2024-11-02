extends Node2D

var global_wind_direction
var global_wind_speed

var directions = [
	"N",
	"NE",
	"E",
	"SE",
	"S",
	"SW",
	"W",
	"NW",
]

@onready var player_boat = $Boat1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	global_wind_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	global_wind_speed = randi() % (100 - 10 + 1) + 10
	
	player_boat.wind_speed = global_wind_speed
	player_boat.wind_dir = global_wind_direction
	
	var angle = global_wind_direction.angle() * rad_to_deg(1)
	
	if angle < 0:
		angle += 360
	
	var direction_index = int(round(angle / 45)) % 8
	var wind_cardinal = directions[direction_index]
	
	print(wind_cardinal)
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
