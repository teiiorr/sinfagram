// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppL10nUz extends AppL10n {
  AppL10nUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Sinfagram';

  @override
  String get actionContinue => 'Davom etish';

  @override
  String get actionRetry => 'Qayta urinish';

  @override
  String get actionSend => 'Yuborish';

  @override
  String get actionCancel => 'Bekor qilish';

  @override
  String get actionEdit => 'Tahrirlash';

  @override
  String get actionUnderstood => 'Tushundim';

  @override
  String get navClass => 'Sinf';

  @override
  String get navGames => 'Oʻyin';

  @override
  String get navChronicle => 'Solnoma';

  @override
  String get navMe => 'Men';

  @override
  String get emptyTitle => 'Hozircha boʻsh';

  @override
  String get emptyBody => 'Bu yerda hali maʼlumot yoʻq.';

  @override
  String get errorTitle => 'Xatolik yuz berdi';

  @override
  String get errorBody => 'Qayta urinib koʻring.';

  @override
  String get bannerOffline =>
      'Oflayn — koʻrsatilayotgan maʼlumot eski boʻlishi mumkin';

  @override
  String get localeTitle => 'Til va yozuv';

  @override
  String get localeUzLatn => 'Oʻzbekcha (lotin)';

  @override
  String get localeUzCyrl => 'Ўзбекча (кирилл)';

  @override
  String get localeRu => 'Русский';

  @override
  String get localeKaa => 'Qaraqalpaqsha';

  @override
  String get roleTitle => 'Kim sifatida kirasiz?';

  @override
  String get rolePupil => 'Men oʻquvchiman';

  @override
  String get rolePupilSub => 'Sinf kodi bilan oʻz sinfingizga kirasiz.';

  @override
  String get roleTeacher => 'Men oʻqituvchiman';

  @override
  String get roleTeacherSub => 'Sinf yaratasiz va roʻyxatni tasdiqlaysiz.';

  @override
  String get roleParent => 'Men ota-onaman';

  @override
  String get roleParentSub => 'Farzandingiz faoliyatini kuzatasiz.';

  @override
  String get codeTitle => 'Oʻqituvchingiz bergan kodni kiriting';

  @override
  String get codeHelp => 'Kod yoʻqmi? Sinf rahbaringizga murojaat qiling.';

  @override
  String get codeError => 'Kod notoʻgʻri. Qayta tekshiring.';

  @override
  String get rosterTitle => 'Ismingizni tanlang';

  @override
  String get rosterSearch => 'Qidirish';

  @override
  String get rosterConfirmTitle => 'Bu sizmisiz?';

  @override
  String get pinTitle => 'PIN kod oʻrnating';

  @override
  String get pinRepeat => 'PIN kodni takrorlang';

  @override
  String get pinHint => 'Bu PIN faqat shu qurilma uchun.';

  @override
  String get pinMismatch => 'PIN kodlar mos kelmadi.';

  @override
  String get consentTitle => 'Ota-ona tasdigʻi kutilmoqda';

  @override
  String get consentBody =>
      'Ota-onangiz roziligini bergach, sinfga kira olasiz.';

  @override
  String get consentResend => 'Soʻrovni qayta yuborish';

  @override
  String get visibilityTitle => 'Ota-onangiz nimani koʻradi';

  @override
  String get visibilitySees => 'Ota-onangiz koʻradi';

  @override
  String get visibilitySeesItems =>
      'Siz eʼlon qilgan postlar\nFaollik kunlari va vaqti\nSinfdagi shikoyatlar natijasi';

  @override
  String get visibilityNotSees => 'Ota-onangiz koʻrmaydi';

  @override
  String get visibilityNotItems =>
      'Shaxsiy xabarlaringiz (ular umuman yoʻq)\nKimga rahmat berganingiz\nQaysi postlarni oʻqiganingiz';

  @override
  String get dayComposerEntry => 'Nima boʻldi bugun?';

  @override
  String get dayComplete => 'Bugungisi tugadi';

  @override
  String get dayCompleteSub => 'Ertaga yana koʻrishamiz.';

  @override
  String get dayPrevious => 'Kechagi kunni koʻrish';

  @override
  String get dayEmpty =>
      'Bugun hali hech narsa yoʻq. Birinchi boʻlishingiz mumkin.';

  @override
  String get thanks => 'Rahmat';

  @override
  String get report => 'Shikoyat';

  @override
  String comments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Izoh $count',
      zero: 'Izoh yoʻq',
    );
    return '$_temp0';
  }

  @override
  String get composeTitle => 'Yangi post';

  @override
  String get composeHint => 'Nima boʻldi bugun?';

  @override
  String get composePost => 'Joylash';

  @override
  String get composePhoto => 'Rasm qoʻshish';

  @override
  String get composeReview => 'Bu post koʻrib chiqilmoqda';

  @override
  String get meThanksTitle => 'Sizning rahmatlaringiz';

  @override
  String get meThanksPrivate => 'Buni faqat siz va ota-onangiz koʻradi.';

  @override
  String get meTimeToday => 'Bugun ilovada';

  @override
  String get meSettings => 'Sozlamalar';

  @override
  String get meAbout => 'Ilova haqida';

  @override
  String get meSignOut => 'Chiqish';

  @override
  String get gamesTitle => 'Oʻyin';

  @override
  String get gamesEmpty => 'Hozircha bellashuv yoʻq. Keyingisi tez orada.';

  @override
  String get chronicleTitle => 'Sinf solnomasi';

  @override
  String get chronicleEmpty => 'Birinchi bob shu oyda yigʻiladi.';

  @override
  String get boardTitle => 'Maktab taxtasi';

  @override
  String get settingsTitle => 'Sozlamalar';

  @override
  String get settingsLanguage => 'Til va yozuv';

  @override
  String get settingsDarkMode => 'Tungi tema';

  @override
  String get settingsSignOut => 'Chiqish';

  @override
  String get aboutTitle => 'Ilova haqida';

  @override
  String get aboutVersion => 'Versiya';

  @override
  String get aboutMinistry => 'Maktabgacha va maktab taʼlimi vazirligi';

  @override
  String get chalkTitle => 'Bugun sinfda';

  @override
  String get chalkNote => 'Bilim — kelajak kaliti';

  @override
  String get storyYou => 'Siz';

  @override
  String get storyAdd => 'Hikoya qoʻshish';

  @override
  String get storyAdded => 'Hikoyangiz qoʻshildi';

  @override
  String get feedFriendsNow => 'Doʻstlar nima yozdi';

  @override
  String get meReading => 'Hozir oʻqiyapman';

  @override
  String get meListening => 'Hozir tinglayapman';

  @override
  String get meInterests => 'Qiziqishlar';

  @override
  String get meBio => 'Men haqimda';

  @override
  String get meEditProfile => 'Profilni tahrirlash';

  @override
  String get meEditSaved => 'Profil saqlandi';

  @override
  String get commentsTitle => 'Izohlar';

  @override
  String get commentHint => 'Izoh yozing...';

  @override
  String get commentEmpty => 'Hali izoh yoʻq. Birinchi boʻling.';

  @override
  String get helpTitle => 'Yordam taxtasi';

  @override
  String get helpFilterAll => 'Barchasi';

  @override
  String get helpFilterWaiting => 'Javob kutmoqda';

  @override
  String get helpFilterClosed => 'Yopilgan';

  @override
  String get helpAsk => 'Savol berish';

  @override
  String get helpEmpty => 'Hali savol yoʻq. Birinchi boʻlib soʻrang.';

  @override
  String helpAnswers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta javob',
      zero: 'Javob yoʻq',
    );
    return '$_temp0';
  }

  @override
  String get helpBest => 'Eng yaxshi javob';

  @override
  String get helpMarkBest => 'Eng yaxshi deb belgilash';

  @override
  String get helpAnswerHint => 'Javobingiz...';

  @override
  String get helpAnswerMin => 'Kamida 40 belgi kerak';

  @override
  String get helpAskTitle => 'Savol berish';

  @override
  String get helpQuestionHint => 'Savolingizni yozing';

  @override
  String get helpSubject => 'Fan';

  @override
  String get boardSchedule => 'Dars jadvali';

  @override
  String get boardHomework => 'Uy vazifasi';

  @override
  String get boardAnnouncements => 'Eʼlonlar';

  @override
  String get boardLostFound => 'Yoʻqolgan buyumlar';

  @override
  String get boardNow => 'Hozir';

  @override
  String get reportTitle => 'Shikoyat';

  @override
  String get reportReasonBullying => 'Bulling / kamsitish';

  @override
  String get reportReasonOffensive => 'Ogʻzaki haqorat';

  @override
  String get reportReasonSpam => 'Spam / reklama';

  @override
  String get reportReasonOther => 'Boshqa';

  @override
  String get reportNoteHint => 'Izoh (ixtiyoriy)';

  @override
  String get reportWhoSees =>
      'Buni faqat sinf rahbaringiz koʻradi. Kim shikoyat qilgani oshkor etilmaydi.';

  @override
  String get reportSent => 'Shikoyatingiz yuborildi';

  @override
  String get gameActiveBattle => 'Faol bellashuv';

  @override
  String get gameOpponent => 'Raqib';

  @override
  String get gameSubject => 'Fan';

  @override
  String get gameStart => 'Boshlash';

  @override
  String get gameCannotPause => 'Boshlangach, toʻxtatib boʻlmaydi.';

  @override
  String gamePlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oʻquvchi qatnashdi',
      zero: 'Hali hech kim qatnashmadi',
    );
    return '$_temp0';
  }

  @override
  String get gameLeagueSection => 'Liga';

  @override
  String gameRankValue(int count) {
    return '$count-oʻrin';
  }

  @override
  String gamePointsValue(int count) {
    return '$count ball';
  }

  @override
  String get gameChallengeSection => 'Haftalik chaqiriq';

  @override
  String gameDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kun qoldi',
    );
    return '$_temp0';
  }

  @override
  String get battleResultTitle => 'Natija';

  @override
  String get battleYourClass => 'Sizning sinfingiz';

  @override
  String get battleOpponentClass => 'Raqib sinf';

  @override
  String get battleParticipation => 'Qatnashuv';

  @override
  String get battlePerSubject => 'Fanlar boʻyicha';

  @override
  String get battleWin => 'Gʻalaba!';

  @override
  String get battleLose => 'Bu safar boʻlmadi';

  @override
  String get battleDraw => 'Durrang';

  @override
  String get battleNoPupilScore =>
      'Ball butun sinfniki — shaxsiy natija koʻrsatilmaydi.';

  @override
  String get leagueTitle => 'Liga';

  @override
  String get leagueParallel => 'Parallel';

  @override
  String get leagueSchool => 'Maktab';

  @override
  String get leagueDistrict => 'Tuman';

  @override
  String get leagueRegion => 'Viloyat';

  @override
  String get leagueColClass => 'Sinf';

  @override
  String get leagueColPlayed => 'Oʻyinlar';

  @override
  String get leagueColPoints => 'Ball';

  @override
  String get leagueEmpty => 'Mavsum hali boshlanmadi';

  @override
  String get chronicleSealed => 'Muhrlangan';

  @override
  String chronicleItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta element',
      zero: 'Element yoʻq',
    );
    return '$_temp0';
  }

  @override
  String chronicleDaysToSeal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kundan soʻng muhrlanadi',
    );
    return '$_temp0';
  }

  @override
  String get chapterSealedNote => 'Bu bob muhrlangan — faqat koʻrish uchun.';

  @override
  String get chapterEmpty => 'Bu bobda hali element yoʻq.';

  @override
  String get nightTitle => 'Tungi rejim';

  @override
  String nightBody(String time) {
    return 'Sinf tunda dam oladi. Ertalab $time da yana ochiladi.';
  }

  @override
  String get nightToBoard => 'Maktab taxtasiga oʻtish';

  @override
  String get lessonTitle => 'Dars rejimi';

  @override
  String lessonBody(String time) {
    return 'Hozir dars vaqti. Dars $time da tugaydi.';
  }

  @override
  String get lessonToBoard => 'Jadval va uy vazifasi';

  @override
  String get settingsMode => 'Rejim (demo)';

  @override
  String get modeNormal => 'Oddiy';

  @override
  String get modeNight => 'Tungi';

  @override
  String get modeLesson => 'Dars';

  @override
  String get tNavClasses => 'Sinflar';

  @override
  String get tNavCases => 'Murojaatlar';

  @override
  String tClassJoined(int joined, int total) {
    return '$joined/$total oʻquvchi qoʻshildi';
  }

  @override
  String tOpenCases(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ochiq murojaat',
      zero: 'Ochiq murojaat yoʻq',
    );
    return '$_temp0';
  }

  @override
  String get tCasesEmpty => 'Ochiq murojaat yoʻq — bu yaxshi holat.';

  @override
  String get tCaseOverdue => 'Muddati oʻtgan';

  @override
  String tCaseDue(String time) {
    return 'Muddat: $time';
  }

  @override
  String get tCaseEvidence => 'Dalil';

  @override
  String get tCaseHistory => 'Tarix';

  @override
  String get tCaseActionHide => 'Yashirish';

  @override
  String get tCaseActionMute => '24 soatga ovozsiz';

  @override
  String get tCaseActionEscalate => 'Yuqoriga uzatish';

  @override
  String get tCaseActionDismiss => 'Rad etish';

  @override
  String get tCaseNoteHint => 'Izoh yozing (majburiy)';

  @override
  String get tCaseResolved => 'Ish yopildi';

  @override
  String get tCaseAnonymous => 'Shikoyatchi kim ekani oshkor etilmaydi.';

  @override
  String get tGamesSchedule => 'Bellashuv rejalashtirish';

  @override
  String get tGamesSoon => 'Rejalashtirish tez orada.';

  @override
  String get pNavChild => 'Bolam';

  @override
  String get pNavMessages => 'Xabarlar';

  @override
  String get pDigestTitle => 'Haftalik xulosa';

  @override
  String pActiveDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kun faol boʻldi',
    );
    return '$_temp0';
  }

  @override
  String pMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count daqiqa',
    );
    return '$_temp0';
  }

  @override
  String pPublishedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta post joyladi',
      zero: 'Post joylamadi',
    );
    return '$_temp0';
  }

  @override
  String pThanksReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta rahmat oldi',
    );
    return '$_temp0';
  }

  @override
  String get pChildContent => 'Farzandingiz postlari';

  @override
  String get pChildContentEmpty => 'Hali post yoʻq.';

  @override
  String get pCases => 'Shikoyatlar';

  @override
  String get pCasesEmpty => 'Farzandingizga oid shikoyat yoʻq.';

  @override
  String get pControls => 'Boshqaruv';

  @override
  String get pTimeLimit => 'Kunlik vaqt chegarasi';

  @override
  String get pNotifs => 'Bildirishnomalar';

  @override
  String get pConsentData => 'Rozilik va maʼlumotlar';

  @override
  String get pConsentGranted => 'Rozilik berilgan';

  @override
  String get pCollected => 'Yigʻiladigan maʼlumotlar';

  @override
  String get pNotCollected => 'Yigʻilmaydigan maʼlumotlar';

  @override
  String get pExport => 'Maʼlumotlarni yuklab olish';

  @override
  String get pDelete => 'Hisobni oʻchirish';

  @override
  String get pNoLiveFeed =>
      'Jonli faoliyat lentasi va “onlayn” koʻrsatkichi yoʻq. Bu bolaning ishonchini saqlaydi.';

  @override
  String get pMessagesEmpty => 'Hozircha xabar yoʻq.';

  @override
  String get pMessageTeacher => 'Oʻqituvchiga xabar';

  @override
  String get rolesTitle => 'Sinf rollari';

  @override
  String get rolesThisWeek => 'Shu hafta';

  @override
  String get rolesRotation => 'Navbat tartibi';

  @override
  String get wallTitle => 'Umumiy devor';

  @override
  String wallContributors(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta hissa qoʻshildi',
    );
    return '$_temp0';
  }

  @override
  String get wallAdd => 'Belgi qoʻshish';

  @override
  String get wallDone => 'Siz hissa qoʻshdingiz';

  @override
  String get challengeScreenTitle => 'Haftalik chaqiriq';

  @override
  String challengeDeadline(String date) {
    return 'Muddat: $date';
  }

  @override
  String get challengeSubmit => 'Ishtirok etish';

  @override
  String get challengeEntries => 'Sinf ishlari';

  @override
  String get challengeSubmitted => 'Ishingiz yuborildi';

  @override
  String get capsuleTitle => 'Vaqt kapsulasi';

  @override
  String get capsuleOpenHint => 'Kelajakdagi oʻzingizga xat yozing';

  @override
  String capsuleSeals(String date) {
    return '$date da muhrlanadi';
  }

  @override
  String capsuleSealedOn(String date) {
    return 'Muhrlangan: $date';
  }

  @override
  String capsuleOpensOn(String date) {
    return 'Ochiladi: $date';
  }

  @override
  String capsuleNotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta xat',
    );
    return '$_temp0';
  }

  @override
  String get capsuleWrite => 'Xat yozish';

  @override
  String get capsuleSaved => 'Xatingiz kapsulaga saqlandi';

  @override
  String get tClassDetail => 'Sinf';

  @override
  String get tRoster => 'Roʻyxat';

  @override
  String get tGenerateCode => 'Kod yaratish';

  @override
  String get tProjectGroups => 'Loyiha guruhlari';

  @override
  String get tImportTitle => 'Roʻyxatni import qilish';

  @override
  String get tImportManual => 'Qoʻlda qoʻshish';

  @override
  String get tImportCsv => 'CSV yuklash';

  @override
  String get tImportChanges => 'Oʻzgarishlar';

  @override
  String get tImportApply => 'Qoʻllash';

  @override
  String get tCodeTitle => 'Sinf kodi';

  @override
  String get tCodePrint => 'A5 chop etish';

  @override
  String get tCodeShareNote => 'Bu kodni faqat oʻz oʻquvchilaringizga bering.';

  @override
  String get tAnnounceTitle => 'Eʼlon';

  @override
  String get tAnnounceScope => 'Koʻrinish';

  @override
  String get tScopeClass => 'Sinf';

  @override
  String get tScopeSchool => 'Maktab';

  @override
  String get tAnnounceHint => 'Eʼlon matni';

  @override
  String get tAnnouncePin => 'Yuqoriga mahkamlash';

  @override
  String get tAnnouncePost => 'Joylash';

  @override
  String get tAnnouncePosted => 'Eʼlon joylandi';

  @override
  String get tScheduleTitle => 'Bellashuv rejalashtirish';

  @override
  String get tPickOpponent => 'Raqib sinf';

  @override
  String get tPickSubject => 'Fan';

  @override
  String get tPickWindow => 'Vaqt oraligʻi';

  @override
  String get tScheduleConfirm => 'Rejalashtirish';

  @override
  String get tScheduled => 'Bellashuv rejalashtirildi';

  @override
  String get tChannelTitle => 'Sinf kanali';

  @override
  String get tChannelNote => 'Bu kanal butun sinfga koʻrinadi — shaxsiy emas.';

  @override
  String get tChronicleAdmin => 'Solnoma boshqaruvi';

  @override
  String get tSetCover => 'Muqovani belgilash';

  @override
  String get tSeal => 'Muhrlash';

  @override
  String get tExportPdf => 'PDF eksport';

  @override
  String get meReadingHint => 'Qaysi kitobni oʻqiyapsiz?';

  @override
  String get meListeningHint => 'Qanday musiqa tinglayapsiz?';

  @override
  String get meBioHint => 'Oʻzingiz haqingizda qisqacha';

  @override
  String get meEmpty => 'Hali toʻldirilmagan';

  @override
  String get meSave => 'Saqlash';

  @override
  String get classmatesTitle => 'Sinfdoshlar';

  @override
  String get classmatesOpen => 'Sinfdoshlarni koʻrish';

  @override
  String get classmatesSubtitle => 'Sinfingizdagi doʻstlar';

  @override
  String get personReading => 'Oʻqiyapti';

  @override
  String get personListening => 'Tinglayapti';

  @override
  String get personInterests => 'Qiziqishlar';

  @override
  String get personBio => 'Bio';

  @override
  String get personPhotos => 'Suratlar';

  @override
  String get personNoInfo => 'Hozircha maʼlumot yoʻq';

  @override
  String get composeVideo => 'Video';

  @override
  String get navFeed => 'Lenta';

  @override
  String get navMunozara => 'Munozara';

  @override
  String get navCreate => 'Yaratish';

  @override
  String get navProfile => 'Profil';

  @override
  String get createPhoto => 'Rasm yoki video';

  @override
  String get createText => 'Matn (munozara)';

  @override
  String get createTitle => 'Nima yaratamiz?';

  @override
  String get repost => 'Repost';

  @override
  String get repostDone => 'Repost qilindi';

  @override
  String get repostRemoved => 'Repost olib tashlandi';

  @override
  String get repostedLabel => 'Repost qildingiz';

  @override
  String get repostedFrom => 'reblog';

  @override
  String get share => 'Ulashish';

  @override
  String get munozaraTitle => 'Munozara';

  @override
  String get munozaraEmpty => 'Hali munozara yoʻq. Birinchi boʻlib yozing!';

  @override
  String get munozaraReply => 'Javob berish';

  @override
  String get munozaraNew => 'Yangi munozara';

  @override
  String get profileTabPosts => 'Postlar';

  @override
  String get profileTabReposts => 'Repostlar';

  @override
  String get profileTabChronicle => 'Solnoma';

  @override
  String get profileHighlights => 'Ajratilgan';

  @override
  String get profileNoPosts => 'Hali post yoʻq';

  @override
  String get profileNoReposts => 'Hali repost yoʻq';

  @override
  String get feedPhotosEmpty => 'Hali surat yoʻq. Birinchi suratni joylang!';

  @override
  String get gamesHubTitle => 'Oʻyinlar';

  @override
  String get gamesHubLead =>
      'Bilim uchun bellash, sinf bilan reytingda yuqoriga chiq';

  @override
  String get gamesBattle => 'Sinf bellashuvi';

  @override
  String get gamesBattleDesc => 'Bilim boʻyicha tezkor bellashuv';

  @override
  String get gamesLeague => 'Reyting';

  @override
  String get gamesLeagueDesc => 'Sinf va maktab reytingi';

  @override
  String get gamesQuiz => 'Tezkor viktorina';

  @override
  String get gamesQuizDesc => '10 ta savol, vaqtga qarshi';

  @override
  String get gamesQuizStart => 'Boshlash';

  @override
  String get gamesQuizNext => 'Keyingi';

  @override
  String get gamesQuizResult => 'Natija';

  @override
  String get gamesQuizAgain => 'Yana bir bor';

  @override
  String get gamesScore => 'Ball';

  @override
  String get boardClassHub => 'Sinf faoliyati';

  @override
  String get gamesQuizClose => 'Yopish';

  @override
  String get gamesQuizQuestion => 'Savol';

  @override
  String get accountsTitle => 'Akkauntlar';

  @override
  String get accountSwitch => 'Akkauntni almashtirish';

  @override
  String get accountSwitched => 'Akkaunt almashtirildi';

  @override
  String get follow => 'Kuzatish';

  @override
  String get following => 'Kuzatilmoqda';

  @override
  String get statPosts => 'postlar';

  @override
  String get statFollowers => 'obunachilar';

  @override
  String get statFollowing => 'obunalar';

  @override
  String get profileSaved => 'Saqlangan';

  @override
  String get profileNoSaved => 'Hali saqlangan post yoʻq';

  @override
  String get activityTitle => 'Bildirishnomalar';

  @override
  String get activityEmpty => 'Hali bildirishnoma yoʻq';

  @override
  String get searchTitle => 'Qidirish';

  @override
  String get searchHint => 'Qidirish';

  @override
  String get searchEmpty => 'Hech narsa topilmadi';

  @override
  String likesCount(int count) {
    return '$count ta yoqtirish';
  }
}

