extends CharacterBody3D

const VITEZA_NORMALA = 5.0
const VITEZA_SPRINT = 8.0
const VITEZA_SARITURA = 4.5
const SENZITIVITATE = 0.003

const STAMINA_MAX = 100.0
const STAMINA_CONSUM_SPRINT = 20.0
const STAMINA_REGENERARE = 15.0

const FOV_NORMAL = 75.0
const FOV_SPRINT = 85.0
const FOV_TRANSITION_SPEED = 8.0

const BOBBING_AMPLITUDE = 0.03 
const BOBBING_FREQUENCY = 14.0 

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var stamina = STAMINA_MAX
var timp_bobbing = 0.0
var pozitie_initiala_camera = Vector3.ZERO

@onready var camera = $Camera3D
@onready var stamina_bar = get_node("/root/Main/HUD/ProgressBar") 

@export var sunete_pasi: Array[AudioStream] # Aici vei trage cele 5 fișiere .ogg în Inspector
@onready var audio_pasi = $SunetPasi

var prag_pas = 0.0 # Monitorizează ciclul de mers pentru sunet

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if camera:
		pozitie_initiala_camera = camera.position
		camera.fov = FOV_NORMAL
		
	if stamina_bar:
		stamina_bar.max_value = STAMINA_MAX
		stamina_bar.value = stamina

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * SENZITIVITATE)
		if camera:
			camera.rotate_x(-event.relative.y * SENZITIVITATE)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = VITEZA_SARITURA
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	proceseaza_miscare(delta)
	actualizeaza_stamina(delta)
	actualizeaza_camera(delta)
	
	move_and_slide()

func proceseaza_miscare(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# AM MODIFICAT AICI: "sprint"
	var este_sprint = Input.is_action_pressed("sprint") and stamina > 0 and is_on_floor() and input_dir != Vector2.ZERO
	var viteza_actuala = VITEZA_SPRINT if este_sprint else VITEZA_NORMALA
	
	if direction:
		velocity.x = direction.x * viteza_actuala
		velocity.z = direction.z * viteza_actuala
	else:
		velocity.x = move_toward(velocity.x, 0, viteza_actuala)
		velocity.z = move_toward(velocity.z, 0, viteza_actuala)

func actualizeaza_stamina(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# AM MODIFICAT AICI: "sprint"
	if Input.is_action_pressed("sprint") and is_on_floor() and input_dir != Vector2.ZERO and stamina > 0:
		stamina -= STAMINA_CONSUM_SPRINT * delta
	else:
		stamina += STAMINA_REGENERARE * delta
	
	stamina = clamp(stamina, 0, STAMINA_MAX)
	
	if stamina_bar:
		stamina_bar.value = stamina

func actualizeaza_camera(delta):
	if not camera:
		return
	
	var target_fov = FOV_NORMAL
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	if Input.is_action_pressed("sprint") and stamina > 0 and input_dir != Vector2.ZERO and is_on_floor():
		target_fov = FOV_SPRINT
	
	camera.fov = lerp(camera.fov, target_fov, FOV_TRANSITION_SPEED * delta)
	
	if is_on_floor() and velocity.length() > 0.5:
		var viteza_bobbing = BOBBING_FREQUENCY * (velocity.length() / VITEZA_NORMALA)
		timp_bobbing += delta * viteza_bobbing

		var valoare_sin = sin(timp_bobbing)
		if prag_pas > 0 and valoare_sin <= 0:
			redau_sunet_pas_aleatoriu()
		prag_pas = valoare_sin
		
		var bobbing_offset = Vector3(
			cos(timp_bobbing * 2.0) * BOBBING_AMPLITUDE * 0.5,
			abs(sin(timp_bobbing)) * BOBBING_AMPLITUDE,
			0
		)
		camera.position = pozitie_initiala_camera + bobbing_offset
	else:
		timp_bobbing = 0
		prag_pas = 0
		camera.position = lerp(camera.position, pozitie_initiala_camera, delta * 10.0)

func redau_sunet_pas_aleatoriu():
	if sunete_pasi.size() > 0:
		var index_aleator = randi() % sunete_pasi.size()
		audio_pasi.stream = sunete_pasi[index_aleator]
		
		audio_pasi.pitch_scale = randf_range(0.9, 1.1)
		
		audio_pasi.play()
