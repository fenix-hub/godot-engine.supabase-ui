tool
extends PanelContainer
class_name SInput

signal pressed()
signal released()
signal hover()

export (int, "Light Mode", "Dark Mode") var mode : int = 0 setget set_mode

var colors : Dictionary = {
    "text" : [Color("#414141"), Color.white],
    "input_name" : [Color("#1f1f1f"), Color("#E0E0E0")],
    "optional_name" : [Color("#666666"), Color("#BBBBBB")],
    "description" : [Color("#666666"), Color("#BBBBBB")],

    "panel" : [Color.white, Color("#2a2a2a")],
    "shadow" : [Color.transparent, Color.transparent],
    "shadow_hover" : [Color("#7755eab2"), Color("#7755eab2")],
    "border" : [Color("#cccccc"), Color("#cccccc")],
    "border_hover" : [Color("#24b47e"), Color("#24b47e")],
    "shadow_size" : [0, 0],
    "shadow_size_hover" : [3, 3]
   }

var font_size : int = 15                        setget set_font_size       

var icon_enabled : bool = false                 setget enable_icon
var texture : Texture = null                    setget set_texture
var size : Vector2 = Vector2(24, 24)            setget _set_size

var text : String = ""                          setget set_text
var placeholder : String = ""                   setget set_placeholder
var input_name : String = "Input Name"          setget set_input_name
var optional_name : String = ""    setget set_optional_name
var description : String = "Description"        setget set_description
var show_description : bool = false             setget set_show_description

var pressing : bool = false
var secret : bool = false                       setget set_secret

var property_list : Array = [
    {
        "class_name": "SInput",
        "hint": PROPERTY_HINT_NONE,
        "usage": PROPERTY_USAGE_CATEGORY,
        "name": "SInput",
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
        "name": "placeholder",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "secret",
        "type": TYPE_BOOL
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "input_name",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "optional_name",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "show_description",
        "type": TYPE_BOOL
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "description",
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



func _load_defaults():
    pass

func _connect_signals():
    $Container/InputContainer/Box/Text.connect("focus_entered", self, "_on_focus_entered")
    $Container/InputContainer/Box/Text.connect("focus_exited", self, "_on_focus_exited")

func _ready():
    _connect_signals()
    _load_defaults()
    set_mode(mode)
    set_texture(texture)
    set_text(text)
    set_show_description(false)
    _set_size(size)

    add_to_group("supabase_components")

func set_texture(_texture : Texture) -> void:
    texture = _texture
    if has_node("Container/InputContainer/Box/Icon"):
        get_node("Container/InputContainer/Box/Icon").set_texture(texture)

func _set_size(_size : Vector2):
    size = _size
    if has_node("Container/InputContainer/Box/Icon"):
        get_node("Container/InputContainer/Box/Icon").rect_min_size = size

func set_text(_text : String) -> void:
    text = _text
    if has_node("Container/InputContainer/Box/Text"):
        get_node("Container/InputContainer/Box/Text").set_text(_text)

func set_placeholder(_text : String) -> void:
    placeholder = _text
    if has_node("Container/InputContainer/Box/Text"):
        get_node("Container/InputContainer/Box/Text").set_placeholder(_text)

func get_text() -> String:
    return $Container/InputContainer/Box/Text.get_text()

func set_input_name(_text : String) -> void:
    input_name = _text
    if has_node("Container/Top/Name"):
        get_node("Container/Top/Name").set_text(_text)

func set_optional_name(_text : String) -> void:
    optional_name = _text
    if has_node("Container/Top/Optional"):
        get_node("Container/Top/Optional").set_text(_text)

func set_description(_text : String) -> void:
    description = _text
    if has_node("Container/Description"):
        get_node("Container/Description").set_text(_text)


func set_text_color(_color : Color) -> void:
    if has_node("Container/InputContainer/Box"):
        get_node("Container/InputContainer/Box").modulate = _color

func set_name_color(_color : Color) -> void:
    $Container/Top/Name.modulate = _color

func set_description_color(_color : Color) -> void:
    if has_node("Container/Description"):
        get_node("Container/Description").modulate = _color
    if has_node("Container/Top/Optional"):
        get_node("Container/Top/Optional").modulate = _color

func get_description_color() -> Color:
    if has_node("Container/Description"):
        return get_node("Container/Description").modulate
    else:
        return colors.description[mode]  

func enable_icon(enabled : bool) -> void:
    icon_enabled = enabled
    if has_node("Container/InputContainer/Box/Icon"):
        get_node("Container/InputContainer/Box/Icon").show() if enabled else hide_icon()

func set_mode(_mode : int) -> void:
    mode = _mode
    set_text_color(colors.text[mode])
    set_name_color(colors.input_name[mode])
    set_description_color(colors.description[mode])
    set_panel_color(colors.panel[mode])
    set_border(colors.border[mode])
    set_shadow_size(colors.shadow_size[mode])
    set_shadow_color(colors.shadow[mode])

func set_panel_color(_color : Color) -> void:
    $Container/InputContainer.get("custom_styles/panel").set("bg_color", _color)

func set_border(_color : Color) -> void:
    $Container/InputContainer.get("custom_styles/panel").set("border_color", _color)

func get_border() -> Color:
    return $Container/InputContainer.get("custom_styles/panel").get("border_color")

func set_shadow_color(_color : Color) -> void:
    $Container/InputContainer.get("custom_styles/panel").set("shadow_color", _color)

func get_shadow_color() -> Color:
    return $Container/InputContainer.get("custom_styles/panel").get("shadow_color")

func set_shadow_size(_size : int) -> void:
    $Container/InputContainer.get("custom_styles/panel").set("shadow_size", _size)

func get_shadow_size() -> int:
    return $Container/InputContainer.get("custom_styles/panel").get("shadow_size")
    

func set_font_size(_size : int) -> void:
    font_size = _size
    get("theme").get("default_font").set("size", _size)
    if has_node("Container/Top/Name"):
        get_node("Container/Top/Name").get("custom_fonts/font").set("size", _size)

func hide_icon():
    get_node("Container/InputContainer/Box/Icon").hide()

func set_show_description(_value : bool):
    show_description = _value
    if has_node("Container/Description"): get_node("Container/Description").visible = _value

func _on_focus_entered():
    $Tween.interpolate_method(self, "set_shadow_size", get_shadow_size(), colors.shadow_size_hover[mode], 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.interpolate_method(self, "set_shadow_color", get_shadow_color(), colors.shadow_hover[mode], 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.interpolate_method(self, "set_border", get_border(), colors.border_hover[mode], 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.start()

func _on_focus_exited():
    $Tween.interpolate_method(self, "set_shadow_size", get_shadow_size(), colors.shadow_size[mode], 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.interpolate_method(self, "set_shadow_size", get_shadow_color(), colors.shadow[mode], 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.interpolate_method(self, "set_border", get_border(), colors.border[mode], 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.start()    


func set_secret(_secret : bool) -> void:
    secret = _secret
    if has_node("Container/InputContainer/Box/Text"): get_node("Container/InputContainer/Box/Text").secret = _secret