/// The translations for Uzbek, using the Cyrillic script (`uz_Cyrl`).
class AppL10nUzCyrl extends AppL10nUz {
  AppL10nUzCyrl() : super('uz_Cyrl');

  @override
  String get appTitle => 'Sinfagram';

  @override
  String get actionContinue => 'Давом этиш';

  @override
  String get actionRetry => 'Қайта уриниш';

  @override
  String get actionSend => 'Юбориш';

  @override
  String get actionCancel => 'Бекор қилиш';

  @override
  String get actionEdit => 'Таҳрирлаш';

  @override
  String get actionUnderstood => 'Тушундим';

  @override
  String get navClass => 'Синф';

  @override
  String get navGames => 'Ўйин';

  @override
  String get navChronicle => 'Солнома';

  @override
  String get navMe => 'Мен';

  @override
  String get emptyTitle => 'Ҳозирча бўш';

  @override
  String get emptyBody => 'Бу ерда ҳали маълумот йўқ.';

  @override
  String get errorTitle => 'Хатолик юз берди';

  @override
  String get errorBody => 'Қайта уриниб кўринг.';

  @override
  String get bannerOffline =>
      'Офлайн — кўрсатилаётган маълумот эски бўлиши мумкин';

  @override
  String get localeTitle => 'Тил ва ёзув';

