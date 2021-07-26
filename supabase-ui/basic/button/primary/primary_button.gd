tool
extends DefaultButton
class_name PrimaryButton

export var enable_loading : bool = false

onready var loading_texture := load("res://supabase-ui/res/icons/loader.svg")
var current_texture : Texture = null
var loading : bool = false


func start_loading():
    loading = true
    current_texture = texture
    set_expand(true)
    enable_icon(true)
    set_texture(loading_texture)
    $ButtonContainer/Icon.rect_pivot_offset = $ButtonContainer/Icon.rect_size/2
    set_process_internal(true)

func stop_loading() -> void:
    loading = false
    if not current_texture:
        enable_icon(false)
    set_texture(current_texture)
    set_process_internal(false)
    $ButtonContainer/Icon.rect_rotation = 0

func _notification(what : int) -> void:
    if what == NOTIFICATION_INTERNAL_PROCESS:
        _internal_process(get_process_delta_time())

func _internal_process(_delta : float) -> void:
    $ButtonContainer/Icon.rect_rotation += _delta*240

func _pressed():
    ._pressed()
    if enable_loading:
        if loading:
            stop_loading()
        else:
            start_loading()

func _load_defaults():
    property_list[0]["class_name"] = "PrimaryButton"
    property_list[0]["name"] = "PrimaryButton"

    colors.text =  [Color.white, Color.white]
    colors.text_hover =  [Color.white, Color.white]
    colors.icon =  [Color.white, Color.white]
    colors.button =  [Color("#24b47e"), Color("#24b47e")]
    colors.button_hover =  [Color("#4bd2a0"), Color("#198c61")]
    
    text = "Primary Button"
