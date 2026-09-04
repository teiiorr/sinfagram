import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_l10n_kaa.dart';
import 'app_l10n_ru.dart';
import 'app_l10n_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
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
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

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
    Locale('kaa'),
    Locale('ru'),
    Locale('uz'),
    Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl')
  ];

  /// Application name
  ///
  /// In uz, this message translates to:
  /// **'Sinfagram'**
  String get appTitle;

  /// No description provided for @actionContinue.
  ///
  /// In uz, this message translates to:
  /// **'Davom etish'**
  String get actionContinue;

  /// No description provided for @actionRetry.
  ///
  /// In uz, this message translates to:
  /// **'Qayta urinish'**
  String get actionRetry;

  /// No description provided for @actionSend.
  ///
  /// In uz, this message translates to:
  /// **'Yuborish'**
  String get actionSend;

  /// No description provided for @actionCancel.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get actionCancel;

  /// No description provided for @actionEdit.
  ///
  /// In uz, this message translates to:
  /// **'Tahrirlash'**
  String get actionEdit;

  /// No description provided for @actionUnderstood.
  ///
  /// In uz, this message translates to:
  /// **'Tushundim'**
  String get actionUnderstood;

  /// No description provided for @navClass.
  ///
  /// In uz, this message translates to:
  /// **'Sinf'**
  String get navClass;

  /// No description provided for @navGames.
  ///
  /// In uz, this message translates to:
  /// **'Oʻyin'**
  String get navGames;

  /// No description provided for @navChronicle.
  ///
  /// In uz, this message translates to:
  /// **'Solnoma'**
  String get navChronicle;

  /// No description provided for @navMe.
  ///
  /// In uz, this message translates to:
  /// **'Men'**
  String get navMe;

  /// No description provided for @emptyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha boʻsh'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In uz, this message translates to:
  /// **'Bu yerda hali maʼlumot yoʻq.'**
  String get emptyBody;

  /// No description provided for @errorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Xatolik yuz berdi'**
  String get errorTitle;

  /// No description provided for @errorBody.
  ///
  /// In uz, this message translates to:
  /// **'Qayta urinib koʻring.'**
  String get errorBody;

  /// No description provided for @bannerOffline.
  ///
  /// In uz, this message translates to:
  /// **'Oflayn — koʻrsatilayotgan maʼlumot eski boʻlishi mumkin'**
  String get bannerOffline;

  /// No description provided for @localeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Til va yozuv'**
  String get localeTitle;

  /// No description provided for @localeUzLatn.
  ///
  /// In uz, this message translates to:
  /// **'Oʻzbekcha (lotin)'**
  String get localeUzLatn;

  /// No description provided for @localeUzCyrl.
  ///
  /// In uz, this message translates to:
  /// **'Ўзбекча (кирилл)'**
  String get localeUzCyrl;

  /// No description provided for @localeRu.
  ///
  /// In uz, this message translates to:
  /// **'Русский'**
  String get localeRu;

  /// No description provided for @localeKaa.
  ///
  /// In uz, this message translates to:
  /// **'Qaraqalpaqsha'**
  String get localeKaa;

  /// No description provided for @roleTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kim sifatida kirasiz?'**
  String get roleTitle;

  /// No description provided for @rolePupil.
  ///
  /// In uz, this message translates to:
  /// **'Men oʻquvchiman'**
  String get rolePupil;

  /// No description provided for @rolePupilSub.
  ///
  /// In uz, this message translates to:
  /// **'Sinf kodi bilan oʻz sinfingizga kirasiz.'**
  String get rolePupilSub;

  /// No description provided for @roleTeacher.
  ///
  /// In uz, this message translates to:
  /// **'Men oʻqituvchiman'**
  String get roleTeacher;

  /// No description provided for @roleTeacherSub.
  ///
  /// In uz, this message translates to:
  /// **'Sinf yaratasiz va roʻyxatni tasdiqlaysiz.'**
  String get roleTeacherSub;

  /// No description provided for @roleParent.
  ///
  /// In uz, this message translates to:
  /// **'Men ota-onaman'**
  String get roleParent;

  /// No description provided for @roleParentSub.
  ///
  /// In uz, this message translates to:
  /// **'Farzandingiz faoliyatini kuzatasiz.'**
  String get roleParentSub;

  /// No description provided for @codeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Oʻqituvchingiz bergan kodni kiriting'**
  String get codeTitle;

  /// No description provided for @codeHelp.
  ///
  /// In uz, this message translates to:
  /// **'Kod yoʻqmi? Sinf rahbaringizga murojaat qiling.'**
  String get codeHelp;

  /// No description provided for @codeError.
  ///
  /// In uz, this message translates to:
  /// **'Kod notoʻgʻri. Qayta tekshiring.'**
  String get codeError;

  /// No description provided for @rosterTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ismingizni tanlang'**
  String get rosterTitle;

  /// No description provided for @rosterSearch.
  ///
  /// In uz, this message translates to:
  /// **'Qidirish'**
  String get rosterSearch;

  /// No description provided for @rosterConfirmTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu sizmisiz?'**
  String get rosterConfirmTitle;

  /// No description provided for @pinTitle.
  ///
  /// In uz, this message translates to:
  /// **'PIN kod oʻrnating'**
  String get pinTitle;

  /// No description provided for @pinRepeat.
  ///
  /// In uz, this message translates to:
  /// **'PIN kodni takrorlang'**
  String get pinRepeat;

  /// No description provided for @pinHint.
  ///
  /// In uz, this message translates to:
  /// **'Bu PIN faqat shu qurilma uchun.'**
  String get pinHint;

  /// No description provided for @pinMismatch.
  ///
  /// In uz, this message translates to:
  /// **'PIN kodlar mos kelmadi.'**
  String get pinMismatch;

  /// No description provided for @consentTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ota-ona tasdigʻi kutilmoqda'**
  String get consentTitle;

  /// No description provided for @consentBody.
  ///
  /// In uz, this message translates to:
  /// **'Ota-onangiz roziligini bergach, sinfga kira olasiz.'**
  String get consentBody;

  /// No description provided for @consentResend.
  ///
  /// In uz, this message translates to:
  /// **'Soʻrovni qayta yuborish'**
  String get consentResend;

  /// No description provided for @visibilityTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ota-onangiz nimani koʻradi'**
  String get visibilityTitle;

  /// No description provided for @visibilitySees.
  ///
  /// In uz, this message translates to:
  /// **'Ota-onangiz koʻradi'**
  String get visibilitySees;

  /// No description provided for @visibilitySeesItems.
  ///
  /// In uz, this message translates to:
  /// **'Siz eʼlon qilgan postlar\nFaollik kunlari va vaqti\nSinfdagi shikoyatlar natijasi'**
  String get visibilitySeesItems;

  /// No description provided for @visibilityNotSees.
  ///
  /// In uz, this message translates to:
  /// **'Ota-onangiz koʻrmaydi'**
  String get visibilityNotSees;

  /// No description provided for @visibilityNotItems.
  ///
  /// In uz, this message translates to:
  /// **'Shaxsiy xabarlaringiz (ular umuman yoʻq)\nKimga rahmat berganingiz\nQaysi postlarni oʻqiganingiz'**
  String get visibilityNotItems;

  /// No description provided for @dayComposerEntry.
  ///
  /// In uz, this message translates to:
  /// **'Nima boʻldi bugun?'**
  String get dayComposerEntry;

  /// No description provided for @dayComplete.
  ///
  /// In uz, this message translates to:
  /// **'Bugungisi tugadi'**
  String get dayComplete;

  /// No description provided for @dayCompleteSub.
  ///
  /// In uz, this message translates to:
  /// **'Ertaga yana koʻrishamiz.'**
  String get dayCompleteSub;

  /// No description provided for @dayPrevious.
  ///
  /// In uz, this message translates to:
  /// **'Kechagi kunni koʻrish'**
  String get dayPrevious;

  /// No description provided for @dayEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Bugun hali hech narsa yoʻq. Birinchi boʻlishingiz mumkin.'**
  String get dayEmpty;

  /// No description provided for @thanks.
  ///
  /// In uz, this message translates to:
  /// **'Rahmat'**
  String get thanks;

  /// No description provided for @report.
  ///
  /// In uz, this message translates to:
  /// **'Shikoyat'**
  String get report;

  /// No description provided for @comments.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, =0{Izoh yoʻq} other{Izoh {count}}}'**
  String comments(int count);

  /// No description provided for @composeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yangi post'**
  String get composeTitle;

  /// No description provided for @composeHint.
  ///
  /// In uz, this message translates to:
  /// **'Nima boʻldi bugun?'**
  String get composeHint;

  /// No description provided for @composePost.
  ///
  /// In uz, this message translates to:
  /// **'Joylash'**
  String get composePost;

  /// No description provided for @composePhoto.
  ///
  /// In uz, this message translates to:
  /// **'Rasm qoʻshish'**
  String get composePhoto;

  /// No description provided for @composeReview.
  ///
  /// In uz, this message translates to:
  /// **'Bu post koʻrib chiqilmoqda'**
  String get composeReview;

  /// No description provided for @meThanksTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sizning rahmatlaringiz'**
  String get meThanksTitle;

  /// No description provided for @meThanksPrivate.
  ///
  /// In uz, this message translates to:
  /// **'Buni faqat siz va ota-onangiz koʻradi.'**
  String get meThanksPrivate;

  /// No description provided for @meTimeToday.
  ///
  /// In uz, this message translates to:
  /// **'Bugun ilovada'**
  String get meTimeToday;

  /// No description provided for @meSettings.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get meSettings;

  /// No description provided for @meAbout.
  ///
  /// In uz, this message translates to:
  /// **'Ilova haqida'**
  String get meAbout;

  /// No description provided for @meSignOut.
  ///
  /// In uz, this message translates to:
  /// **'Chiqish'**
  String get meSignOut;

  /// No description provided for @gamesTitle.
  ///
  /// In uz, this message translates to:
  /// **'Oʻyin'**
  String get gamesTitle;

  /// No description provided for @gamesEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha bellashuv yoʻq. Keyingisi tez orada.'**
  String get gamesEmpty;

  /// No description provided for @chronicleTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sinf solnomasi'**
  String get chronicleTitle;

  /// No description provided for @chronicleEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Birinchi bob shu oyda yigʻiladi.'**
  String get chronicleEmpty;

  /// No description provided for @boardTitle.
  ///
  /// In uz, this message translates to:
  /// **'Maktab taxtasi'**
  String get boardTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In uz, this message translates to:
  /// **'Til va yozuv'**
  String get settingsLanguage;

  /// No description provided for @settingsDarkMode.
  ///
  /// In uz, this message translates to:
  /// **'Tungi tema'**
  String get settingsDarkMode;

  /// No description provided for @settingsSignOut.
  ///
  /// In uz, this message translates to:
  /// **'Chiqish'**
  String get settingsSignOut;

  /// No description provided for @aboutTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ilova haqida'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In uz, this message translates to:
  /// **'Versiya'**
  String get aboutVersion;

  /// No description provided for @aboutMinistry.
  ///
  /// In uz, this message translates to:
  /// **'Maktabgacha va maktab taʼlimi vazirligi'**
  String get aboutMinistry;

  /// No description provided for @chalkTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bugun sinfda'**
  String get chalkTitle;

  /// No description provided for @chalkNote.
  ///
  /// In uz, this message translates to:
  /// **'Bilim — kelajak kaliti'**
  String get chalkNote;

  /// No description provided for @storyYou.
  ///
  /// In uz, this message translates to:
  /// **'Siz'**
  String get storyYou;

  /// No description provided for @storyAdd.
  ///
  /// In uz, this message translates to:
  /// **'Hikoya qoʻshish'**
  String get storyAdd;

  /// No description provided for @storyAdded.
  ///
  /// In uz, this message translates to:
  /// **'Hikoyangiz qoʻshildi'**
  String get storyAdded;

  /// No description provided for @feedFriendsNow.
  ///
  /// In uz, this message translates to:
  /// **'Doʻstlar nima yozdi'**
  String get feedFriendsNow;

  /// No description provided for @meReading.
  ///
  /// In uz, this message translates to:
  /// **'Hozir oʻqiyapman'**
  String get meReading;

  /// No description provided for @meListening.
  ///
  /// In uz, this message translates to:
  /// **'Hozir tinglayapman'**
  String get meListening;

  /// No description provided for @meInterests.
  ///
  /// In uz, this message translates to:
  /// **'Qiziqishlar'**
  String get meInterests;

  /// No description provided for @meBio.
  ///
  /// In uz, this message translates to:
  /// **'Men haqimda'**
  String get meBio;

  /// No description provided for @meEditProfile.
  ///
  /// In uz, this message translates to:
  /// **'Profilni tahrirlash'**
  String get meEditProfile;

  /// No description provided for @meEditSaved.
  ///
  /// In uz, this message translates to:
  /// **'Profil saqlandi'**
  String get meEditSaved;

  /// No description provided for @commentsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Izohlar'**
  String get commentsTitle;

  /// No description provided for @commentHint.
  ///
  /// In uz, this message translates to:
  /// **'Izoh yozing...'**
  String get commentHint;

  /// No description provided for @commentEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hali izoh yoʻq. Birinchi boʻling.'**
  String get commentEmpty;

  /// No description provided for @helpTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yordam taxtasi'**
  String get helpTitle;

  /// No description provided for @helpFilterAll.
  ///
  /// In uz, this message translates to:
  /// **'Barchasi'**
  String get helpFilterAll;

  /// No description provided for @helpFilterWaiting.
  ///
  /// In uz, this message translates to:
  /// **'Javob kutmoqda'**
  String get helpFilterWaiting;

  /// No description provided for @helpFilterClosed.
  ///
  /// In uz, this message translates to:
  /// **'Yopilgan'**
  String get helpFilterClosed;

  /// No description provided for @helpAsk.
  ///
  /// In uz, this message translates to:
  /// **'Savol berish'**
  String get helpAsk;

  /// No description provided for @helpEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hali savol yoʻq. Birinchi boʻlib soʻrang.'**
  String get helpEmpty;

  /// No description provided for @helpAnswers.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, =0{Javob yoʻq} other{{count} ta javob}}'**
  String helpAnswers(int count);

  /// No description provided for @helpBest.
  ///
  /// In uz, this message translates to:
  /// **'Eng yaxshi javob'**
  String get helpBest;

  /// No description provided for @helpMarkBest.
  ///
  /// In uz, this message translates to:
  /// **'Eng yaxshi deb belgilash'**
  String get helpMarkBest;

  /// No description provided for @helpAnswerHint.
  ///
  /// In uz, this message translates to:
  /// **'Javobingiz...'**
  String get helpAnswerHint;

  /// No description provided for @helpAnswerMin.
  ///
  /// In uz, this message translates to:
  /// **'Kamida 40 belgi kerak'**
  String get helpAnswerMin;

  /// No description provided for @helpAskTitle.
  ///
  /// In uz, this message translates to:
  /// **'Savol berish'**
  String get helpAskTitle;

  /// No description provided for @helpQuestionHint.
  ///
  /// In uz, this message translates to:
  /// **'Savolingizni yozing'**
  String get helpQuestionHint;

  /// No description provided for @helpSubject.
  ///
  /// In uz, this message translates to:
  /// **'Fan'**
  String get helpSubject;

  /// No description provided for @boardSchedule.
  ///
  /// In uz, this message translates to:
  /// **'Dars jadvali'**
  String get boardSchedule;

  /// No description provided for @boardHomework.
  ///
  /// In uz, this message translates to:
  /// **'Uy vazifasi'**
  String get boardHomework;

  /// No description provided for @boardAnnouncements.
  ///
  /// In uz, this message translates to:
  /// **'Eʼlonlar'**
  String get boardAnnouncements;

  /// No description provided for @boardLostFound.
  ///
  /// In uz, this message translates to:
  /// **'Yoʻqolgan buyumlar'**
  String get boardLostFound;

  /// No description provided for @boardNow.
  ///
  /// In uz, this message translates to:
  /// **'Hozir'**
  String get boardNow;

  /// No description provided for @reportTitle.
  ///
  /// In uz, this message translates to:
  /// **'Shikoyat'**
  String get reportTitle;

  /// No description provided for @reportReasonBullying.
  ///
  /// In uz, this message translates to:
  /// **'Bulling / kamsitish'**
  String get reportReasonBullying;

  /// No description provided for @reportReasonOffensive.
  ///
  /// In uz, this message translates to:
  /// **'Ogʻzaki haqorat'**
  String get reportReasonOffensive;

  /// No description provided for @reportReasonSpam.
  ///
  /// In uz, this message translates to:
  /// **'Spam / reklama'**
  String get reportReasonSpam;

  /// No description provided for @reportReasonOther.
  ///
  /// In uz, this message translates to:
  /// **'Boshqa'**
  String get reportReasonOther;

  /// No description provided for @reportNoteHint.
  ///
  /// In uz, this message translates to:
  /// **'Izoh (ixtiyoriy)'**
  String get reportNoteHint;

  /// No description provided for @reportWhoSees.
  ///
  /// In uz, this message translates to:
  /// **'Buni faqat sinf rahbaringiz koʻradi. Kim shikoyat qilgani oshkor etilmaydi.'**
  String get reportWhoSees;

  /// No description provided for @reportSent.
  ///
  /// In uz, this message translates to:
  /// **'Shikoyatingiz yuborildi'**
  String get reportSent;

  /// No description provided for @gameActiveBattle.
  ///
  /// In uz, this message translates to:
  /// **'Faol bellashuv'**
  String get gameActiveBattle;

  /// No description provided for @gameOpponent.
  ///
  /// In uz, this message translates to:
  /// **'Raqib'**
  String get gameOpponent;

  /// No description provided for @gameSubject.
  ///
  /// In uz, this message translates to:
  /// **'Fan'**
  String get gameSubject;

  /// No description provided for @gameStart.
  ///
  /// In uz, this message translates to:
  /// **'Boshlash'**
  String get gameStart;

  /// No description provided for @gameCannotPause.
  ///
  /// In uz, this message translates to:
  /// **'Boshlangach, toʻxtatib boʻlmaydi.'**
  String get gameCannotPause;

  /// No description provided for @gamePlayed.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, =0{Hali hech kim qatnashmadi} other{{count} oʻquvchi qatnashdi}}'**
  String gamePlayed(int count);

  /// No description provided for @gameLeagueSection.
  ///
  /// In uz, this message translates to:
  /// **'Liga'**
  String get gameLeagueSection;

  /// No description provided for @gameRankValue.
  ///
  /// In uz, this message translates to:
  /// **'{count}-oʻrin'**
  String gameRankValue(int count);

  /// No description provided for @gamePointsValue.
  ///
  /// In uz, this message translates to:
  /// **'{count} ball'**
  String gamePointsValue(int count);

  /// No description provided for @gameChallengeSection.
  ///
  /// In uz, this message translates to:
  /// **'Haftalik chaqiriq'**
  String get gameChallengeSection;

  /// No description provided for @gameDaysLeft.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, other{{count} kun qoldi}}'**
  String gameDaysLeft(int count);

  /// No description provided for @battleResultTitle.
  ///
  /// In uz, this message translates to:
  /// **'Natija'**
  String get battleResultTitle;

  /// No description provided for @battleYourClass.
  ///
  /// In uz, this message translates to:
  /// **'Sizning sinfingiz'**
  String get battleYourClass;

  /// No description provided for @battleOpponentClass.
  ///
  /// In uz, this message translates to:
  /// **'Raqib sinf'**
  String get battleOpponentClass;

  /// No description provided for @battleParticipation.
  ///
  /// In uz, this message translates to:
  /// **'Qatnashuv'**
  String get battleParticipation;

  /// No description provided for @battlePerSubject.
  ///
  /// In uz, this message translates to:
  /// **'Fanlar boʻyicha'**
  String get battlePerSubject;

  /// No description provided for @battleWin.
  ///
  /// In uz, this message translates to:
  /// **'Gʻalaba!'**
  String get battleWin;

  /// No description provided for @battleLose.
  ///
  /// In uz, this message translates to:
  /// **'Bu safar boʻlmadi'**
  String get battleLose;

  /// No description provided for @battleDraw.
  ///
  /// In uz, this message translates to:
  /// **'Durrang'**
  String get battleDraw;

  /// No description provided for @battleNoPupilScore.
  ///
  /// In uz, this message translates to:
  /// **'Ball butun sinfniki — shaxsiy natija koʻrsatilmaydi.'**
  String get battleNoPupilScore;

  /// No description provided for @leagueTitle.
  ///
  /// In uz, this message translates to:
  /// **'Liga'**
  String get leagueTitle;

  /// No description provided for @leagueParallel.
  ///
  /// In uz, this message translates to:
  /// **'Parallel'**
  String get leagueParallel;

  /// No description provided for @leagueSchool.
  ///
  /// In uz, this message translates to:
  /// **'Maktab'**
  String get leagueSchool;

  /// No description provided for @leagueDistrict.
  ///
  /// In uz, this message translates to:
  /// **'Tuman'**
  String get leagueDistrict;

  /// No description provided for @leagueRegion.
  ///
  /// In uz, this message translates to:
  /// **'Viloyat'**
  String get leagueRegion;

  /// No description provided for @leagueColClass.
  ///
  /// In uz, this message translates to:
  /// **'Sinf'**
  String get leagueColClass;

  /// No description provided for @leagueColPlayed.
  ///
  /// In uz, this message translates to:
  /// **'Oʻyinlar'**
  String get leagueColPlayed;

  /// No description provided for @leagueColPoints.
  ///
  /// In uz, this message translates to:
  /// **'Ball'**
  String get leagueColPoints;

  /// No description provided for @leagueEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Mavsum hali boshlanmadi'**
  String get leagueEmpty;

  /// No description provided for @chronicleSealed.
  ///
  /// In uz, this message translates to:
  /// **'Muhrlangan'**
  String get chronicleSealed;

  /// No description provided for @chronicleItems.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, =0{Element yoʻq} other{{count} ta element}}'**
  String chronicleItems(int count);

  /// No description provided for @chronicleDaysToSeal.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, other{{count} kundan soʻng muhrlanadi}}'**
  String chronicleDaysToSeal(int count);

  /// No description provided for @chapterSealedNote.
  ///
  /// In uz, this message translates to:
  /// **'Bu bob muhrlangan — faqat koʻrish uchun.'**
  String get chapterSealedNote;

  /// No description provided for @chapterEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Bu bobda hali element yoʻq.'**
  String get chapterEmpty;

  /// No description provided for @nightTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tungi rejim'**
  String get nightTitle;

  /// No description provided for @nightBody.
  ///
  /// In uz, this message translates to:
  /// **'Sinf tunda dam oladi. Ertalab {time} da yana ochiladi.'**
  String nightBody(String time);

  /// No description provided for @nightToBoard.
  ///
  /// In uz, this message translates to:
  /// **'Maktab taxtasiga oʻtish'**
  String get nightToBoard;

  /// No description provided for @lessonTitle.
  ///
  /// In uz, this message translates to:
  /// **'Dars rejimi'**
  String get lessonTitle;

  /// No description provided for @lessonBody.
  ///
  /// In uz, this message translates to:
  /// **'Hozir dars vaqti. Dars {time} da tugaydi.'**
  String lessonBody(String time);

  /// No description provided for @lessonToBoard.
  ///
  /// In uz, this message translates to:
  /// **'Jadval va uy vazifasi'**
  String get lessonToBoard;

  /// No description provided for @settingsMode.
  ///
  /// In uz, this message translates to:
  /// **'Rejim (demo)'**
  String get settingsMode;

  /// No description provided for @modeNormal.
  ///
  /// In uz, this message translates to:
  /// **'Oddiy'**
  String get modeNormal;

  /// No description provided for @modeNight.
  ///
  /// In uz, this message translates to:
  /// **'Tungi'**
  String get modeNight;

  /// No description provided for @modeLesson.
  ///
  /// In uz, this message translates to:
  /// **'Dars'**
  String get modeLesson;

  /// No description provided for @tNavClasses.
  ///
  /// In uz, this message translates to:
  /// **'Sinflar'**
  String get tNavClasses;

  /// No description provided for @tNavCases.
  ///
  /// In uz, this message translates to:
  /// **'Murojaatlar'**
  String get tNavCases;

  /// No description provided for @tClassJoined.
  ///
  /// In uz, this message translates to:
  /// **'{joined}/{total} oʻquvchi qoʻshildi'**
  String tClassJoined(int joined, int total);

  /// No description provided for @tOpenCases.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, =0{Ochiq murojaat yoʻq} other{{count} ochiq murojaat}}'**
  String tOpenCases(int count);

  /// No description provided for @tCasesEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Ochiq murojaat yoʻq — bu yaxshi holat.'**
  String get tCasesEmpty;

  /// No description provided for @tCaseOverdue.
  ///
  /// In uz, this message translates to:
  /// **'Muddati oʻtgan'**
  String get tCaseOverdue;

  /// No description provided for @tCaseDue.
  ///
  /// In uz, this message translates to:
  /// **'Muddat: {time}'**
  String tCaseDue(String time);

  /// No description provided for @tCaseEvidence.
  ///
  /// In uz, this message translates to:
  /// **'Dalil'**
  String get tCaseEvidence;

  /// No description provided for @tCaseHistory.
  ///
  /// In uz, this message translates to:
  /// **'Tarix'**
  String get tCaseHistory;

  /// No description provided for @tCaseActionHide.
  ///
  /// In uz, this message translates to:
  /// **'Yashirish'**
  String get tCaseActionHide;

  /// No description provided for @tCaseActionMute.
  ///
  /// In uz, this message translates to:
  /// **'24 soatga ovozsiz'**
  String get tCaseActionMute;

  /// No description provided for @tCaseActionEscalate.
  ///
  /// In uz, this message translates to:
  /// **'Yuqoriga uzatish'**
  String get tCaseActionEscalate;

  /// No description provided for @tCaseActionDismiss.
  ///
  /// In uz, this message translates to:
  /// **'Rad etish'**
  String get tCaseActionDismiss;

  /// No description provided for @tCaseNoteHint.
  ///
  /// In uz, this message translates to:
  /// **'Izoh yozing (majburiy)'**
  String get tCaseNoteHint;

  /// No description provided for @tCaseResolved.
  ///
  /// In uz, this message translates to:
  /// **'Ish yopildi'**
  String get tCaseResolved;

  /// No description provided for @tCaseAnonymous.
  ///
  /// In uz, this message translates to:
  /// **'Shikoyatchi kim ekani oshkor etilmaydi.'**
  String get tCaseAnonymous;

  /// No description provided for @tGamesSchedule.
  ///
  /// In uz, this message translates to:
  /// **'Bellashuv rejalashtirish'**
  String get tGamesSchedule;

  /// No description provided for @tGamesSoon.
  ///
  /// In uz, this message translates to:
  /// **'Rejalashtirish tez orada.'**
  String get tGamesSoon;

  /// No description provided for @pNavChild.
  ///
  /// In uz, this message translates to:
  /// **'Bolam'**
  String get pNavChild;

  /// No description provided for @pNavMessages.
  ///
  /// In uz, this message translates to:
  /// **'Xabarlar'**
  String get pNavMessages;

  /// No description provided for @pDigestTitle.
  ///
  /// In uz, this message translates to:
  /// **'Haftalik xulosa'**
  String get pDigestTitle;

  /// No description provided for @pActiveDays.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, other{{count} kun faol boʻldi}}'**
  String pActiveDays(int count);

  /// No description provided for @pMinutes.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, other{{count} daqiqa}}'**
  String pMinutes(int count);

  /// No description provided for @pPublishedCount.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, =0{Post joylamadi} other{{count} ta post joyladi}}'**
  String pPublishedCount(int count);

  /// No description provided for @pThanksReceived.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, other{{count} ta rahmat oldi}}'**
  String pThanksReceived(int count);

  /// No description provided for @pChildContent.
  ///
  /// In uz, this message translates to:
  /// **'Farzandingiz postlari'**
  String get pChildContent;

  /// No description provided for @pChildContentEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hali post yoʻq.'**
  String get pChildContentEmpty;

  /// No description provided for @pCases.
  ///
  /// In uz, this message translates to:
  /// **'Shikoyatlar'**
  String get pCases;

  /// No description provided for @pCasesEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Farzandingizga oid shikoyat yoʻq.'**
  String get pCasesEmpty;

  /// No description provided for @pControls.
  ///
  /// In uz, this message translates to:
  /// **'Boshqaruv'**
  String get pControls;

  /// No description provided for @pTimeLimit.
  ///
  /// In uz, this message translates to:
  /// **'Kunlik vaqt chegarasi'**
  String get pTimeLimit;

  /// No description provided for @pNotifs.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnomalar'**
  String get pNotifs;

  /// No description provided for @pConsentData.
  ///
  /// In uz, this message translates to:
  /// **'Rozilik va maʼlumotlar'**
  String get pConsentData;

  /// No description provided for @pConsentGranted.
  ///
  /// In uz, this message translates to:
  /// **'Rozilik berilgan'**
  String get pConsentGranted;

  /// No description provided for @pCollected.
  ///
  /// In uz, this message translates to:
  /// **'Yigʻiladigan maʼlumotlar'**
  String get pCollected;

  /// No description provided for @pNotCollected.
  ///
  /// In uz, this message translates to:
  /// **'Yigʻilmaydigan maʼlumotlar'**
  String get pNotCollected;

  /// No description provided for @pExport.
  ///
  /// In uz, this message translates to:
  /// **'Maʼlumotlarni yuklab olish'**
  String get pExport;

  /// No description provided for @pDelete.
  ///
  /// In uz, this message translates to:
  /// **'Hisobni oʻchirish'**
  String get pDelete;

  /// No description provided for @pNoLiveFeed.
  ///
  /// In uz, this message translates to:
  /// **'Jonli faoliyat lentasi va “onlayn” koʻrsatkichi yoʻq. Bu bolaning ishonchini saqlaydi.'**
  String get pNoLiveFeed;

  /// No description provided for @pMessagesEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha xabar yoʻq.'**
  String get pMessagesEmpty;

  /// No description provided for @pMessageTeacher.
  ///
  /// In uz, this message translates to:
  /// **'Oʻqituvchiga xabar'**
  String get pMessageTeacher;

  /// No description provided for @rolesTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sinf rollari'**
  String get rolesTitle;

  /// No description provided for @rolesThisWeek.
  ///
  /// In uz, this message translates to:
  /// **'Shu hafta'**
  String get rolesThisWeek;

  /// No description provided for @rolesRotation.
  ///
  /// In uz, this message translates to:
  /// **'Navbat tartibi'**
  String get rolesRotation;

  /// No description provided for @wallTitle.
  ///
  /// In uz, this message translates to:
  /// **'Umumiy devor'**
  String get wallTitle;

  /// No description provided for @wallContributors.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, other{{count} ta hissa qoʻshildi}}'**
  String wallContributors(int count);

  /// No description provided for @wallAdd.
  ///
  /// In uz, this message translates to:
  /// **'Belgi qoʻshish'**
  String get wallAdd;

  /// No description provided for @wallDone.
  ///
  /// In uz, this message translates to:
  /// **'Siz hissa qoʻshdingiz'**
  String get wallDone;

  /// No description provided for @challengeScreenTitle.
  ///
  /// In uz, this message translates to:
  /// **'Haftalik chaqiriq'**
  String get challengeScreenTitle;

  /// No description provided for @challengeDeadline.
  ///
  /// In uz, this message translates to:
  /// **'Muddat: {date}'**
  String challengeDeadline(String date);

  /// No description provided for @challengeSubmit.
  ///
  /// In uz, this message translates to:
  /// **'Ishtirok etish'**
  String get challengeSubmit;

  /// No description provided for @challengeEntries.
  ///
  /// In uz, this message translates to:
  /// **'Sinf ishlari'**
  String get challengeEntries;

  /// No description provided for @challengeSubmitted.
  ///
  /// In uz, this message translates to:
  /// **'Ishingiz yuborildi'**
  String get challengeSubmitted;

  /// No description provided for @capsuleTitle.
  ///
  /// In uz, this message translates to:
  /// **'Vaqt kapsulasi'**
  String get capsuleTitle;

  /// No description provided for @capsuleOpenHint.
  ///
  /// In uz, this message translates to:
  /// **'Kelajakdagi oʻzingizga xat yozing'**
  String get capsuleOpenHint;

  /// No description provided for @capsuleSeals.
  ///
  /// In uz, this message translates to:
  /// **'{date} da muhrlanadi'**
  String capsuleSeals(String date);

  /// No description provided for @capsuleSealedOn.
  ///
  /// In uz, this message translates to:
  /// **'Muhrlangan: {date}'**
  String capsuleSealedOn(String date);

  /// No description provided for @capsuleOpensOn.
  ///
  /// In uz, this message translates to:
  /// **'Ochiladi: {date}'**
  String capsuleOpensOn(String date);

  /// No description provided for @capsuleNotes.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, other{{count} ta xat}}'**
  String capsuleNotes(int count);

  /// No description provided for @capsuleWrite.
  ///
  /// In uz, this message translates to:
  /// **'Xat yozish'**
  String get capsuleWrite;

  /// No description provided for @capsuleSaved.
  ///
  /// In uz, this message translates to:
  /// **'Xatingiz kapsulaga saqlandi'**
  String get capsuleSaved;

  /// No description provided for @tClassDetail.
  ///
  /// In uz, this message translates to:
  /// **'Sinf'**
  String get tClassDetail;

  /// No description provided for @tRoster.
  ///
  /// In uz, this message translates to:
  /// **'Roʻyxat'**
  String get tRoster;

  /// No description provided for @tGenerateCode.
  ///
  /// In uz, this message translates to:
  /// **'Kod yaratish'**
  String get tGenerateCode;

  /// No description provided for @tProjectGroups.
  ///
  /// In uz, this message translates to:
  /// **'Loyiha guruhlari'**
  String get tProjectGroups;

  /// No description provided for @tImportTitle.
  ///
  /// In uz, this message translates to:
  /// **'Roʻyxatni import qilish'**
  String get tImportTitle;

  /// No description provided for @tImportManual.
  ///
  /// In uz, this message translates to:
  /// **'Qoʻlda qoʻshish'**
  String get tImportManual;

  /// No description provided for @tImportCsv.
  ///
  /// In uz, this message translates to:
  /// **'CSV yuklash'**
  String get tImportCsv;

  /// No description provided for @tImportChanges.
  ///
  /// In uz, this message translates to:
  /// **'Oʻzgarishlar'**
  String get tImportChanges;

  /// No description provided for @tImportApply.
  ///
  /// In uz, this message translates to:
  /// **'Qoʻllash'**
  String get tImportApply;

  /// No description provided for @tCodeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sinf kodi'**
  String get tCodeTitle;

  /// No description provided for @tCodePrint.
  ///
  /// In uz, this message translates to:
  /// **'A5 chop etish'**
  String get tCodePrint;

  /// No description provided for @tCodeShareNote.
  ///
  /// In uz, this message translates to:
  /// **'Bu kodni faqat oʻz oʻquvchilaringizga bering.'**
  String get tCodeShareNote;

  /// No description provided for @tAnnounceTitle.
  ///
  /// In uz, this message translates to:
  /// **'Eʼlon'**
  String get tAnnounceTitle;

  /// No description provided for @tAnnounceScope.
  ///
  /// In uz, this message translates to:
  /// **'Koʻrinish'**
  String get tAnnounceScope;

  /// No description provided for @tScopeClass.
  ///
  /// In uz, this message translates to:
  /// **'Sinf'**
  String get tScopeClass;

  /// No description provided for @tScopeSchool.
  ///
  /// In uz, this message translates to:
  /// **'Maktab'**
  String get tScopeSchool;

  /// No description provided for @tAnnounceHint.
  ///
  /// In uz, this message translates to:
  /// **'Eʼlon matni'**
  String get tAnnounceHint;

  /// No description provided for @tAnnouncePin.
  ///
  /// In uz, this message translates to:
  /// **'Yuqoriga mahkamlash'**
  String get tAnnouncePin;

  /// No description provided for @tAnnouncePost.
  ///
  /// In uz, this message translates to:
  /// **'Joylash'**
  String get tAnnouncePost;

  /// No description provided for @tAnnouncePosted.
  ///
  /// In uz, this message translates to:
  /// **'Eʼlon joylandi'**
  String get tAnnouncePosted;

  /// No description provided for @tScheduleTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bellashuv rejalashtirish'**
  String get tScheduleTitle;

  /// No description provided for @tPickOpponent.
  ///
  /// In uz, this message translates to:
  /// **'Raqib sinf'**
  String get tPickOpponent;

  /// No description provided for @tPickSubject.
  ///
  /// In uz, this message translates to:
  /// **'Fan'**
  String get tPickSubject;

  /// No description provided for @tPickWindow.
  ///
  /// In uz, this message translates to:
  /// **'Vaqt oraligʻi'**
  String get tPickWindow;

  /// No description provided for @tScheduleConfirm.
  ///
  /// In uz, this message translates to:
  /// **'Rejalashtirish'**
  String get tScheduleConfirm;

  /// No description provided for @tScheduled.
  ///
  /// In uz, this message translates to:
  /// **'Bellashuv rejalashtirildi'**
  String get tScheduled;

  /// No description provided for @tChannelTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sinf kanali'**
  String get tChannelTitle;

  /// No description provided for @tChannelNote.
  ///
  /// In uz, this message translates to:
  /// **'Bu kanal butun sinfga koʻrinadi — shaxsiy emas.'**
  String get tChannelNote;

  /// No description provided for @tChronicleAdmin.
  ///
  /// In uz, this message translates to:
  /// **'Solnoma boshqaruvi'**
  String get tChronicleAdmin;

  /// No description provided for @tSetCover.
  ///
  /// In uz, this message translates to:
  /// **'Muqovani belgilash'**
  String get tSetCover;

  /// No description provided for @tSeal.
  ///
  /// In uz, this message translates to:
  /// **'Muhrlash'**
  String get tSeal;

  /// No description provided for @tExportPdf.
  ///
  /// In uz, this message translates to:
  /// **'PDF eksport'**
  String get tExportPdf;

  /// No description provided for @meReadingHint.
  ///
  /// In uz, this message translates to:
  /// **'Qaysi kitobni oʻqiyapsiz?'**
  String get meReadingHint;

  /// No description provided for @meListeningHint.
  ///
  /// In uz, this message translates to:
  /// **'Qanday musiqa tinglayapsiz?'**
  String get meListeningHint;

  /// No description provided for @meBioHint.
  ///
  /// In uz, this message translates to:
  /// **'Oʻzingiz haqingizda qisqacha'**
  String get meBioHint;

  /// No description provided for @meEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hali toʻldirilmagan'**
  String get meEmpty;

  /// No description provided for @meSave.
  ///
  /// In uz, this message translates to:
  /// **'Saqlash'**
  String get meSave;

  /// No description provided for @classmatesTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sinfdoshlar'**
  String get classmatesTitle;

  /// No description provided for @classmatesOpen.
  ///
  /// In uz, this message translates to:
  /// **'Sinfdoshlarni koʻrish'**
  String get classmatesOpen;

  /// No description provided for @classmatesSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Sinfingizdagi doʻstlar'**
  String get classmatesSubtitle;

  /// No description provided for @personReading.
  ///
  /// In uz, this message translates to:
  /// **'Oʻqiyapti'**
  String get personReading;

  /// No description provided for @personListening.
  ///
  /// In uz, this message translates to:
  /// **'Tinglayapti'**
  String get personListening;

  /// No description provided for @personInterests.
  ///
  /// In uz, this message translates to:
  /// **'Qiziqishlar'**
  String get personInterests;

  /// No description provided for @personBio.
  ///
  /// In uz, this message translates to:
  /// **'Bio'**
  String get personBio;

  /// No description provided for @personPhotos.
  ///
  /// In uz, this message translates to:
  /// **'Suratlar'**
  String get personPhotos;

  /// No description provided for @personNoInfo.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha maʼlumot yoʻq'**
  String get personNoInfo;

  /// No description provided for @composeVideo.
  ///
  /// In uz, this message translates to:
  /// **'Video'**
  String get composeVideo;

  /// No description provided for @navFeed.
  ///
  /// In uz, this message translates to:
  /// **'Lenta'**
  String get navFeed;

  /// No description provided for @navMunozara.
  ///
  /// In uz, this message translates to:
  /// **'Munozara'**
  String get navMunozara;

  /// No description provided for @navCreate.
  ///
  /// In uz, this message translates to:
  /// **'Yaratish'**
  String get navCreate;

  /// No description provided for @navProfile.
  ///
  /// In uz, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @createPhoto.
  ///
  /// In uz, this message translates to:
  /// **'Rasm yoki video'**
  String get createPhoto;

  /// No description provided for @createText.
  ///
  /// In uz, this message translates to:
  /// **'Matn (munozara)'**
  String get createText;

  /// No description provided for @createTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nima yaratamiz?'**
  String get createTitle;

  /// No description provided for @repost.
  ///
  /// In uz, this message translates to:
  /// **'Repost'**
  String get repost;

  /// No description provided for @repostDone.
  ///
  /// In uz, this message translates to:
  /// **'Repost qilindi'**
  String get repostDone;

  /// No description provided for @repostRemoved.
  ///
  /// In uz, this message translates to:
  /// **'Repost olib tashlandi'**
  String get repostRemoved;

  /// No description provided for @repostedLabel.
  ///
  /// In uz, this message translates to:
  /// **'Repost qildingiz'**
  String get repostedLabel;

  /// No description provided for @repostedFrom.
  ///
  /// In uz, this message translates to:
  /// **'reblog'**
  String get repostedFrom;

  /// No description provided for @share.
  ///
  /// In uz, this message translates to:
  /// **'Ulashish'**
  String get share;

  /// No description provided for @munozaraTitle.
  ///
  /// In uz, this message translates to:
  /// **'Munozara'**
  String get munozaraTitle;

  /// No description provided for @munozaraEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hali munozara yoʻq. Birinchi boʻlib yozing!'**
  String get munozaraEmpty;

  /// No description provided for @munozaraReply.
  ///
  /// In uz, this message translates to:
  /// **'Javob berish'**
  String get munozaraReply;

  /// No description provided for @munozaraNew.
  ///
  /// In uz, this message translates to:
  /// **'Yangi munozara'**
  String get munozaraNew;

  /// No description provided for @profileTabPosts.
  ///
  /// In uz, this message translates to:
  /// **'Postlar'**
  String get profileTabPosts;

  /// No description provided for @profileTabReposts.
  ///
  /// In uz, this message translates to:
  /// **'Repostlar'**
  String get profileTabReposts;

  /// No description provided for @profileTabChronicle.
  ///
  /// In uz, this message translates to:
  /// **'Solnoma'**
  String get profileTabChronicle;

  /// No description provided for @profileHighlights.
  ///
  /// In uz, this message translates to:
  /// **'Ajratilgan'**
  String get profileHighlights;

  /// No description provided for @profileNoPosts.
  ///
  /// In uz, this message translates to:
  /// **'Hali post yoʻq'**
  String get profileNoPosts;

  /// No description provided for @profileNoReposts.
  ///
  /// In uz, this message translates to:
  /// **'Hali repost yoʻq'**
  String get profileNoReposts;

  /// No description provided for @feedPhotosEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hali surat yoʻq. Birinchi suratni joylang!'**
  String get feedPhotosEmpty;

  /// No description provided for @gamesHubTitle.
  ///
  /// In uz, this message translates to:
  /// **'Oʻyinlar'**
  String get gamesHubTitle;

  /// No description provided for @gamesHubLead.
  ///
  /// In uz, this message translates to:
  /// **'Bilim uchun bellash, sinf bilan reytingda yuqoriga chiq'**
  String get gamesHubLead;

  /// No description provided for @gamesBattle.
  ///
  /// In uz, this message translates to:
  /// **'Sinf bellashuvi'**
  String get gamesBattle;

  /// No description provided for @gamesBattleDesc.
  ///
  /// In uz, this message translates to:
  /// **'Bilim boʻyicha tezkor bellashuv'**
  String get gamesBattleDesc;

  /// No description provided for @gamesLeague.
  ///
  /// In uz, this message translates to:
  /// **'Reyting'**
  String get gamesLeague;

  /// No description provided for @gamesLeagueDesc.
  ///
  /// In uz, this message translates to:
  /// **'Sinf va maktab reytingi'**
  String get gamesLeagueDesc;

  /// No description provided for @gamesQuiz.
  ///
  /// In uz, this message translates to:
  /// **'Tezkor viktorina'**
  String get gamesQuiz;

  /// No description provided for @gamesQuizDesc.
  ///
  /// In uz, this message translates to:
  /// **'10 ta savol, vaqtga qarshi'**
  String get gamesQuizDesc;

  /// No description provided for @gamesQuizStart.
  ///
  /// In uz, this message translates to:
  /// **'Boshlash'**
  String get gamesQuizStart;

  /// No description provided for @gamesQuizNext.
  ///
  /// In uz, this message translates to:
  /// **'Keyingi'**
  String get gamesQuizNext;

  /// No description provided for @gamesQuizResult.
  ///
  /// In uz, this message translates to:
  /// **'Natija'**
  String get gamesQuizResult;

  /// No description provided for @gamesQuizAgain.
  ///
  /// In uz, this message translates to:
  /// **'Yana bir bor'**
  String get gamesQuizAgain;

  /// No description provided for @gamesScore.
  ///
  /// In uz, this message translates to:
  /// **'Ball'**
  String get gamesScore;

  /// No description provided for @boardClassHub.
  ///
  /// In uz, this message translates to:
  /// **'Sinf faoliyati'**
  String get boardClassHub;

  /// No description provided for @gamesQuizClose.
  ///
  /// In uz, this message translates to:
  /// **'Yopish'**
  String get gamesQuizClose;

  /// No description provided for @gamesQuizQuestion.
  ///
  /// In uz, this message translates to:
  /// **'Savol'**
  String get gamesQuizQuestion;

  /// No description provided for @accountsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Akkauntlar'**
  String get accountsTitle;

  /// No description provided for @accountSwitch.
  ///
  /// In uz, this message translates to:
  /// **'Akkauntni almashtirish'**
  String get accountSwitch;

  /// No description provided for @accountSwitched.
  ///
  /// In uz, this message translates to:
  /// **'Akkaunt almashtirildi'**
  String get accountSwitched;

  /// No description provided for @follow.
  ///
  /// In uz, this message translates to:
  /// **'Kuzatish'**
  String get follow;

  /// No description provided for @following.
  ///
  /// In uz, this message translates to:
  /// **'Kuzatilmoqda'**
  String get following;

  /// No description provided for @statPosts.
  ///
  /// In uz, this message translates to:
  /// **'postlar'**
  String get statPosts;

  /// No description provided for @statFollowers.
  ///
  /// In uz, this message translates to:
  /// **'obunachilar'**
  String get statFollowers;

  /// No description provided for @statFollowing.
  ///
  /// In uz, this message translates to:
  /// **'obunalar'**
  String get statFollowing;

  /// No description provided for @profileSaved.
  ///
  /// In uz, this message translates to:
  /// **'Saqlangan'**
  String get profileSaved;

  /// No description provided for @profileNoSaved.
  ///
  /// In uz, this message translates to:
  /// **'Hali saqlangan post yoʻq'**
  String get profileNoSaved;

  /// No description provided for @activityTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnomalar'**
  String get activityTitle;

  /// No description provided for @activityEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hali bildirishnoma yoʻq'**
  String get activityEmpty;

  /// No description provided for @searchTitle.
  ///
  /// In uz, this message translates to:
  /// **'Qidirish'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In uz, this message translates to:
  /// **'Qidirish'**
  String get searchHint;

  /// No description provided for @searchEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hech narsa topilmadi'**
  String get searchEmpty;

  /// No description provided for @likesCount.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta yoqtirish'**
  String likesCount(int count);
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['kaa', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'uz':
      {
        switch (locale.scriptCode) {
          case 'Cyrl':
            return AppL10nUzCyrl();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'kaa':
      return AppL10nKaa();
    case 'ru':
      return AppL10nRu();
    case 'uz':
      return AppL10nUz();
  }

  throw FlutterError(
      'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
