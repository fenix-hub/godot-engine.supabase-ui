tool
extends DefaultButton
class_name SLinkButton

func _load_defaults():
    property_list[0]["class_name"] = "LinkButton"
    property_list[0]["name"] = "LinkButton"

    colors.text = [Color("#24b47e"), Color("#24b47e")]
    colors.text_hover = [Color("#24b47e"), Color("#24b47e")]
    colors.button = [Color.transparent, Color.transparent]
    colors.button_hover =  [Color("#2824b47e"), Color("#2824b47e")]
    colors.border = [Color.transparent, Color.transparent]
    colors.shadow_size = [0,0]
    
    text = "Link Button"
