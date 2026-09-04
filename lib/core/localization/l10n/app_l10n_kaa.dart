// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Kara-Kalpak (`kaa`).
class AppL10nKaa extends AppL10n {
  AppL10nKaa([String locale = 'kaa']) : super(locale);

  @override
  String get appTitle => 'Sinfagram';

  @override
  String get actionContinue => 'Dawam etiw';

  @override
  String get actionRetry => 'Qayta urınıw';

  @override
  String get actionSend => 'Jiberiw';

  @override
  String get actionCancel => 'Biykar etiw';

  @override
  String get actionEdit => 'Ózgertiw';

  @override
  String get actionUnderstood => 'Túsindim';

  @override
  String get navClass => 'Klass';

  @override
  String get navGames => 'Oyın';

  @override
  String get navChronicle => 'Jılnama';

  @override
  String get navMe => 'Men';

  @override
  String get emptyTitle => 'Házirshe bos';

  @override
  String get emptyBody => 'Bul jerde ele maǵlıwmat joq.';

  @override
  String get errorTitle => 'Qátelik júz berdi';

  @override
  String get errorBody => 'Qayta urınıp kóriń.';

  @override
  String get bannerOffline =>
      'Oflayn — kórsetilip atırǵan maǵlıwmat eski bolıwı múmkin';

  @override
  String get localeTitle => 'Til hám jazıw';

  @override
  String get localeUzLatn => 'Ózbekshe (latın)';

  @override
  String get localeUzCyrl => 'Ўзбекча (кирилл)';

  @override
  String get localeRu => 'Русский';

  @override
  String get localeKaa => 'Qaraqalpaqsha';

  @override
  String get roleTitle => 'Kim sıpatında kiresiz?';

  @override
  String get rolePupil => 'Men oqıwshıman';

  @override
  String get rolePupilSub => 'Klass kodı menen óz klassıńızǵa kiresiz.';

  @override
  String get roleTeacher => 'Men muǵallimeman';

  @override
  String get roleTeacherSub => 'Klass jaratasız hám dizimdi tastıyıqlaysız.';

  @override
  String get roleParent => 'Men ata-anaman';

  @override
  String get roleParentSub => 'Balańızdıń jumısların gúzetesiz.';

  @override
  String get codeTitle => 'Muǵallimińiz bergen kodtı kiritiń';

  @override
  String get codeHelp => 'Kod joqpa? Klass basshıńızǵa múrájat etiń.';

  @override
  String get codeError => 'Kod nadurıs. Qayta tekseriń.';

  @override
  String get rosterTitle => 'Atıńızdı saylań';

  @override
  String get rosterSearch => 'Izlew';

  @override
  String get rosterConfirmTitle => 'Bul sizbe?';

  @override
  String get pinTitle => 'PIN kod ornatıń';

  @override
  String get pinRepeat => 'PIN kodtı qaytalań';

  @override
  String get pinHint => 'Bul PIN tek usı qurılma ushın.';

  @override
  String get pinMismatch => 'PIN kodlar sáykes kelmedi.';

  @override
  String get consentTitle => 'Ata-ana tastıyıǵı kútilmekte';

  @override
  String get consentBody =>
      'Ata-anańız razılıǵın bergennen keyin, klassqa kire alasız.';

  @override
  String get consentResend => 'Sorawdı qayta jiberiw';

  @override
  String get visibilityTitle => 'Ata-anańız neni kóredi';

  @override
  String get visibilitySees => 'Ata-anańız kóredi';

  @override
  String get visibilitySeesItems =>
      'Siz járiyalaǵan postlar\nBelsendilik kúnleri hám waqtı\nKlasstaǵı shaǵımlar nátiyjesi';

  @override
  String get visibilityNotSees => 'Ata-anańız kórmeydi';

  @override
  String get visibilityNotItems =>
      'Jeke xabarlarıńız (olar ulıwma joq)\nKimge raxmet bergenińiz\nQaysı postlardı oqıǵanıńız';

