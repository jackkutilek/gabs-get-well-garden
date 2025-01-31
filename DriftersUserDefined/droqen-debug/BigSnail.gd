extends Drifter

onready var ttl = rand_range(5,10+1)

func _ready():
	scale = Vector2(1,0)
	target_scale = Vector2(0.9, 1.1)

func _physics_process(_delta):
	position = lerp(position, target_position, 0.05)
	if dead: scale = lerp(scale, Vector2.ZERO, 0.02)
	else:    scale = lerp(scale, target_scale, 0.02)

	if randf()*50<1:
		scale = Vector2(1.1,0.9)

	if evolve_wait_frames > 0: evolve_wait_frames -= 1

func evolve():
	tweak()

func tweak():
	ttl -= 1
	if ttl <= 0:
		world.log("a snail moves on")
		intend_transmute("res://DriftersUserDefined/droqen-debug/PoisonousGround.tscn")
	else:
		# move, leaving posion behind
		
		var dir = DirsOrthogonal[randi()%4]
		scale = Vector2(1.2, 0.8)
		if dir.x: $Sprite.flip_h = dir.x<0

		intend_move_and_leave(dir,"res://DriftersUserDefined/droqen-debug/PoisonousGround.tscn")
