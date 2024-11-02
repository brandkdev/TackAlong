extends CharacterBody2D


@onready var rudder = $rudder
@onready var mainsail = $mainsail
@onready var hull = $hull
@onready var mainsail_sprite = $mainsail/mainsail

const hull_speed = 50.0

var haul_rotation = 0
var haul_max = 90
var haul_min = -90
var rotation_dir = 0
var rotation_speed = 1.5
var mainsail_vector: Vector2
var sail_efficiency = 0.0
var forward_force = 0.0
var main_sheet = 88
var mainsail_flipped = false
var forward_speed = 0.0
var acceleration = 0.0
var deceleration = 2.0

var sail_directions = [
	"N",
	"NE",
	"E",
	"SE",
	"S",
	"SW",
	"W",
	"NW",
]

var wind_speed: int
var wind_dir: Vector2

func _ready():
	pass
	
func get_input():
	if Input.is_action_pressed("rudder_L"):
		rudder.rotation_degrees = 105
		rotation_dir -= 1
	elif Input.is_action_pressed("rudder_R"):
		rudder.rotation_degrees = 75
		rotation_dir += 1
	else:
		rudder.rotation_degrees = 90
	
	if Input.is_action_pressed("haul_in"):
		main_sheet += 1
		main_sheet = clamp(main_sheet, 4, 88)
	elif Input.is_action_pressed("haul_out"):
		main_sheet -= 1
		main_sheet = clamp(main_sheet, 4, 88)
		
	if Input.is_action_just_pressed("check_dir"):
		var sail_angle = mainsail_vector.angle() * rad_to_deg(1)
		if sail_angle < 0:
			sail_angle += 360
		var sail_direction_index = int(round(sail_angle / 45)) % 8
		var sail_cardinal = sail_directions[sail_direction_index]
		print(sail_cardinal)
		print(sail_efficiency)
		print(mainsail.rotation_degrees)
		
		

func update_mainsail_rotation():
	
	var wind_angle = wind_dir.angle()
	var sail_angle = mainsail_vector.angle()
	var local_wind_dir = wind_dir.rotated(-global_rotation).normalized()
	var local_wind_angle = local_wind_dir.angle() - 1.57
	
	mainsail.rotation = lerp_angle(mainsail.rotation, local_wind_angle, 2.0)
	
	var sail_min_rotation = deg_to_rad(90 + main_sheet)
	var sail_max_rotation = deg_to_rad(270 - main_sheet)
	
	mainsail.rotation = lerp(mainsail.rotation, clamp(mainsail.rotation, sail_min_rotation, sail_max_rotation), 1.0)


func _physics_process(delta: float) -> void:
	get_input()
	rotation = rotation_dir * rotation_speed * delta
	
	# Vector pointing outwards along the boom of the ship (90 degrees from face of sail)
	mainsail_vector = Vector2(cos(mainsail.global_rotation + PI / 2), sin(mainsail.global_rotation + PI / 2))
	
	update_mainsail_rotation()
	
	if(mainsail.rotation_degrees > 180):
			mainsail_sprite.flip_v = true
			mainsail_flipped = true
	else:
		mainsail_sprite.flip_v = false
		mainsail_flipped = false
		
	var wind_vs_sail_angle = wind_dir.angle_to(mainsail_vector)
	
	sail_efficiency = cos(wind_vs_sail_angle -1.57)
	sail_efficiency = abs(sail_efficiency)
	
	forward_force = sail_efficiency * wind_speed
	acceleration = wind_speed / 2
	
	if sail_efficiency > 0.6:
		forward_speed = lerp(forward_speed, forward_force, acceleration * delta)
		forward_speed = clamp(forward_speed, 0.0, hull_speed)
	else:
		forward_speed = lerp(forward_speed, forward_force, deceleration * delta)
		forward_speed = clamp(forward_speed, 0.0, hull_speed)
	
	velocity = Vector2(forward_speed, 0)
	velocity = velocity.rotated(global_rotation)
	
	move_and_collide(velocity * delta)
