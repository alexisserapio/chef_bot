// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get greeting => 'Hello! 👨‍🍳';

  @override
  String get welcome => 'Welcome to ChefBot';

  @override
  String get selectOption => 'Select one of the two options:';

  @override
  String get chatButton => 'Chat with ChefBot';

  @override
  String get httpButton => 'Perform HTTP operations';

  @override
  String get textFieldHint => 'Type your message...';

  @override
  String get botThinking => 'Typing...';

  @override
  String get userDisplay => 'You';

  @override
  String get botDisplay => 'ChefBot';

  @override
  String get pathToBotImg => 'lib/assets/chefbot.png';

  @override
  String get pathToUserImg => 'lib/assets/user.png';

  @override
  String get httpTitle => 'Hello!';

  @override
  String get httpSubtitle => 'Here is a random recipe:';

  @override
  String get httpError => 'An error occurred while retrieving the recipe, please try again';

  @override
  String get searchFieldHint => 'Search Recipes';

  @override
  String get instructionsTitle => 'How to make the requests?';

  @override
  String get firstInstructions => '1. Enter a recipe to search in TheMealDB API';

  @override
  String get firstSubText => '(External Information Query)';

  @override
  String get secondInstructions => '2. Then add your recipe to favorites by clicking the star icon';

  @override
  String get secondSubText => '(Simulated data submission, you can check the debug console and Pipedream URL)';

  @override
  String get noRecipesFoundOne => 'No recipes found';

  @override
  String get noRecipesFoundTwo => 'Try writing in English or search for another recipe';

  @override
  String get snackBarSuccessful => 'Recipe sent successfully';

  @override
  String get snackBarError => 'Error sending recipe';

  @override
  String get noImage => 'Image not available';

  @override
  String get noName => 'Name not available';

  @override
  String get noArea => 'Country not available';

  @override
  String get noReceipe => 'Receipe not available';

  @override
  String get networkChatError => 'There was an error connecting to ChefBot, check your Internet connection';

  @override
  String get generalChatError => 'There was an error connecting to ChefBot, try checking your apiKey and try again';

  @override
  String get networkAPIError => 'Network error connecting to API, try again';
}