  @override
  String get localeUzLatn => 'Oʻzbekcha (lotin)';

  @override
  String get localeUzCyrl => 'Ўзбекча (кирилл)';

  @override
  String get localeRu => 'Русский';

  @override
  String get localeKaa => 'Qaraqalpaqsha';

  @override
  String get roleTitle => 'Ким сифатида кирасиз?';

  @override
  String get rolePupil => 'Мен ўқувчиман';

  @override
  String get rolePupilSub => 'Синф коди билан ўз синфингизга кирасиз.';

  @override
  String get roleTeacher => 'Мен ўқитувчиман';

  @override
  String get roleTeacherSub => 'Синф яратасиз ва рўйхатни тасдиқлайсиз.';

  @override
  String get roleParent => 'Мен ота-онаман';

  @override
  String get roleParentSub => 'Фарзандингиз фаолиятини кузатасиз.';

  @override
  String get codeTitle => 'Ўқитувчингиз берган кодни киритинг';

  @override
  String get codeHelp => 'Код йўқми? Синф раҳбарингизга мурожаат қилинг.';

  @override
  String get codeError => 'Код нотўғри. Қайта текширинг.';

  @override
  String get rosterTitle => 'Исмингизни танланг';

  @override
  String get rosterSearch => 'Қидириш';

