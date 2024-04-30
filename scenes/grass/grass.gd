extends Node2D

@export var enabled := true
@export var max_lifetime := 1
@export var base_color: Color = Color(39 / 255.0, 149 / 255.0, 41 / 255.0)
@export var max_thickness := 5
@export var warping := 60
@export var grow_step := 0.007
@export var grow_speed := 100
@export var gravity := 0.1
@export var sharpe := 10

var paint_trace = []
var offset_x := 0.0
var offset_y := 0.0
var lifetime = max_lifetime
var angle := 0.0
var thickness = max_thickness


func _ready() -> void:
	grow()
	queue_redraw()


func grow():
	if !enabled:
		return
	angle = apply_gravity_warping(apply_random_warping(angle))
	offset_x += sin(deg_to_rad(angle)) * grow_speed * grow_step
	offset_y -= cos(deg_to_rad(angle)) * grow_speed * grow_step

	thickness = max(1, thickness - sharpe * grow_step)
	paint_trace.append(
		[
			ceil(offset_x - thickness / 2.0),
			ceil(offset_y - thickness / 2.0),
			ceil(thickness),
			ceil(thickness),
			base_color
		]
	)
	lifetime -= grow_step
	if lifetime <= 0:
		enabled = false
	grow()


func _draw() -> void:
	for draw_item in paint_trace:
		draw_rect(Rect2(draw_item[0], draw_item[1], draw_item[2], draw_item[3]), draw_item[4])


func normalize_angle(target_angle):
	return wrapf(target_angle, -180, 180)


func apply_random_warping(original_angle):
	return normalize_angle(original_angle + randi_range(-warping, warping) * grow_step)


func apply_gravity_warping(original_angle):
	return normalize_angle(original_angle + (180 - abs(angle)) * sign(angle) * gravity * grow_step)
