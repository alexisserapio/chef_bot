// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get greeting => '¡Hola! 👨‍🍳';

  @override
  String get welcome => 'Bienvenido a ChefBot';

  @override
  String get selectOption => 'Selecciona una de las dos opciones:';

  @override
  String get chatButton => 'Chatea con ChefBot';

  @override
  String get httpButton => 'Realiza operaciones HTTP';

  @override
  String get textFieldHint => 'Escribe tu mensaje...';

  @override
  String get botThinking => 'Escribiendo...';

  @override
  String get userDisplay => 'Tú';

  @override
  String get botDisplay => 'ChefBot';

  @override
  String get pathToBotImg => 'lib/assets/chefbot.png';

  @override
  String get pathToUserImg => 'lib/assets/user.png';

  @override
  String get httpTitle => '¡Hola!';

  @override
  String get httpSubtitle => 'Aquí tienes una receta aleatoria:';

  @override
  String get httpError => 'Ocurrió un error al recuperar la receta, intenta nuevamente';

  @override
  String get searchFieldHint => 'Buscar Recetas';

  @override
  String get instructionsTitle => '¿Cómo realizar las peticiones?';

  @override
  String get firstInstructions => '1. Escribe una receta a buscar en TheMealDB API';

  @override
  String get firstSubText => '(Consulta de Informacion Externa)';

  @override
  String get secondInstructions => '2. Posteriormente agrega tu receta a favoritos dando clic en el icon de la estrella';

  @override
  String get secondSubText => '(Envio simulado de datos, puedes consultar la deubg console y la url de Pipedream)';

  @override
  String get noRecipesFoundOne => 'No se encontraron recetas';

  @override
  String get noRecipesFoundTwo => 'Intenta escribir en idioma inglés o busca otra receta';

  @override
  String get snackBarSuccessful => 'Receta enviada con éxito';

  @override
  String get snackBarError => 'Error al enviar la receta';

  @override
  String get noImage => 'Imagen no disponible';

  @override
  String get noName => 'Nombre no disponible';

  @override
  String get noArea => 'País no disponible';

  @override
  String get noReceipe => 'Receta no disponible';

  @override
  String get networkChatError => 'Hubo un error al conectarse con ChefBot, revisa tu conexión a Internet';

  @override
  String get generalChatError => 'Hubo un error al conectarse con ChefBot, prueba revisando tu apiKey y vuelve a intentarlo';

  @override
  String get networkAPIError => 'Error de red al conectar a la API, intentalo de nuevo por favor';
}
