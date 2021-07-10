tool
extends PanelContainer
class_name DefaultButton

signal pressed()
signal released()
signal hover()

export (int, "Light Mode", "Dark Mode") var mode : int = 0 setget set_mode

var colors : Dictionary = {
    "text" : [Color("#414141"), Color.white],
    "text_hover" : [Color("#414141"), Color.white],
    "icon" : [Color("#414141"), Color.white ],
    "button" : [Color.white, Color("#2a2a2a")],
    "button_hover" : [Color.white, Color("#181818")],
    "border" : [Color("#cccccc"), Color("#2a2a2a")],
    "border_hover" : [Color("#cccccc"), Color("#2a2a2a")],
    "shadow_size" : [1.5, 0]
   }

var font_size : int = 15 setget set_font_size

var icon_enabled : bool = false setget enable_icon
var texture : Texture = null setget set_texture
var expand : bool = false setget set_expand
var size : Vector2 = Vector2(32, 32) setget _set_size
var text : String = "Default Button" setget set_text

var pressing : bool = false

var property_list : Array = [
    {
        "class_name": "DefaultButton",
        "hint": PROPERTY_HINT_NONE,
        "usage": PROPERTY_USAGE_CATEGORY,
        "name": "DefaultButton",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_GROUP,
        "name": "Icon",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "icon_enabled",
        "type": TYPE_BOOL          
    },
    {
        "hint": PROPERTY_HINT_RESOURCE_TYPE,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "texture",
        "hint_string": "Texture",
        "type": TYPE_OBJECT
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "expand",
        "type": TYPE_BOOL
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "size",
        "type": TYPE_VECTOR2
    },
    {
        "usage": PROPERTY_USAGE_GROUP,
        "name": "Contents",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "text",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "font_size",
        "type": TYPE_INT
    }
]


func _get_property_list():
    return property_list

func _set(property, value):
    match property:
        "texture": 
            set_texture(value)
            return true
        "expand": 
            set_expand(value)
            return true
        "size": 
            _set_size(value)
            return true
        "icon_enabled":
            enable_icon(value)
            return true
        "text": 
            set_text(value)
            return true
        "font_size":
            set_font_size(value)
            return true

func _load_defaults():
    pass

func _connect_signals():
    connect("mouse_entered", self, "_on_mouse_entered")
    connect("mouse_exited", self, "_on_mouse_exited")

func _init():
    _load_defaults()

func _ready():
    _connect_signals()
    set_mode(mode)
    set_texture(texture)
    set_text(text)
    _set_size(size)
    
    add_to_group("supabase_components")

func set_texture(_texture : Texture) -> void:
    texture = _texture
    if has_node("ButtonContainer/Icon"):
        get_node("ButtonContainer/Icon").set_texture(texture)


func set_expand(_expand : bool):
    expand = _expand
    if has_node("ButtonContainer/Icon"):
        get_node("ButtonContainer/Icon").expand = expand

func _set_size(_size : Vector2):
    size = _size
    if has_node("ButtonContainer/Icon"):
        get_node("ButtonContainer/Icon").rect_min_size = size

func set_text(_text : String) -> void:
    text = _text
    if has_node("ButtonContainer/Text"):
        get_node("ButtonContainer/Text").set_text(text)


func set_text_color(_color : Color) -> void:
    if has_node("ButtonContainer"):
        get_node("ButtonContainer").modulate = _color

func get_text_color() -> Color:
    if has_node("ButtonContainer/Text"):
        return get_node("ButtonContainer").modulate
    else:
        return colors.text[mode]    

func enable_icon(enabled : bool) -> void:
    icon_enabled = enabled
    if has_node("ButtonContainer/Icon"):
        get_node("ButtonContainer/Icon").show() if enabled else hide_icon()

func set_mode(_mode : int) -> void:
    mode = _mode
    set_text_color(colors.text[mode])
    set_button_color(colors.button[mode])
    set_button_border(colors.border[mode])
    set_button_shadow(colors.shadow_size[mode])

func get_button_color() -> Color:
    return get("custom_styles/panel").get("bg_color")

func set_button_color(_color : Color) -> void:
    get("custom_styles/panel").set("bg_color", _color)

func get_button_border() -> Color:
    return get("custom_styles/panel").get("border_color")

func set_button_border(_color : Color) -> void:
    get("custom_styles/panel").set("border_color", _color)

func set_button_shadow(_size : int) -> void:
    get("custom_styles/panel").set("shadow_size", _size)

func set_font_size(_size : int) -> void:
    font_size = _size
    if has_node("ButtonContainer/Text"):
        get_node("ButtonContainer/Text").get("custom_fonts/font").set("size", _size)

func _gui_input(event : InputEvent):
    if event is InputEventMouseButton:
        if event.pressed:
            pressing = true
            _pressed()
            emit_signal("pressed")
        else:
            pressing = false
            _released()
            emit_signal("released")

func _pressed() -> void:
    pass

func _released() -> void:
    pass 

func hide_icon():
    get_node("ButtonContainer/Icon").hide()
    rect_size = Vector2.ZERO

func _hover_after():
    pass

func _hover_before():
    pass

func hover_after():
    _hover_after()
    $Tween.interpolate_method(self, "set_button_color", get_button_color(), colors.button_hover[mode], 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.interpolate_method(self, "set_button_border", get_button_border(), colors.border_hover[mode], 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.interpolate_method(self, "set_text_color", get_text_color(), colors.text_hover[mode], 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.start()


func hover_before():
    _hover_before()
    $Tween.interpolate_method(self, "set_button_color", get_button_color(), colors.button[mode], 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.interpolate_method(self, "set_button_border", get_button_border(), colors.border[mode], 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.interpolate_method(self, "set_text_color", get_text_color(), colors.text[mode], 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.start()


func _on_mouse_entered():
    emit_signal("hover")
    hover_after()    

func _on_mouse_exited():
    hover_before()
