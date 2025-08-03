import 'package:teachme_ai/models/language.dart';

class AppLanguages {
  static final List<Language> languages = [
    Language(
      name: 'English',
      code: 'en',
      languageCode: 'en-US',
      voiceName: 'en-US-Wavenet-D',
    ),
    Language(
      name: 'Türkçe',
      code: 'tr',
      languageCode: 'tr-TR',
      voiceName: 'tr-TR-Wavenet-A',
    ),
    Language(
      name: 'Deutsch',
      code: 'de',
      languageCode: 'de-DE',
      voiceName: 'de-DE-Wavenet-A',
    ),
    Language(
      name: 'Français',
      code: 'fr',
      languageCode: 'fr-FR',
      voiceName: 'fr-FR-Wavenet-C',
    ),
    Language(
      name: 'Español',
      code: 'es',
      languageCode: 'es-ES',
      voiceName: 'es-ES-Wavenet-A',
    ),
    Language(
      name: 'Italiano',
      code: 'it',
      languageCode: 'it-IT',
      voiceName: 'it-IT-Wavenet-A',
    ),
  ];
}
