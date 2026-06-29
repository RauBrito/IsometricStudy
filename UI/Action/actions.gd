extends Control
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var move_btn: Button = $Ctn/MoveBtn
@onready var attack_btn: Button = $Ctn/AttackBtn
@onready var skills_btn: Button = $Ctn/SkillsBtn
@onready var end_turn_btn: Button = $Ctn/EndTurnBtn
@onready var ctn: VBoxContainer = $Ctn

@onready var selection_box: CharacterBody2D = $"../Selection Box"
const increment = Vector2(0,21)
var option_selected = 1


func handle_menu_movement(event):
	if event.is_action_pressed("up"): 
		if option_selected > 1:
			option_selected -= 1
			animated_sprite_2d.position -= increment
	if event.is_action_pressed("down"): 
		if option_selected < 4:
			option_selected += 1
			animated_sprite_2d.position += increment


func open():
	visible = true
	btn_focus()

func close():
	visible = false

func _input(event):
	if !MenuStatus.menu_movement:
		if event.is_action_pressed("deselection"):
			close()
			MenuStatus.enable_sb() 
		else:
			pass
			#handle_menu_movement(event)


func movement():
	var character = selection_box.selected_body
	character.show_movement()
	visible = false

func attack():
	pass

func skills():
	pass

func end_turn():
	pass

func _ready():
	btn_focus()

func btn_focus():
	move_btn.grab_focus()


#SIGNALS
func _on_move_btn_pressed() -> void:
	print("_on_move_btn_pressed")
	movement()
	pass # Replace with function body.


func _on_move_btn_focus_entered() -> void:
	animated_sprite_2d.position = move_btn.position + Vector2(0,10)


func _on_attack_btn_pressed() -> void:
	print("_on_attack_btn_pressed")


func _on_attack_btn_focus_entered() -> void:
	animated_sprite_2d.position = attack_btn.position + Vector2(0,10)


func _on_skills_btn_pressed() -> void:
	print("_on_skills_btn_pressed")


func _on_skills_btn_focus_entered() -> void:
	animated_sprite_2d.position = skills_btn.position + Vector2(0,10)


func _on_end_turn_btn_pressed() -> void:
	print("_on_end_turn_btn_pressed")


func _on_end_turn_btn_focus_entered() -> void:
	animated_sprite_2d.position = end_turn_btn.position + Vector2(0,10)
