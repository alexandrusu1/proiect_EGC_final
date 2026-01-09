extends Area3D

@onready var jurnal_ui = get_node("/root/Main/HUD/JurnalOverlay")
@onready var text_plutitor = $Label3D 

var jucator_in_zona = false
var este_deschis = false

func _ready():

	if text_plutitor: text_plutitor.visible = false
	if jurnal_ui: jurnal_ui.visible = false

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		jucator_in_zona = true
		if text_plutitor: text_plutitor.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		jucator_in_zona = false
		if text_plutitor: text_plutitor.visible = false
		inchide_jurnal()

func _input(event):
	if jucator_in_zona and Input.is_action_just_pressed("interact"):
		if este_deschis:
			inchide_jurnal()
		else:
			deschide_jurnal()

func deschide_jurnal():
	if jurnal_ui:
		jurnal_ui.visible = true
		este_deschis = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func inchide_jurnal():
	if jurnal_ui:
		jurnal_ui.visible = false
		este_deschis = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
