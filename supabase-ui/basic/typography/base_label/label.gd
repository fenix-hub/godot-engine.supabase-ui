tool
extends Label
class_name SLabel

export (int, "Light Mode", "Dark Mode") var mode : int = 0 setget set_mode

var colors : Dictionary = {
    "text" : [Color("#1F1F1F"), Color.white],
   }

var level : int = 5         setget set_level
var font_size : int = 15    setget set_font_size       

var property_list : Array = [
    {
        "class_name": "SLabel",
        "hint": PROPERTY_HINT_NONE,
        "usage": PROPERTY_USAGE_CATEGORY,
        "name": "SLabel",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_GROUP,
        "name": "Contents",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "level",
        "hint": PROPERTY_HINT_ENUM,
        "hint_string" : "1,2,3,4,5",
        "type": TYPE_INT
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

func _ready():
    _load_defaults()
    set_mode(mode)
    set_text("")
    set_level(4)

    add_to_group("supabase_components")

func set_text_color(_color : Color) -> void:
    set("custom_colors/font_color", _color)


func set_mode(_mode : int) -> void:
    mode = _mode
    set_text_color(colors.text[mode])

func set_font_size(_size : int) -> void:
    font_size = _size
    get("custom_fonts/font").set("size", _size)

func set_level(_level : int) -> void:
    level = _level
    match level:
        0: set_font_size(40)
        1: set_font_size(35)
        2: set_font_size(25)
        3: set_font_size(19)
        4: set_font_size(16)
