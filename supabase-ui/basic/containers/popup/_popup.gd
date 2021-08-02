tool
class_name SPopup
extends PopupPanel

signal pressed()

const colors : Dictionary = {
    "panel" : [Color.white, Color("#2a2a2a")]
   }

export (int, "Light Mode", "Dark Mode") var mode : int = 0 setget set_mode

func _ready():
    add_to_group("supabase_components")

func set_mode(_mode : int) :
    mode = _mode
    get("custom_styles/panel").set("bg_color", colors.panel[mode])

func _force_resize() :
    hide()
    show()


func _on_Panel_gui_input(event):
    if event is InputEventMouseButton:
        if event.get_button_index() == 1 and event.is_pressed():
            emit_signal("pressed")
