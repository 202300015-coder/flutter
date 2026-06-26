```mermaid
classDiagram
    class StatelessWidget
    class StatefulWidget
    class State~T~
    class MyApp { +build(BuildContext context) Widget }
    class LoginPage { +createState() State }
    class _LoginPageState { -TextEditingController emailController\n-TextEditingController passwordController\n-bool aceptaTerminos\n-RegExp emailRegex\n-Map~String,String~ usuariosRegistrados\n+initState()\n+dispose()\n-_verificarContrasena(String email, String contrasena) bool\n+iniciarSesion()\n+mostrarTerminos()\n+build(BuildContext context) Widget }
    class HomePage { +createState() State }
    class _HomePageState { -TextEditingController textoController\n-bool mostrarResultado\n-bool checkboxValue\n-double imageScale\n+dispose()\n+build(BuildContext context) Widget\n-_buildFormulario() Widget\n-_buildResultado() Widget }
    class AlazarPage { +createState() State }
    class _AlazarPageState { -double valorSlider\n-bool encendido\n-Color colorActual\n+build(BuildContext context) Widget\n-_colorButton(String texto, Color color) Widget }
    StatelessWidget <|-- MyApp
    StatefulWidget <|-- LoginPage
    StatefulWidget <|-- HomePage
    StatefulWidget <|-- AlazarPage
    State~T~ <|-- _LoginPageState
    State~T~ <|-- _HomePageState
    State~T~ <|-- _AlazarPageState
    LoginPage *-- _LoginPageState : creates
    HomePage *-- _HomePageState : creates
    AlazarPage *-- _AlazarPageState : creates
    MyApp ..> LoginPage : home
    _LoginPageState ..> HomePage : navigates_to
    _HomePageState ..> AlazarPage : navigates_to
    _AlazarPageState ..> HomePage : returns_via_pop