  @override
  String get rosterConfirmTitle => 'Бу сизмисиз?';

  @override
  String get pinTitle => 'PIN код ўрнатинг';

  @override
  String get pinRepeat => 'PIN кодни такрорланг';

  @override
  String get pinHint => 'Бу PIN фақат шу қурилма учун.';

  @override
  String get pinMismatch => 'PIN кодлар мос келмади.';

  @override
  String get consentTitle => 'Ота-она тасдиғи кутилмоқда';

  @override
  String get consentBody =>
      'Ота-онангиз розилигини бергач, синфга кира оласиз.';

  @override
  String get consentResend => 'Сўровни қайта юбориш';

  @override
  String get visibilityTitle => 'Ота-онангиз нимани кўради';

  @override
  String get visibilitySees => 'Ота-онангиз кўради';

  @override
  String get visibilitySeesItems =>
      'Сиз эълон қилган постлар\nФаоллик кунлари ва вақти\nСинфдаги шикоятлар натижаси';

  @override
  String get visibilityNotSees => 'Ота-онангиз кўрмайди';

  @override
  String get visibilityNotItems =>
      'Шахсий хабарларингиз (улар умуман йўқ)\nКимга раҳмат берганингиз\nҚайси постларни ўқиганингиз';

  @override
  String get dayComposerEntry => 'Нима бўлди бугун?';

