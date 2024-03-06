extends CharacterBody3D

@onready var camera_mount = $camera_mount
@onready var animation_player = $"visuals/Root Scene/AnimationPlayer"
#@onready var healthbar = $Healthbar

@onready var visuals = $visuals


var SPEED = 3.0

const JUMP_VELOCITY = 4.5
var walking_speed = 3.0
var running_speed = 5.0

var running = false
var health = 100


@export var sens_horizental = 0.5
@export var sens_vertical = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#healthbar.init_health(health)
	

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens_horizental))
		visuals.rotate_y(deg_to_rad(event.relative.x*sens_horizental))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*sens_vertical))

func _physics_process(delta):
	
	
	if Input.is_action_just_pressed("hit"):
		if animation_player.current_animation != "RedTeam_SwordsMen_Armature|Atack_TwoHandSwordsMen":
			animation_player.play("RedTeam_SwordsMen_Armature|Atack_TwoHandSwordsMen")
	
	
	if Input.is_action_pressed("run"):
		SPEED = running_speed
		running = true
	else:
		SPEED = walking_speed
		running = true
	
	
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	visuals.look_at(position + direction)
	if direction:
		if running:
				if animation_player.current_animation !="RedTeam_SwordsMen_Armature|Running_TwoHandSwordsMen":
					animation_player.play("RedTeam_SwordsMen_Armature|Running_TwoHandSwordsMen")
		
					
					visuals.look_at(position + direction)
			
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
			#if animation_player.current_animation != "RedTeam_SwordsMen_Armature|Running_TwoHandSwordsMen":
				#animation_player.play("RedTeam_SwordsMen_Armature|Running_TwoHandSwordsMen")
			
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	
