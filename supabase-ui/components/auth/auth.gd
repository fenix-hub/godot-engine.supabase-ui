tool
class_name SupabaseAuthPanel
extends PanelContainer

const colors : Dictionary = {
    "panel" : [Color.white, Color("#2a2a2a")]
   }

signal signed_in(user)
signal signed_up(user)
signal magic_link_send()
signal instructions_send()
signal error(error)

onready var sign_in_box : VBoxContainer = $Container/SignIn
onready var sign_up_box : VBoxContainer = $Container/SignUp
onready var forgot_password_box : VBoxContainer = $Container/ForgotPassword
onready var with_magic_link_box : VBoxContainer = $Container/WithMagicLink

onready var sign_in_error_lbl : SLabel = sign_in_box.get_node("ErrorLbl")
onready var sign_up_error_lbl : SLabel = sign_up_box.get_node("ErrorLbl")
onready var forgot_password_error_lbl : SLabel = forgot_password_box.get_node("ErrorLbl")
onready var magic_link_error_lbl : SLabel = with_magic_link_box.get_node("ErrorLbl")

export var app_name : String = "" setget set_app_name
export (int, "Light Mode", "Dark Mode") var mode : int = 0 setget set_mode

func _load_boxes():
    sign_in_box.show()
    sign_up_box.hide()
    forgot_password_box.hide()
    with_magic_link_box.hide()

func _ready():
    _load_boxes()

func set_app_name(_name : String) -> void:
    app_name = _name
    $Container/Label.set_text(app_name)

# =========== SIGN IN ==================
func _on_SignInBtn_pressed():
    var user_mail : String = $Container/SignIn/EmailAddress.get_text()
    var user_pwd : String = $Container/SignIn/Password.get_text()
    if user_mail == "" or user_pwd == "":
        show_sign_in_error("You must provide either an email/password combination or a third-party provider.")
        return
    sign_in_error_lbl.hide()
    var sign_in : AuthTask = yield(Supabase.auth.sign_in(user_mail, user_pwd), "completed")
    if sign_in.error:
        show_sign_in_error(str(sign_in.error))
        return
    emit_signal("signed_in", sign_in.user)
    $Container/SignIn/SignInBtn.stop_loading()

func show_sign_in_error(message : String) :
    sign_in_error_lbl.set_text(message)
    sign_in_error_lbl.show()
    emit_signal("error", message)
    $Container/SignIn/SignInBtn.stop_loading()


# =========== SIGN UP ==================
func _on_SignUpBtn_pressed():
    sign_up_error_lbl.hide()
    var user_mail : String = $Container/SignUp/EmailAddress.get_text()
    var user_pwd : String = $Container/SignUp/Password.get_text()
    if user_mail == "" or user_pwd == "":
        show_sign_up_error("You must provide either an email/password combination or a third-party provider.")
        return
    var sign_up : AuthTask = yield(Supabase.auth.sign_up(user_mail, user_pwd), "completed")
    if sign_up.error:
        show_sign_up_error(str(sign_up.error))
        return
    emit_signal("signed_up", sign_up.user)


func show_sign_up_error(message : String) :
    sign_up_error_lbl.set_text(message)
    sign_up_error_lbl.show()
    emit_signal("error", message)


# =========== FORGOT PASSWORD ==================
func _on_SendInstructionsBtn_pressed():
    forgot_password_error_lbl.hide()
    var user_mail : String = $Container/ForgotPassword/EmailAddress.get_text()
    if user_mail == "":
        show_forgot_password_error("You must provide a mail to send the link to.")
        return
    var forgot_pwd : AuthTask = yield(Supabase.auth.reset_password_for_email(user_mail), "completed")
    if forgot_pwd.error:
        show_forgot_password_error(str(forgot_pwd.error))
        return
    emit_signal("instructions_send")


func show_forgot_password_error(message : String) :
    forgot_password_error_lbl.set_text(message)
    forgot_password_error_lbl.show()
    emit_signal("error", message)

# =========== MAGIC LINK ==================
func _on_SendLinkBtn_pressed():
    magic_link_error_lbl.hide()
    var user_mail : String = $Container/WithMagicLink/EmailAddress.get_text()
    if user_mail == "":
        show_magic_link_error("You must provide a mail to send the link to.")
        return
    var magic_link : AuthTask = yield(Supabase.auth.send_magic_link(user_mail), "completed")
    if magic_link.error:
        show_magic_link_error(str(magic_link.error))
        return
    emit_signal("magic_link_send")


func show_magic_link_error(message : String) :
    magic_link_error_lbl.set_text(message)
    magic_link_error_lbl.show()
    emit_signal("error", message)


# ================================================

func _on_ForgotPassword_pressed():
    sign_in_box.hide()
    forgot_password_box.show()


func _on_MagicLink_pressed():
    sign_in_box.hide()
    with_magic_link_box.show()


func _on_SignUp_pressed():
    sign_in_box.hide()
    sign_up_box.show()


func _on_SignIn_pressed():
    sign_in_box.show()
    sign_up_box.hide()


func _on_BackToSignIn_pressed():
    sign_in_box.show()
    forgot_password_box.hide()


func _on_SignWithPassword_pressed():
    sign_in_box.show()
    with_magic_link_box.hide()

func set_mode(_mode : int) :
    mode = _mode
    get("custom_styles/panel").set("bg_color", colors.panel[mode])
    get_tree().call_group("supabase_components", "set_mode", mode)