  @override
  String get dayComplete => 'Бугунгиси тугади';

  @override
  String get dayCompleteSub => 'Эртага яна кўришамиз.';

  @override
  String get dayPrevious => 'Кечаги кунни кўриш';

  @override
  String get dayEmpty => 'Бугун ҳали ҳеч нарса йўқ. Биринчи бўлишингиз мумкин.';

  @override
  String get thanks => 'Раҳмат';

  @override
  String get report => 'Шикоят';

  @override
  String comments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изоҳ $count',
      zero: 'Изоҳ йўқ',
    );
    return '$_temp0';
  }

  @override
  String get composeTitle => 'Янги пост';

  @override
  String get composeHint => 'Нима бўлди бугун?';

  @override
  String get composePost => 'Жойлаш';

  @override
  String get composePhoto => 'Расм қўшиш';

  @override
  String get composeReview => 'Бу пост кўриб чиқилмоқда';

  @override
  String get meThanksTitle => 'Сизнинг раҳматларингиз';

  @override
  String get meThanksPrivate => 'Буни фақат сиз ва ота-онангиз кўради.';

  @override
  String get meTimeToday => 'Бугун иловада';

  @override
  String get meSettings => 'Созламалар';

  @override
  String get meAbout => 'Илова ҳақида';

  @override
  String get meSignOut => 'Чиқиш';

  @override
  String get gamesTitle => 'Ўйин';

  @override
  String get gamesEmpty => 'Ҳозирча беллашув йўқ. Кейингиси тез орада.';

  @override
  String get chronicleTitle => 'Синф солномаси';

  @override
  String get chronicleEmpty => 'Биринчи боб шу ойда йиғилади.';

  @override
  String get boardTitle => 'Мактаб тахтаси';

  @override
  String get settingsTitle => 'Созламалар';

  @override
  String get settingsLanguage => 'Тил ва ёзув';

  @override
  String get settingsDarkMode => 'Тунги тема';

  @override
  String get settingsSignOut => 'Чиқиш';

  @override
  String get aboutTitle => 'Илова ҳақида';

  @override
  String get aboutVersion => 'Версия';

  @override
  String get aboutMinistry => 'Мактабгача ва мактаб таълими вазирлиги';

  @override
  String get chalkTitle => 'Бугун синфда';

  @override
  String get chalkNote => 'Билим — келажак калити';

  @override
  String get storyYou => 'Сиз';

  @override
  String get storyAdd => 'Ҳикоя қўшиш';

  @override
  String get storyAdded => 'Ҳикоянгиз қўшилди';

  @override
  String get feedFriendsNow => 'Дўстлар нима ёзди';

  @override
  String get meReading => 'Ҳозир ўқияпман';

  @override
  String get meListening => 'Ҳозир тинглаяпман';

  @override
  String get meInterests => 'Қизиқишлар';

  @override
  String get meBio => 'Мен ҳақимда';

  @override
  String get meEditProfile => 'Профилни таҳрирлаш';

  @override
  String get meEditSaved => 'Профил сақланди';

  @override
  String get commentsTitle => 'Изоҳлар';

  @override
  String get commentHint => 'Изоҳ ёзинг...';

  @override
  String get commentEmpty => 'Ҳали изоҳ йўқ. Биринчи бўлинг.';

  @override
  String get helpTitle => 'Ёрдам тахтаси';

  @override
  String get helpFilterAll => 'Барчаси';

  @override
  String get helpFilterWaiting => 'Жавоб кутмоқда';

  @override
  String get helpFilterClosed => 'Ёпилган';

  @override
  String get helpAsk => 'Савол бериш';

  @override
  String get helpEmpty => 'Ҳали савол йўқ. Биринчи бўлиб сўранг.';

  @override
  String helpAnswers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count та жавоб',
      zero: 'Жавоб йўқ',
    );
    return '$_temp0';
  }

  @override
  String get helpBest => 'Энг яхши жавоб';

  @override
  String get helpMarkBest => 'Энг яхши деб белгилаш';

  @override
  String get helpAnswerHint => 'Жавобингиз...';

  @override
  String get helpAnswerMin => 'Камида 40 белги керак';

  @override
  String get helpAskTitle => 'Савол бериш';

  @override
  String get helpQuestionHint => 'Саволингизни ёзинг';

  @override
  String get helpSubject => 'Фан';

  @override
  String get boardSchedule => 'Дарс жадвали';

  @override
  String get boardHomework => 'Уй вазифаси';

  @override
  String get boardAnnouncements => 'Эълонлар';

  @override
  String get boardLostFound => 'Йўқолган буюмлар';

  @override
  String get boardNow => 'Ҳозир';

  @override
  String get reportTitle => 'Шикоят';

  @override
  String get reportReasonBullying => 'Буллинг / камситиш';

  @override
  String get reportReasonOffensive => 'Оғзаки ҳақорат';

  @override
  String get reportReasonSpam => 'Спам / реклама';

  @override
  String get reportReasonOther => 'Бошқа';

  @override
  String get reportNoteHint => 'Изоҳ (ихтиёрий)';

  @override
  String get reportWhoSees =>
      'Буни фақат синф раҳбарингиз кўради. Ким шикоят қилгани ошкор этилмайди.';

  @override
  String get reportSent => 'Шикоятингиз юборилди';

  @override
  String get gameActiveBattle => 'Фаол беллашув';

  @override
  String get gameOpponent => 'Рақиб';

  @override
  String get gameSubject => 'Фан';

  @override
  String get gameStart => 'Бошлаш';

  @override
  String get gameCannotPause => 'Бошлангач, тўхтатиб бўлмайди.';

  @override
  String gamePlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ўқувчи қатнашди',
      zero: 'Ҳали ҳеч ким қатнашмади',
    );
    return '$_temp0';
  }

  @override
  String get gameLeagueSection => 'Лига';

  @override
  String gameRankValue(int count) {
    return '$count-ўрин';
  }

  @override
  String gamePointsValue(int count) {
    return '$count балл';
  }

  @override
  String get gameChallengeSection => 'Ҳафталик чақириқ';

  @override
  String gameDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count кун қолди',
    );
    return '$_temp0';
  }

  @override
  String get battleResultTitle => 'Натижа';

  @override
  String get battleYourClass => 'Сизнинг синфингиз';

  @override
  String get battleOpponentClass => 'Рақиб синф';

  @override
  String get battleParticipation => 'Қатнашув';

  @override
  String get battlePerSubject => 'Фанлар бўйича';

  @override
  String get battleWin => 'Ғалаба!';

  @override
  String get battleLose => 'Бу сафар бўлмади';

  @override
  String get battleDraw => 'Дуранг';

  @override
  String get battleNoPupilScore =>
      'Балл бутун синфники — шахсий натижа кўрсатилмайди.';

  @override
  String get leagueTitle => 'Лига';

  @override
  String get leagueParallel => 'Параллел';

  @override
  String get leagueSchool => 'Мактаб';

  @override
  String get leagueDistrict => 'Туман';

  @override
  String get leagueRegion => 'Вилоят';

  @override
  String get leagueColClass => 'Синф';

  @override
  String get leagueColPlayed => 'Ўйинлар';

  @override
  String get leagueColPoints => 'Балл';

  @override
  String get leagueEmpty => 'Мавсум ҳали бошланмади';

  @override
  String get chronicleSealed => 'Муҳрланган';

  @override
  String chronicleItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count та элемент',
      zero: 'Элемент йўқ',
    );
    return '$_temp0';
  }

  @override
  String chronicleDaysToSeal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count кундан сўнг муҳрланади',
    );
    return '$_temp0';
  }

  @override
  String get chapterSealedNote => 'Бу боб муҳрланган — фақат кўриш учун.';

  @override
  String get chapterEmpty => 'Бу бобда ҳали элемент йўқ.';

  @override
  String get nightTitle => 'Тунги режим';

  @override
  String nightBody(String time) {
    return 'Синф тунда дам олади. Эрталаб $time да яна очилади.';
  }

  @override
  String get nightToBoard => 'Мактаб тахтасига ўтиш';

  @override
  String get lessonTitle => 'Дарс режими';

  @override
  String lessonBody(String time) {
    return 'Ҳозир дарс вақти. Дарс $time да тугайди.';
  }

  @override
  String get lessonToBoard => 'Жадвал ва уй вазифаси';

  @override
  String get settingsMode => 'Режим (демо)';

  @override
  String get modeNormal => 'Оддий';

  @override
  String get modeNight => 'Тунги';

  @override
  String get modeLesson => 'Дарс';

  @override
  String get tNavClasses => 'Синфлар';

  @override
  String get tNavCases => 'Мурожаатлар';

  @override
  String tClassJoined(int joined, int total) {
    return '$joined/$total ўқувчи қўшилди';
  }

  @override
  String tOpenCases(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count очиқ мурожаат',
      zero: 'Очиқ мурожаат йўқ',
    );
    return '$_temp0';
  }

  @override
  String get tCasesEmpty => 'Очиқ мурожаат йўқ — бу яхши ҳолат.';

  @override
  String get tCaseOverdue => 'Муддати ўтган';

  @override
  String tCaseDue(String time) {
    return 'Муддат: $time';
  }

  @override
  String get tCaseEvidence => 'Далил';

  @override
  String get tCaseHistory => 'Тарих';

  @override
  String get tCaseActionHide => 'Яшириш';

  @override
  String get tCaseActionMute => '24 соатга овозсиз';

  @override
  String get tCaseActionEscalate => 'Юқорига узатиш';

  @override
  String get tCaseActionDismiss => 'Рад этиш';

  @override
  String get tCaseNoteHint => 'Изоҳ ёзинг (мажбурий)';

  @override
  String get tCaseResolved => 'Иш ёпилди';

  @override
  String get tCaseAnonymous => 'Шикоятчи ким экани ошкор этилмайди.';

  @override
  String get tGamesSchedule => 'Беллашув режалаштириш';

  @override
  String get tGamesSoon => 'Режалаштириш тез орада.';

  @override
  String get pNavChild => 'Болам';

  @override
  String get pNavMessages => 'Хабарлар';

  @override
  String get pDigestTitle => 'Ҳафталик хулоса';

  @override
  String pActiveDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count кун фаол бўлди',
    );
    return '$_temp0';
  }

  @override
  String pMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дақиқа',
    );
    return '$_temp0';
  }

  @override
  String pPublishedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count та пост жойлади',
      zero: 'Пост жойламади',
    );
    return '$_temp0';
  }

  @override
  String pThanksReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count та раҳмат олди',
    );
    return '$_temp0';
  }

  @override
  String get pChildContent => 'Фарзандингиз постлари';

  @override
  String get pChildContentEmpty => 'Ҳали пост йўқ.';

  @override
  String get pCases => 'Шикоятлар';

  @override
  String get pCasesEmpty => 'Фарзандингизга оид шикоят йўқ.';

  @override
  String get pControls => 'Бошқарув';

  @override
  String get pTimeLimit => 'Кунлик вақт чегараси';

  @override
  String get pNotifs => 'Билдиришномалар';

  @override
  String get pConsentData => 'Розилик ва маълумотлар';

  @override
  String get pConsentGranted => 'Розилик берилган';

  @override
  String get pCollected => 'Йиғиладиган маълумотлар';

  @override
  String get pNotCollected => 'Йиғилмайдиган маълумотлар';

  @override
  String get pExport => 'Маълумотларни юклаб олиш';

  @override
  String get pDelete => 'Ҳисобни ўчириш';

  @override
  String get pNoLiveFeed =>
      'Жонли фаолият лентаси ва “онлайн” кўрсаткичи йўқ. Бу боланинг ишончини сақлайди.';

  @override
  String get pMessagesEmpty => 'Ҳозирча хабар йўқ.';

  @override
  String get pMessageTeacher => 'Ўқитувчига хабар';

  @override
  String get rolesTitle => 'Синф роллари';

  @override
  String get rolesThisWeek => 'Шу ҳафта';

  @override
  String get rolesRotation => 'Навбат тартиби';

  @override
  String get wallTitle => 'Умумий девор';

  @override
  String wallContributors(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count та ҳисса қўшилди',
    );
    return '$_temp0';
  }

  @override
  String get wallAdd => 'Белги қўшиш';

  @override
  String get wallDone => 'Сиз ҳисса қўшдингиз';

  @override
  String get challengeScreenTitle => 'Ҳафталик чақириқ';

  @override
  String challengeDeadline(String date) {
    return 'Муддат: $date';
  }

  @override
  String get challengeSubmit => 'Иштирок этиш';

  @override
  String get challengeEntries => 'Синф ишлари';

  @override
  String get challengeSubmitted => 'Ишингиз юборилди';

  @override
  String get capsuleTitle => 'Вақт капсуласи';

  @override
  String get capsuleOpenHint => 'Келажакдаги ўзингизга хат ёзинг';

  @override
  String capsuleSeals(String date) {
    return '$date да муҳрланади';
  }

  @override
  String capsuleSealedOn(String date) {
    return 'Муҳрланган: $date';
  }

  @override
  String capsuleOpensOn(String date) {
    return 'Очилади: $date';
  }

  @override
  String capsuleNotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count та хат',
    );
    return '$_temp0';
  }

  @override
  String get capsuleWrite => 'Хат ёзиш';

  @override
  String get capsuleSaved => 'Хатингиз капсулага сақланди';

  @override
  String get tClassDetail => 'Синф';

  @override
  String get tRoster => 'Рўйхат';

  @override
  String get tGenerateCode => 'Код яратиш';

  @override
  String get tProjectGroups => 'Лойиҳа гуруҳлари';

  @override
  String get tImportTitle => 'Рўйхатни импорт қилиш';

  @override
  String get tImportManual => 'Қўлда қўшиш';

  @override
  String get tImportCsv => 'CSV юклаш';

  @override
  String get tImportChanges => 'Ўзгаришлар';

  @override
  String get tImportApply => 'Қўллаш';

  @override
  String get tCodeTitle => 'Синф коди';

  @override
  String get tCodePrint => 'A5 чоп этиш';

  @override
  String get tCodeShareNote => 'Бу кодни фақат ўз ўқувчиларингизга беринг.';

  @override
  String get tAnnounceTitle => 'Эълон';

  @override
  String get tAnnounceScope => 'Кўриниш';

  @override
  String get tScopeClass => 'Синф';

  @override
  String get tScopeSchool => 'Мактаб';

  @override
  String get tAnnounceHint => 'Эълон матни';

  @override
  String get tAnnouncePin => 'Юқорига маҳкамлаш';

  @override
  String get tAnnouncePost => 'Жойлаш';

  @override
  String get tAnnouncePosted => 'Эълон жойланди';

  @override
  String get tScheduleTitle => 'Беллашув режалаштириш';

  @override
  String get tPickOpponent => 'Рақиб синф';

  @override
  String get tPickSubject => 'Фан';

  @override
  String get tPickWindow => 'Вақт оралиғи';

  @override
  String get tScheduleConfirm => 'Режалаштириш';

  @override
  String get tScheduled => 'Беллашув режалаштирилди';

  @override
  String get tChannelTitle => 'Синф канали';

  @override
  String get tChannelNote => 'Бу канал бутун синфга кўринади — шахсий эмас.';

  @override
  String get tChronicleAdmin => 'Солнома бошқаруви';

  @override
  String get tSetCover => 'Муқовани белгилаш';

  @override
  String get tSeal => 'Муҳрлаш';

  @override
  String get tExportPdf => 'PDF экспорт';

  @override
  String get meReadingHint => 'Қайси китобни ўқияпсиз?';

  @override
  String get meListeningHint => 'Қандай мусиқа тинглаяпсиз?';

  @override
  String get meBioHint => 'Ўзингиз ҳақингизда қисқача';

  @override
  String get meEmpty => 'Ҳали тўлдирилмаган';

  @override
  String get meSave => 'Сақлаш';

  @override
  String get classmatesTitle => 'Синфдошлар';

  @override
  String get classmatesOpen => 'Синфдошларни кўриш';

  @override
  String get classmatesSubtitle => 'Синфингиздаги дўстлар';

  @override
  String get personReading => 'Ўқияпти';

  @override
  String get personListening => 'Тинглаяпти';

  @override
  String get personInterests => 'Қизиқишлар';

  @override
  String get personBio => 'Био';

  @override
  String get personPhotos => 'Суратлар';

  @override
  String get personNoInfo => 'Ҳозирча маълумот йўқ';

  @override
  String get composeVideo => 'Видео';

  @override
  String get navFeed => 'Лента';

  @override
  String get navMunozara => 'Мунозара';

  @override
  String get navCreate => 'Яратиш';

  @override
  String get navProfile => 'Профил';

  @override
  String get createPhoto => 'Расм ёки видео';

  @override
  String get createText => 'Матн (мунозара)';

  @override
  String get createTitle => 'Нима яратамиз?';

  @override
  String get repost => 'Репост';

  @override
  String get repostDone => 'Репост қилинди';

  @override
  String get repostRemoved => 'Репост олиб ташланди';

  @override
  String get repostedLabel => 'Репост қилдингиз';

  @override
  String get repostedFrom => 'реблог';

  @override
  String get share => 'Улашиш';

  @override
  String get munozaraTitle => 'Мунозара';

  @override
  String get munozaraEmpty => 'Ҳали мунозара йўқ. Биринчи бўлиб ёзинг!';

  @override
  String get munozaraReply => 'Жавоб бериш';

  @override
  String get munozaraNew => 'Янги мунозара';

  @override
  String get profileTabPosts => 'Постлар';

  @override
  String get profileTabReposts => 'Репостлар';

  @override
  String get profileTabChronicle => 'Солнома';

  @override
  String get profileHighlights => 'Ажратилган';

  @override
  String get profileNoPosts => 'Ҳали пост йўқ';

  @override
  String get profileNoReposts => 'Ҳали репост йўқ';

  @override
  String get feedPhotosEmpty => 'Ҳали сурат йўқ. Биринчи суратни жойланг!';

  @override
  String get gamesHubTitle => 'Ўйинлар';

  @override
  String get gamesHubLead =>
      'Билим учун беллаш, синф билан рейтингда юқорига чиқ';

  @override
  String get gamesBattle => 'Синф беллашуви';

  @override
  String get gamesBattleDesc => 'Билим бўйича тезкор беллашув';

  @override
  String get gamesLeague => 'Рейтинг';

  @override
  String get gamesLeagueDesc => 'Синф ва мактаб рейтинги';

  @override
  String get gamesQuiz => 'Тезкор викторина';

  @override
  String get gamesQuizDesc => '10 та савол, вақтга қарши';

  @override
  String get gamesQuizStart => 'Бошлаш';

  @override
  String get gamesQuizNext => 'Кейинги';

  @override
  String get gamesQuizResult => 'Натижа';

  @override
  String get gamesQuizAgain => 'Яна бир бор';

  @override
  String get gamesScore => 'Балл';

  @override
  String get boardClassHub => 'Синф фаолияти';

  @override
  String get gamesQuizClose => 'Ёпиш';

  @override
  String get gamesQuizQuestion => 'Савол';

  @override
  String get accountsTitle => 'Аккаунтлар';

  @override
  String get accountSwitch => 'Аккаунтни алмаштириш';

  @override
  String get accountSwitched => 'Аккаунт алмаштирилди';

  @override
  String get follow => 'Кузатиш';

  @override
  String get following => 'Кузатилмоқда';

  @override
  String get statPosts => 'постлар';

  @override
  String get statFollowers => 'обуначилар';

  @override
  String get statFollowing => 'обуналар';

  @override
  String get profileSaved => 'Сақланган';

  @override
  String get profileNoSaved => 'Ҳали сақланган пост йўқ';

  @override
  String get activityTitle => 'Билдиришномалар';

  @override
  String get activityEmpty => 'Ҳали билдиришнома йўқ';

  @override
  String get searchTitle => 'Қидириш';

  @override
  String get searchHint => 'Қидириш';

  @override
  String get searchEmpty => 'Ҳеч нарса топилмади';

  @override
  String likesCount(int count) {
    return '$count та ёқтириш';
  }
}
