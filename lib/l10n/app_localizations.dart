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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Name of the Pokémon type
  ///
  /// In es, this message translates to:
  /// **'{type, select, bug{Bicho} dark{Siniestro} dragon{Dragón} electric{Eléctrico} fairy{Hada} fire{Fuego} fighting{Lucha} flying{Volador} grass{Planta} ground{Tierra} ghost{Fantasma} ice{Hielo} normal{Normal} poison{Veneno} psychic{Psíquico} rock{Roca} steel{Acero} water{Agua} other{Desconocido}}'**
  String pokemonType(String type);

  /// Abbreviation of level
  ///
  /// In es, this message translates to:
  /// **'Nvl. {level}'**
  String lvl(int level);

  /// No description provided for @hp.
  ///
  /// In es, this message translates to:
  /// **'PS'**
  String get hp;

  /// No description provided for @pp.
  ///
  /// In es, this message translates to:
  /// **'PP'**
  String get pp;

  /// No description provided for @trainerLevel.
  ///
  /// In es, this message translates to:
  /// **'NE {level}'**
  String trainerLevel(Object level);

  /// No description provided for @city.
  ///
  /// In es, this message translates to:
  /// **'{city, select, palletTown{Pueblo Paleta} viridianCity{Ciudad Verde} pewterCity{Ciudad Plateada} ceruleanCity{Ciudad Celeste} saffronCity{Ciudad Azafrán} vermillionCity{Ciudad Carmín} celadonCity{Ciudad Azulona} fuchsiaCity{Ciudad Fucsia} lavenderTown{Pueblo Lavanda} cinnabarIsland{Isla Canela} other{Desconocido}}'**
  String city(String city);

  /// No description provided for @nature.
  ///
  /// In es, this message translates to:
  /// **'{nature, select, hardy{Fuerte} docile{Dócil} serious{Seria} bashful{Tímida} quirky{Rara} lonely{Huraña} bold{Osada} adamant{Firme} naughty{Pícara} brave{Audaz} relaxed{Plácida} impish{Agitada} lax{Floja} timid{Miedosa} hasty{Activa} jolly{Alegre} naive{Ingenua} modest{Modesta} mild{Afable} quiet{Mansa} rash{Alocada} calm{Serena} gentle{Amable} sassy{Grosera} careful{Cauta} other{Desconocido}}'**
  String nature(String nature);

  /// No description provided for @pkmnName.
  ///
  /// In es, this message translates to:
  /// **'{region, select, alola{{name} de Alola} galar{{name} de Galar} other{{name}}}'**
  String pkmnName(Object name, String region);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
