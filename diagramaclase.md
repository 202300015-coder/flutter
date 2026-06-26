classDiagram

class StatelessWidget
class StatefulWidget
class State~T~

class MyApp {
    +build(BuildContext context) Widget
}

class LoginPage {
    +createState() State<LoginPage>
}

class _LoginPageState {
    -TextEditingController emailController
    -TextEditingController passwordController
    -bool aceptaTerminos
    -RegExp emailRegex
    -Map<String,String> usuariosRegistrados
    +initState()
    +dispose()
    -_verificarContrasena(String email, String contrasena) bool
    +iniciarSesion()
    +mostrarTerminos()
    +build(BuildContext context) Widget
}

class HomePage {
    +createState() State<HomePage>
}

class _HomePageState {
    -TextEditingController textoController
    -bool mostrarResultado
    -bool checkboxValue
    -double imageScale
    +dispose()
    +build(BuildContext context) Widget
    -_buildFormulario() Widget
    -_buildResultado() Widget
}

class AlazarPage {
    +createState() State<AlazarPage>
}

class _AlazarPageState {
    -double valorSlider
    -bool encendido
    -Color colorActual
    +build(BuildContext context) Widget
    -_colorButton(String texto, Color color) Widget
}

%% Herencia
StatelessWidget <|-- MyApp

StatefulWidget <|-- LoginPage
StatefulWidget <|-- HomePage
StatefulWidget <|-- AlazarPage

State~LoginPage~ <|-- _LoginPageState
State~HomePage~ <|-- _HomePageState
State~AlazarPage~ <|-- _AlazarPageState

%% Composición Widget -> State
LoginPage *-- _LoginPageState : creates
HomePage *-- _HomePageState : creates
AlazarPage *-- _AlazarPageState : creates

%% Dependencias de uso
MyApp ..> LoginPage : <<home>>

_LoginPageState ..> HomePage : <<navigates to>>
_HomePageState ..> AlazarPage : <<navigates to>>
_AlazarPageState ..> HomePage : <<returns via Navigator.pop>>