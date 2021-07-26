tool
extends TextButton
class_name ModeButton

export (Array, Texture) var textures : Array

func _pressed() -> void:
    $Tween.stop_all()

func set_mode(_mode : int) -> void:
    .set_mode(_mode)
    set_texture(textures[_mode])
    set_text(("Dark" if _mode == 0 else "Light") + " Mode")

func _released() -> void:
    get_tree().call_group("supabase_components", "set_mode", !mode) 
