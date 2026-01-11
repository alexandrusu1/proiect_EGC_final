extends CharacterBody3D

@export var viteza_patrulare: float = 4
@export var viteza_urmarire: float = 2.0  
@export var viteza_urmarire_maxima: float = 7.2 
@export var raza_detectie: float = 15.0
@export var raza_scapare: float = 20
@export var distanta_atac: float = 1.5
@export var imagine_alerta: TextureRect
@export var jumpscare_screen: CanvasLayer 

@onready var sunet_idle = $SunetIdle
@onready var sunet_urmarire = $SunetUrmarire
@onready var sunet_jumpscare = $SunetJumpscare

var numar_greseli: int = 0
var player: Node3D = null
var gravitatie = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_game_over = false

enum { PATRULA, URMARIRE }
var stare_curenta = PATRULA

var directie_patrulare = Vector3.ZERO
var timp_schimbare_directie = 0.0

func _ready():
	add_to_group("Inamic") 
	player = get_tree().get_first_node_in_group("Player")
	if not player:
		player = get_node_or_null("/root/Main/Player")
	if jumpscare_screen: 
		jumpscare_screen.visible = false
	var model = get_node_or_null("Running")
	if model: model.rotation_degrees.y = 180
	var anim = find_child("AnimationPlayer", true, false)
	if anim: 
		var l = anim.get_animation_list()
		if l.size() > 0: anim.play(l[0])

func _physics_process(delta):
	if is_game_over or GameManager.joc_finalizat: 
		velocity = Vector3.ZERO
		sunet_urmarire.stop()
		return
	if not is_on_floor():
		velocity.y -= gravitatie * delta

	if player:
		var distanta = global_position.distance_to(player.global_position)
		match stare_curenta:
			PATRULA:
				comportament_patrulare(delta)
				if imagine_alerta: imagine_alerta.visible = false
				if distanta < raza_detectie:
					stare_curenta = URMARIRE
					if not sunet_urmarire.playing: sunet_urmarire.play()
					sunet_idle.stop()
			URMARIRE:
				comportament_urmarire(distanta)
				if imagine_alerta:
					imagine_alerta.visible = true
					imagine_alerta.modulate.a = 0.5 + abs(sin(Time.get_ticks_msec() * 0.005)) * 0.5
				if distanta > raza_scapare:
					stare_curenta = PATRULA
					sunet_urmarire.stop()
	move_and_slide()

func creste_dificultatea():
	numar_greseli += 1
	
	var noua_viteza = 2.0 + (numar_greseli * 0.65)
	viteza_urmarire = clamp(noua_viteza, 2.0, viteza_urmarire_maxima)
	
	sunet_urmarire.pitch_scale = 1.0 + (numar_greseli * 0.05)
	print("Viteza inamicului a crescut la: ", viteza_urmarire)

func comportament_patrulare(delta):
	timp_schimbare_directie -= delta
	if timp_schimbare_directie <= 0 or is_on_wall():
		schimba_directia_random()
	velocity.x = directie_patrulare.x * viteza_patrulare
	velocity.z = directie_patrulare.z * viteza_patrulare
	if velocity.length() > 0.1:
		rotire_lina(global_position + velocity, delta * 2.0)
	var timp_urmator_sunet_idle = 5.0 # Resetare simplă
	if not sunet_idle.playing and stare_curenta == PATRULA:			
		sunet_idle.play()

func schimba_directia_random():
	var unghi = randf_range(-PI, PI)
	directie_patrulare = Vector3(sin(unghi), 0, cos(unghi)).normalized()
	timp_schimbare_directie = randf_range(2.0, 5.0)

func comportament_urmarire(distanta):
	if distanta < distanta_atac:
		game_over()
		return
	var dir = (player.global_position - global_position).normalized()
	velocity.x = dir.x * viteza_urmarire
	velocity.z = dir.z * viteza_urmarire
	rotire_lina(player.global_position, 0.1)

func rotire_lina(tinta, viteza_rot):
	var look_target = tinta
	look_target.y = global_position.y
	look_at(look_target, Vector3.UP)

func game_over():
	if is_game_over or GameManager.joc_finalizat: return
	is_game_over = true
	velocity = Vector3.ZERO
	sunet_idle.stop()
	sunet_urmarire.stop()
	if jumpscare_screen:
		jumpscare_screen.visible = true
		sunet_jumpscare.play()
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
	
func vine_la_jucator():
	if player:
		
		var directie = (global_position - player.global_position).normalized()
		global_position = player.global_position + directie * 10.0
		

		stare_curenta = URMARIRE
		if not sunet_urmarire.playing:
			sunet_urmarire.play()
		print("Inamicul a simțit greșeala și s-a apropiat!")
