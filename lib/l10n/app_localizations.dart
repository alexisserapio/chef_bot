import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// Initial greeting message
  ///
  /// In en, this message translates to:
  /// **'Hello! 👨‍🍳'**
  String get greeting;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome to ChefBot'**
  String get welcome;

  /// Prompt to select an option
  ///
  /// In en, this message translates to:
  /// **'Select one of the two options:'**
  String get selectOption;

  /// Text for the chat button
  ///
  /// In en, this message translates to:
  /// **'Chat with ChefBot'**
  String get chatButton;

  /// Text for the HTTP operations button
  ///
  /// In en, this message translates to:
  /// **'Perform HTTP operations'**
  String get httpButton;

  /// Hint for the text field
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get textFieldHint;

  /// Message indicating the bot is typing
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get botThinking;

  /// Display name for the user
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get userDisplay;

  /// Display name for the bot
  ///
  /// In en, this message translates to:
  /// **'ChefBot'**
  String get botDisplay;

  /// Path to the bot image
  ///
  /// In en, this message translates to:
  /// **'lib/assets/chefbot.png'**
  String get pathToBotImg;

  /// Path to the user image
  ///
  /// In en, this message translates to:
  /// **'lib/assets/user.png'**
  String get pathToUserImg;

  /// Title of the HTTP section
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get httpTitle;

  /// Subtitle of the HTTP section
  ///
  /// In en, this message translates to:
  /// **'Here is a random recipe:'**
  String get httpSubtitle;

  /// Error message when fetching recipe fails
  ///
  /// In en, this message translates to:
  /// **'An error occurred while retrieving the recipe, please try again'**
  String get httpError;

  /// Hint for the search field
  ///
  /// In en, this message translates to:
  /// **'Search Recipes'**
  String get searchFieldHint;

  /// Instructions title
  ///
  /// In en, this message translates to:
  /// **'How to make the requests?'**
  String get instructionsTitle;

  /// First instruction step 1
  ///
  /// In en, this message translates to:
  /// **'1. Enter a recipe to search in TheMealDB API'**
  String get firstInstructions;

  /// Subtext of the first instruction
  ///
  /// In en, this message translates to:
  /// **'(External Information Query)'**
  String get firstSubText;

  /// Second instruction step 2
  ///
  /// In en, this message translates to:
  /// **'2. Then add your recipe to favorites by clicking the star icon'**
  String get secondInstructions;

  /// Subtext of the second instruction
  ///
  /// In en, this message translates to:
  /// **'(Simulated data submission, you can check the debug console and Pipedream URL)'**
  String get secondSubText;

  /// Message when no recipes are found
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get noRecipesFoundOne;

  /// Additional suggestion when no recipes are found
  ///
  /// In en, this message translates to:
  /// **'Try writing in English or search for another recipe'**
  String get noRecipesFoundTwo;

  /// SnackBar message when recipe is sent successfully
  ///
  /// In en, this message translates to:
  /// **'Recipe sent successfully'**
  String get snackBarSuccessful;

  /// SnackBar message when sending recipe fails
  ///
  /// In en, this message translates to:
  /// **'Error sending recipe'**
  String get snackBarError;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