  @override
  String get dayComposerEntry => 'Búgin ne boldı?';

  @override
  String get dayComplete => 'Búgingisi juwmaqlandı';

  @override
  String get dayCompleteSub => 'Erteń jáne kórisemiz.';

  @override
  String get dayPrevious => 'Keshegi kúndi kóriw';

  @override
  String get dayEmpty => 'Búgin ele hesh nárse joq. Birinshi bolıwıńız múmkin.';

  @override
  String get thanks => 'Raxmet';

  @override
  String get report => 'Shaǵım';

  @override
  String comments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pikir $count',
      zero: 'Pikir joq',
    );
    return '$_temp0';
  }

  @override
  String get composeTitle => 'Jańa post';

  @override
  String get composeHint => 'Búgin ne boldı?';

  @override
  String get composePost => 'Jaylastırıw';

  @override
  String get composePhoto => 'Súwret qosıw';

  @override
  String get composeReview => 'Bul post kórip shıǵılmaqta';

  @override
  String get meThanksTitle => 'Sizdiń raxmetlerińiz';

  @override
  String get meThanksPrivate => 'Bunı tek siz hám ata-anańız kóredi.';

  @override
  String get meTimeToday => 'Búgin qosımshada';

  @override
  String get meSettings => 'Sazlawlar';

  @override
  String get meAbout => 'Qosımsha haqqında';

  @override
  String get meSignOut => 'Shıǵıw';

  @override
  String get gamesTitle => 'Oyın';

  @override
  String get gamesEmpty => 'Házirshe jarıs joq. Keyingisi tez arada.';

  @override
  String get chronicleTitle => 'Klass jılnaması';

  @override
  String get chronicleEmpty => 'Birinshi bap usı ayda jıynaladı.';

  @override
  String get boardTitle => 'Mektep taxtası';

  @override
  String get settingsTitle => 'Sazlawlar';

  @override
  String get settingsLanguage => 'Til hám jazıw';

  @override
  String get settingsDarkMode => 'Túngi tema';

  @override
  String get settingsSignOut => 'Shıǵıw';

  @override
  String get aboutTitle => 'Qosımsha haqqında';

  @override
  String get aboutVersion => 'Versiya';

  @override
  String get aboutMinistry =>
      'Mektepke shekemgi hám mektep bilimlendiriwi ministrligi';

  @override
  String get chalkTitle => 'Búgin klasta';

  @override
  String get chalkNote => 'Bilim — keleshek gilti';

  @override
  String get storyYou => 'Siz';

  @override
  String get storyAdd => 'Áńgime qosıw';

  @override
  String get storyAdded => 'Áńgimeńiz qosıldı';

  @override
  String get feedFriendsNow => 'Doslar ne jazdı';

  @override
  String get meReading => 'Házir oqıp atırman';

  @override
  String get meListening => 'Házir tıńlap atırman';

  @override
  String get meInterests => 'Qızıǵıwshılıqlar';

  @override
  String get meBio => 'Men haqqımda';

  @override
  String get meEditProfile => 'Profildi redaktorlaw';

  @override
  String get meEditSaved => 'Profil saqlandı';

  @override
  String get commentsTitle => 'Pikirler';

  @override
  String get commentHint => 'Pikir jazıń...';

  @override
  String get commentEmpty => 'Ele pikir joq. Birinshi bolıń.';

  @override
  String get helpTitle => 'Járdem taxtası';

  @override
  String get helpFilterAll => 'Barlıǵı';

  @override
  String get helpFilterWaiting => 'Juwap kútpekte';

  @override
  String get helpFilterClosed => 'Jabılǵan';

  @override
  String get helpAsk => 'Soraw beriw';

  @override
  String get helpEmpty => 'Ele soraw joq. Birinshi bolıp sorań.';

  @override
  String helpAnswers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count juwap',
      zero: 'Juwap joq',
    );
    return '$_temp0';
  }

  @override
  String get helpBest => 'Eń jaqsı juwap';

  @override
  String get helpMarkBest => 'Eń jaqsı dep belgilew';

  @override
  String get helpAnswerHint => 'Juwabıńız...';

  @override
  String get helpAnswerMin => 'Keminde 40 belgi kerek';

  @override
  String get helpAskTitle => 'Soraw beriw';

  @override
  String get helpQuestionHint => 'Sorawıńızdı jazıń';

  @override
  String get helpSubject => 'Pán';

  @override
  String get boardSchedule => 'Sabaq kestesi';

  @override
  String get boardHomework => 'Úy jumısı';

  @override
  String get boardAnnouncements => 'Járiyalar';

  @override
  String get boardLostFound => 'Joǵalǵan buyımlar';

  @override
  String get boardNow => 'Házir';

  @override
  String get reportTitle => 'Shaǵım';

  @override
  String get reportReasonBullying => 'Bulling / kemsitiw';

  @override
  String get reportReasonOffensive => 'Awızeki haqaret';

  @override
  String get reportReasonSpam => 'Spam / reklama';

  @override
  String get reportReasonOther => 'Basqa';

  @override
  String get reportNoteHint => 'Pikir (qálewi boyınsha)';

  @override
  String get reportWhoSees =>
      'Bunı tek klass basshıńız kóredi. Kim shaǵım etkeni ashılmaydı.';

  @override
  String get reportSent => 'Shaǵımıńız jiberildi';

  @override
  String get gameActiveBattle => 'Belsendi jarıs';

  @override
  String get gameOpponent => 'Qarsılas';

  @override
  String get gameSubject => 'Pán';

  @override
  String get gameStart => 'Baslaw';

  @override
  String get gameCannotPause => 'Baslanǵannan keyin, toqtatıp bolmaydı.';

  @override
  String gamePlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oqıwshı qatnastı',
      zero: 'Ele hesh kim qatnaspadı',
    );
    return '$_temp0';
  }

  @override
  String get gameLeagueSection => 'Liga';

  @override
  String gameRankValue(int count) {
    return '$count-orın';
  }

  @override
  String gamePointsValue(int count) {
    return '$count ball';
  }

  @override
  String get gameChallengeSection => 'Háptelik shaqırıq';

  @override
  String gameDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kún qaldı',
    );
    return '$_temp0';
  }

  @override
  String get battleResultTitle => 'Nátiyje';

  @override
  String get battleYourClass => 'Sizdiń klassıńız';

  @override
  String get battleOpponentClass => 'Qarsılas klass';

  @override
  String get battleParticipation => 'Qatnasıw';

  @override
  String get battlePerSubject => 'Pánler boyınsha';

  @override
  String get battleWin => 'Jeńis!';

  @override
  String get battleLose => 'Bul sapar bolmadı';

  @override
  String get battleDraw => 'Teń';

  @override
  String get battleNoPupilScore =>
      'Ball pútkil klasstiki — jeke nátiyje kórsetilmeydi.';

  @override
  String get leagueTitle => 'Liga';

  @override
  String get leagueParallel => 'Parallel';

  @override
  String get leagueSchool => 'Mektep';

  @override
  String get leagueDistrict => 'Rayon';

  @override
  String get leagueRegion => 'Wálayat';

  @override
  String get leagueColClass => 'Klass';

  @override
  String get leagueColPlayed => 'Oyınlar';

  @override
  String get leagueColPoints => 'Ball';

  @override
  String get leagueEmpty => 'Máwsim ele baslanbadı';

  @override
  String get chronicleSealed => 'Múrlengen';

  @override
  String chronicleItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count element',
      zero: 'Element joq',
    );
    return '$_temp0';
  }

  @override
  String chronicleDaysToSeal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kúnnen soń múrlenedi',
    );
    return '$_temp0';
  }

  @override
  String get chapterSealedNote => 'Bul bap múrlengen — tek kóriw ushın.';

  @override
  String get chapterEmpty => 'Bul bapta ele element joq.';

  @override
  String get nightTitle => 'Túngi rejim';

  @override
  String nightBody(String time) {
    return 'Klass túnde dem aladı. Erteń $time da qayta ashıladı.';
  }

  @override
  String get nightToBoard => 'Mektep taxtasına ótiw';

  @override
  String get lessonTitle => 'Sabaq rejimi';

  @override
  String lessonBody(String time) {
    return 'Házir sabaq waqtı. Sabaq $time da juwmaqlanadı.';
  }

  @override
  String get lessonToBoard => 'Keste hám úy jumısı';

  @override
  String get settingsMode => 'Rejim (demo)';

  @override
  String get modeNormal => 'Ápiwayı';

  @override
  String get modeNight => 'Túngi';

  @override
  String get modeLesson => 'Sabaq';

  @override
  String get tNavClasses => 'Klasslar';

  @override
  String get tNavCases => 'Múrájatlar';

  @override
  String tClassJoined(int joined, int total) {
    return '$joined/$total oqıwshı qosıldı';
  }

  @override
  String tOpenCases(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ashıq múrájat',
      zero: 'Ashıq múrájat joq',
    );
    return '$_temp0';
  }

  @override
  String get tCasesEmpty => 'Ashıq múrájat joq — bul jaqsı jaǵday.';

  @override
  String get tCaseOverdue => 'Múddeti ótken';

  @override
  String tCaseDue(String time) {
    return 'Múddet: $time';
  }

  @override
  String get tCaseEvidence => 'Dálil';

  @override
  String get tCaseHistory => 'Tariyx';

  @override
  String get tCaseActionHide => 'Jasırıw';

  @override
  String get tCaseActionMute => '24 saatqa dawıssız';

  @override
  String get tCaseActionEscalate => 'Joqarıǵa jiberiw';

  @override
  String get tCaseActionDismiss => 'Bas tartıw';

  @override
  String get tCaseNoteHint => 'Pikir jazıń (májbúriy)';

  @override
  String get tCaseResolved => 'Is jabıldı';

  @override
  String get tCaseAnonymous => 'Shaǵım etiwshiniń kimligi ashılmaydı.';

  @override
  String get tGamesSchedule => 'Jarıs rejelestiriw';

  @override
  String get tGamesSoon => 'Rejelestiriw tez arada.';

  @override
  String get pNavChild => 'Balam';

  @override
  String get pNavMessages => 'Xabarlar';

  @override
  String get pDigestTitle => 'Háptelik juwmaq';

  @override
  String pActiveDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kún belsendi boldı',
    );
    return '$_temp0';
  }

  @override
  String pMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minut',
    );
    return '$_temp0';
  }

  @override
  String pPublishedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count post jaylastırdı',
      zero: 'Post jaylastırmadı',
    );
    return '$_temp0';
  }

  @override
  String pThanksReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count raxmet aldı',
    );
    return '$_temp0';
  }

  @override
  String get pChildContent => 'Balańızdıń postları';

  @override
  String get pChildContentEmpty => 'Ele post joq.';

  @override
  String get pCases => 'Shaǵımlar';

  @override
  String get pCasesEmpty => 'Balańızǵa tiyisli shaǵım joq.';

  @override
  String get pControls => 'Basqarıw';

  @override
  String get pTimeLimit => 'Kúnlik waqıt shegarası';

  @override
  String get pNotifs => 'Bildiriwler';

  @override
  String get pConsentData => 'Razılıq hám maǵlıwmatlar';

  @override
  String get pConsentGranted => 'Razılıq berilgen';

  @override
  String get pCollected => 'Jıynalatuǵın maǵlıwmatlar';

  @override
  String get pNotCollected => 'Jıynalmaytuǵın maǵlıwmatlar';

  @override
  String get pExport => 'Maǵlıwmatlardı júklep alıw';

  @override
  String get pDelete => 'Esap jazbanı óshiriw';

  @override
  String get pNoLiveFeed =>
      'Janlı jumıs lentası hám “onlayn” kórsetkishi joq. Bul balanıń isenimin saqlaydı.';

  @override
  String get pMessagesEmpty => 'Házirshe xabar joq.';

  @override
  String get pMessageTeacher => 'Muǵallimege xabar';

  @override
  String get rolesTitle => 'Klass rolleri';

  @override
  String get rolesThisWeek => 'Usı hápte';

  @override
  String get rolesRotation => 'Náwbet tártibi';

  @override
  String get wallTitle => 'Ulıwma diywal';

  @override
  String wallContributors(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count úles qosıldı',
    );
    return '$_temp0';
  }

  @override
  String get wallAdd => 'Belgi qosıw';

  @override
  String get wallDone => 'Siz úles qostıńız';

  @override
  String get challengeScreenTitle => 'Háptelik shaqırıq';

  @override
  String challengeDeadline(String date) {
    return 'Múddet: $date';
  }

  @override
  String get challengeSubmit => 'Qatnasıw';

  @override
  String get challengeEntries => 'Klass jumısları';

  @override
  String get challengeSubmitted => 'Jumısıńız jiberildi';

  @override
  String get capsuleTitle => 'Waqıt kapsulası';

  @override
  String get capsuleOpenHint => 'Keleshektegi ózińizge xat jazıń';

  @override
  String capsuleSeals(String date) {
    return '$date da múrlenedi';
  }

  @override
  String capsuleSealedOn(String date) {
    return 'Múrlengen: $date';
  }

  @override
  String capsuleOpensOn(String date) {
    return 'Ashıladı: $date';
  }

  @override
  String capsuleNotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count xat',
    );
    return '$_temp0';
  }

  @override
  String get capsuleWrite => 'Xat jazıw';

  @override
  String get capsuleSaved => 'Xatıńız kapsulaǵa saqlandı';

  @override
  String get tClassDetail => 'Klass';

  @override
  String get tRoster => 'Dizim';

  @override
  String get tGenerateCode => 'Kod jaratıw';

  @override
  String get tProjectGroups => 'Joybar toparları';

  @override
  String get tImportTitle => 'Dizimdi import etiw';

  @override
  String get tImportManual => 'Qolda qosıw';

  @override
  String get tImportCsv => 'CSV júklew';

  @override
  String get tImportChanges => 'Ózgerisler';

  @override
  String get tImportApply => 'Qollaw';

  @override
  String get tCodeTitle => 'Klass kodı';

  @override
  String get tCodePrint => 'A5 basıp shıǵarıw';

  @override
  String get tCodeShareNote => 'Bul kodtı tek óz oqıwshılarıńızǵa beriń.';

  @override
  String get tAnnounceTitle => 'Járiya';

  @override
  String get tAnnounceScope => 'Kórinis';

  @override
  String get tScopeClass => 'Klass';

  @override
  String get tScopeSchool => 'Mektep';

  @override
  String get tAnnounceHint => 'Járiya teksti';

  @override
  String get tAnnouncePin => 'Joqarıǵa bekitiw';

  @override
  String get tAnnouncePost => 'Jaylastırıw';

  @override
  String get tAnnouncePosted => 'Járiya jaylastırıldı';

  @override
  String get tScheduleTitle => 'Jarıs rejelestiriw';

  @override
  String get tPickOpponent => 'Qarsılas klass';

  @override
  String get tPickSubject => 'Pán';

  @override
  String get tPickWindow => 'Waqıt aralıǵı';

  @override
  String get tScheduleConfirm => 'Rejelestiriw';

  @override
  String get tScheduled => 'Jarıs rejelestirildi';

  @override
  String get tChannelTitle => 'Klass kanalı';

  @override
  String get tChannelNote => 'Bul kanal pútkil klassqa kórinedi — jeke emes.';

  @override
  String get tChronicleAdmin => 'Jılnama basqarıwı';

  @override
  String get tSetCover => 'Muqavanı belgilew';

  @override
  String get tSeal => 'Múrlew';

  @override
  String get tExportPdf => 'PDF eksport';

  @override
  String get meReadingHint => 'Qaysı kitapti oqıp atırsız?';

  @override
  String get meListeningHint => 'Qanday muzıka tıńlap atırsız?';

  @override
  String get meBioHint => 'Ózińiz haqqıńızda qısqasha';

  @override
  String get meEmpty => 'Ele toltırılmaǵan';

  @override
  String get meSave => 'Saqlaw';

  @override
  String get classmatesTitle => 'Klasslaslar';

  @override
  String get classmatesOpen => 'Klasslaslardı kóriw';

  @override
  String get classmatesSubtitle => 'Klassıńızdaǵı doslar';

  @override
  String get personReading => 'Oqıp atır';

  @override
  String get personListening => 'Tıńlap atır';

  @override
  String get personInterests => 'Qızıǵıwshılıqlar';

  @override
  String get personBio => 'Bio';

  @override
  String get personPhotos => 'Súwretler';

  @override
  String get personNoInfo => 'Hazirshe maǵlıwmat joq';

  @override
  String get composeVideo => 'Video';

  @override
  String get navFeed => 'Lenta';

  @override
  String get navMunozara => 'Pikirlesiw';

  @override
  String get navCreate => 'Jaratıw';

  @override
  String get navProfile => 'Profil';

  @override
  String get createPhoto => 'Súwret yaki video';

  @override
  String get createText => 'Tekst (pikirlesiw)';

  @override
  String get createTitle => 'Ne jaratamız?';

  @override
  String get repost => 'Repost';

  @override
  String get repostDone => 'Repost etildi';

  @override
  String get repostRemoved => 'Repost alıp taslandı';

  @override
  String get repostedLabel => 'Repost etdińiz';

  @override
  String get repostedFrom => 'reblog';

  @override
  String get share => 'Bólisiw';

  @override
  String get munozaraTitle => 'Pikirlesiw';

  @override
  String get munozaraEmpty => 'Ele pikirlesiw joq. Birinshi bolıp jazıń!';

  @override
  String get munozaraReply => 'Juwap beriw';

  @override
  String get munozaraNew => 'Jańa pikirlesiw';

  @override
  String get profileTabPosts => 'Postlar';

  @override
  String get profileTabReposts => 'Repostlar';

  @override
  String get profileTabChronicle => 'Jılnama';

  @override
  String get profileHighlights => 'Ajratılǵan';

  @override
  String get profileNoPosts => 'Ele post joq';

  @override
  String get profileNoReposts => 'Ele repost joq';

  @override
  String get feedPhotosEmpty => 'Ele súwret joq. Birinshi súwretti jaylań!';

  @override
  String get gamesHubTitle => 'Oyınlar';

  @override
  String get gamesHubLead =>
      'Bilim ushın jarıs, klass penen reytingte joqarı shıq';

  @override
  String get gamesBattle => 'Klass jarısı';

  @override
  String get gamesBattleDesc => 'Bilim boyınsha tez jarıs';

  @override
  String get gamesLeague => 'Reyting';

  @override
  String get gamesLeagueDesc => 'Klass hám mekteptiń reytingi';

  @override
  String get gamesQuiz => 'Tez viktorina';

  @override
  String get gamesQuizDesc => '10 soraw, waqıtqa qarsı';

  @override
  String get gamesQuizStart => 'Baslaw';

  @override
  String get gamesQuizNext => 'Keyingi';

  @override
  String get gamesQuizResult => 'Nátiyje';

  @override
  String get gamesQuizAgain => 'Taǵı bir ret';

  @override
  String get gamesScore => 'Ball';

  @override
  String get boardClassHub => 'Klass jumısları';

  @override
  String get gamesQuizClose => 'Jabıw';

  @override
  String get gamesQuizQuestion => 'Soraw';

  @override
  String get accountsTitle => 'Akkauntlar';

  @override
  String get accountSwitch => 'Akkauntti almastırıw';

  @override
  String get accountSwitched => 'Akkaunt almastırıldı';
}
