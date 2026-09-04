// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppL10nRu extends AppL10n {
  AppL10nRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Sinfagram';

  @override
  String get actionContinue => 'Продолжить';

  @override
  String get actionRetry => 'Повторить';

  @override
  String get actionSend => 'Отправить';

  @override
  String get actionCancel => 'Отмена';

  @override
  String get actionEdit => 'Редактировать';

  @override
  String get actionUnderstood => 'Понятно';

  @override
  String get navClass => 'Класс';

  @override
  String get navGames => 'Игры';

  @override
  String get navChronicle => 'Летопись';

  @override
  String get navMe => 'Я';

  @override
  String get emptyTitle => 'Пока пусто';

  @override
  String get emptyBody => 'Здесь пока нет данных.';

  @override
  String get errorTitle => 'Произошла ошибка';

  @override
  String get errorBody => 'Попробуйте ещё раз.';

  @override
  String get bannerOffline =>
      'Офлайн — показанные данные могут быть устаревшими';

  @override
  String get localeTitle => 'Язык и письмо';

  @override
  String get localeUzLatn => 'Oʻzbekcha (lotin)';

  @override
  String get localeUzCyrl => 'Ўзбекча (кирилл)';

  @override
  String get localeRu => 'Русский';

  @override
  String get localeKaa => 'Qaraqalpaqsha';

  @override
  String get roleTitle => 'Кто вы?';

  @override
  String get rolePupil => 'Я ученик';

  @override
  String get rolePupilSub => 'Вы входите в свой класс по коду класса.';

  @override
  String get roleTeacher => 'Я учитель';

  @override
  String get roleTeacherSub => 'Вы создаёте класс и подтверждаете список.';

  @override
  String get roleParent => 'Я родитель';

  @override
  String get roleParentSub => 'Вы следите за активностью ребёнка.';

  @override
  String get codeTitle => 'Введите код, который дал учитель';

  @override
  String get codeHelp => 'Нет кода? Обратитесь к классному руководителю.';

  @override
  String get codeError => 'Неверный код. Проверьте ещё раз.';

  @override
  String get rosterTitle => 'Выберите своё имя';

  @override
  String get rosterSearch => 'Поиск';

  @override
  String get rosterConfirmTitle => 'Это вы?';

  @override
  String get pinTitle => 'Установите PIN-код';

  @override
  String get pinRepeat => 'Повторите PIN-код';

  @override
  String get pinHint => 'Этот PIN только для этого устройства.';

  @override
  String get pinMismatch => 'PIN-коды не совпадают.';

  @override
  String get consentTitle => 'Ожидается согласие родителя';

  @override
  String get consentBody =>
      'Как только родитель даст согласие, вы сможете войти в класс.';

  @override
  String get consentResend => 'Отправить запрос повторно';

  @override
  String get visibilityTitle => 'Что видит ваш родитель';

  @override
  String get visibilitySees => 'Родитель видит';

  @override
  String get visibilitySeesItems =>
      'Опубликованные вами посты\nДни и время активности\nРезультаты жалоб в классе';

  @override
  String get visibilityNotSees => 'Родитель не видит';

  @override
  String get visibilityNotItems =>
      'Ваши личные сообщения (их вообще нет)\nКому вы сказали спасибо\nКакие посты вы читали';

  @override
  String get dayComposerEntry => 'Что случилось сегодня?';

  @override
  String get dayComplete => 'На сегодня всё';

  @override
  String get dayCompleteSub => 'Увидимся завтра.';

  @override
  String get dayPrevious => 'Посмотреть вчерашний день';

  @override
  String get dayEmpty => 'Сегодня пока ничего нет. Вы можете быть первым.';

  @override
  String get thanks => 'Спасибо';

  @override
  String get report => 'Пожаловаться';

  @override
  String comments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count комментариев',
      many: '$count комментариев',
      few: '$count комментария',
      one: '$count комментарий',
      zero: 'Нет комментариев',
    );
    return '$_temp0';
  }

  @override
  String get composeTitle => 'Новый пост';

  @override
  String get composeHint => 'Что случилось сегодня?';

  @override
  String get composePost => 'Опубликовать';

  @override
  String get composePhoto => 'Добавить фото';

  @override
  String get composeReview => 'Этот пост на проверке';

  @override
  String get meThanksTitle => 'Ваши благодарности';

  @override
  String get meThanksPrivate => 'Это видите только вы и ваш родитель.';

  @override
  String get meTimeToday => 'Сегодня в приложении';

  @override
  String get meSettings => 'Настройки';

  @override
  String get meAbout => 'О приложении';

  @override
  String get meSignOut => 'Выйти';

  @override
  String get gamesTitle => 'Игры';

  @override
  String get gamesEmpty => 'Пока нет состязаний. Следующее скоро.';

  @override
  String get chronicleTitle => 'Летопись класса';

  @override
  String get chronicleEmpty => 'Первая глава соберётся в этом месяце.';

  @override
  String get boardTitle => 'Школьная доска';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguage => 'Язык и письмо';

  @override
  String get settingsDarkMode => 'Ночная тема';

  @override
  String get settingsSignOut => 'Выйти';

  @override
  String get aboutTitle => 'О приложении';

  @override
  String get aboutVersion => 'Версия';

  @override
  String get aboutMinistry =>
      'Министерство дошкольного и школьного образования';

  @override
  String get chalkTitle => 'Сегодня в классе';

  @override
  String get chalkNote => 'Знание — ключ к будущему';

  @override
  String get storyYou => 'Вы';

  @override
  String get storyAdd => 'Добавить историю';

  @override
  String get storyAdded => 'История добавлена';

  @override
  String get feedFriendsNow => 'Что написали друзья';

  @override
  String get meReading => 'Сейчас читаю';

  @override
  String get meListening => 'Сейчас слушаю';

  @override
  String get meInterests => 'Интересы';

  @override
  String get meBio => 'О себе';

  @override
  String get meEditProfile => 'Редактировать профиль';

  @override
  String get meEditSaved => 'Профиль сохранён';

  @override
  String get commentsTitle => 'Комментарии';

  @override
  String get commentHint => 'Напишите комментарий...';

  @override
  String get commentEmpty => 'Пока нет комментариев. Будьте первым.';

  @override
  String get helpTitle => 'Доска помощи';

  @override
  String get helpFilterAll => 'Все';

  @override
  String get helpFilterWaiting => 'Ждут ответа';

  @override
  String get helpFilterClosed => 'Закрытые';

  @override
  String get helpAsk => 'Задать вопрос';

  @override
  String get helpEmpty => 'Пока нет вопросов. Спросите первым.';

  @override
  String helpAnswers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ответов',
      many: '$count ответов',
      few: '$count ответа',
      one: '$count ответ',
      zero: 'Нет ответов',
    );
    return '$_temp0';
  }

  @override
  String get helpBest => 'Лучший ответ';

  @override
  String get helpMarkBest => 'Отметить как лучший';

  @override
  String get helpAnswerHint => 'Ваш ответ...';

  @override
  String get helpAnswerMin => 'Нужно не менее 40 символов';

  @override
  String get helpAskTitle => 'Задать вопрос';

  @override
  String get helpQuestionHint => 'Напишите свой вопрос';

  @override
  String get helpSubject => 'Предмет';

  @override
  String get boardSchedule => 'Расписание уроков';

  @override
  String get boardHomework => 'Домашнее задание';

  @override
  String get boardAnnouncements => 'Объявления';

  @override
  String get boardLostFound => 'Потерянные вещи';

  @override
  String get boardNow => 'Сейчас';

  @override
  String get reportTitle => 'Жалоба';

  @override
  String get reportReasonBullying => 'Буллинг / унижение';

  @override
  String get reportReasonOffensive => 'Словесное оскорбление';

  @override
  String get reportReasonSpam => 'Спам / реклама';

  @override
  String get reportReasonOther => 'Другое';

  @override
  String get reportNoteHint => 'Комментарий (необязательно)';

  @override
  String get reportWhoSees =>
      'Это видит только классный руководитель. Кто пожаловался — не раскрывается.';

  @override
  String get reportSent => 'Ваша жалоба отправлена';

  @override
  String get gameActiveBattle => 'Активное состязание';

  @override
  String get gameOpponent => 'Соперник';

  @override
  String get gameSubject => 'Предмет';

  @override
  String get gameStart => 'Начать';

  @override
  String get gameCannotPause => 'После начала остановить нельзя.';

  @override
  String gamePlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Участвовало $count учеников',
      many: 'Участвовало $count учеников',
      few: 'Участвовало $count ученика',
      one: 'Участвовал $count ученик',
      zero: 'Пока никто не участвовал',
    );
    return '$_temp0';
  }

  @override
  String get gameLeagueSection => 'Лига';

  @override
  String gameRankValue(int count) {
    return '$count-е место';
  }

  @override
  String gamePointsValue(int count) {
    return 'Баллы: $count';
  }

  @override
  String get gameChallengeSection => 'Еженедельный вызов';

  @override
  String gameDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Осталось $count дней',
      many: 'Осталось $count дней',
      few: 'Осталось $count дня',
      one: 'Остался $count день',
    );
    return '$_temp0';
  }

  @override
  String get battleResultTitle => 'Результат';

  @override
  String get battleYourClass => 'Ваш класс';

  @override
  String get battleOpponentClass => 'Класс-соперник';

  @override
  String get battleParticipation => 'Участие';

  @override
  String get battlePerSubject => 'По предметам';

  @override
  String get battleWin => 'Победа!';

  @override
  String get battleLose => 'В этот раз не вышло';

  @override
  String get battleDraw => 'Ничья';

  @override
  String get battleNoPupilScore =>
      'Баллы принадлежат всему классу — личный результат не показывается.';

  @override
  String get leagueTitle => 'Лига';

  @override
  String get leagueParallel => 'Параллель';

  @override
  String get leagueSchool => 'Школа';

  @override
  String get leagueDistrict => 'Район';

  @override
  String get leagueRegion => 'Область';

  @override
  String get leagueColClass => 'Класс';

  @override
  String get leagueColPlayed => 'Игры';

  @override
  String get leagueColPoints => 'Баллы';

  @override
  String get leagueEmpty => 'Сезон ещё не начался';

  @override
  String get chronicleSealed => 'Опечатано';

  @override
  String chronicleItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count элементов',
      many: '$count элементов',
      few: '$count элемента',
      one: '$count элемент',
      zero: 'Нет элементов',
    );
    return '$_temp0';
  }

  @override
  String chronicleDaysToSeal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Будет опечатано через $count дней',
      many: 'Будет опечатано через $count дней',
      few: 'Будет опечатано через $count дня',
      one: 'Будет опечатано через $count день',
    );
    return '$_temp0';
  }

  @override
  String get chapterSealedNote => 'Эта глава опечатана — только для просмотра.';

  @override
  String get chapterEmpty => 'В этой главе пока нет элементов.';

  @override
  String get nightTitle => 'Ночной режим';

  @override
  String nightBody(String time) {
    return 'Класс отдыхает ночью. Утром он снова откроется в $time.';
  }

  @override
  String get nightToBoard => 'Перейти к школьной доске';

  @override
  String get lessonTitle => 'Режим урока';

  @override
  String lessonBody(String time) {
    return 'Сейчас идёт урок. Урок закончится в $time.';
  }

  @override
  String get lessonToBoard => 'Расписание и домашнее задание';

  @override
  String get settingsMode => 'Режим (демо)';

  @override
  String get modeNormal => 'Обычный';

  @override
  String get modeNight => 'Ночной';

  @override
  String get modeLesson => 'Урок';

  @override
  String get tNavClasses => 'Классы';

  @override
  String get tNavCases => 'Обращения';

  @override
  String tClassJoined(int joined, int total) {
    return 'Присоединились $joined/$total учеников';
  }

  @override
  String tOpenCases(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count открытых обращений',
      many: '$count открытых обращений',
      few: '$count открытых обращения',
      one: '$count открытое обращение',
      zero: 'Нет открытых обращений',
    );
    return '$_temp0';
  }

  @override
  String get tCasesEmpty => 'Нет открытых обращений — это хорошо.';

  @override
  String get tCaseOverdue => 'Просрочено';

  @override
  String tCaseDue(String time) {
    return 'Срок: $time';
  }

  @override
  String get tCaseEvidence => 'Доказательство';

  @override
  String get tCaseHistory => 'История';

  @override
  String get tCaseActionHide => 'Скрыть';

  @override
  String get tCaseActionMute => 'Заглушить на 24 часа';

  @override
  String get tCaseActionEscalate => 'Передать выше';

  @override
  String get tCaseActionDismiss => 'Отклонить';

  @override
  String get tCaseNoteHint => 'Напишите комментарий (обязательно)';

  @override
  String get tCaseResolved => 'Обращение закрыто';

  @override
  String get tCaseAnonymous => 'Кто пожаловался — не раскрывается.';

  @override
  String get tGamesSchedule => 'Запланировать состязание';

  @override
  String get tGamesSoon => 'Планирование скоро.';

  @override
  String get pNavChild => 'Мой ребёнок';

  @override
  String get pNavMessages => 'Сообщения';

  @override
  String get pDigestTitle => 'Итоги недели';

  @override
  String pActiveDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Был активен $count дней',
      many: 'Был активен $count дней',
      few: 'Был активен $count дня',
      one: 'Был активен $count день',
    );
    return '$_temp0';
  }

  @override
  String pMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минут',
      many: '$count минут',
      few: '$count минуты',
      one: '$count минута',
    );
    return '$_temp0';
  }

  @override
  String pPublishedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Опубликовано $count постов',
      many: 'Опубликовано $count постов',
      few: 'Опубликовано $count поста',
      one: 'Опубликован $count пост',
      zero: 'Постов не опубликовано',
    );
    return '$_temp0';
  }

  @override
  String pThanksReceived(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Получено $count благодарностей',
      many: 'Получено $count благодарностей',
      few: 'Получено $count благодарности',
      one: 'Получена $count благодарность',
    );
    return '$_temp0';
  }

  @override
  String get pChildContent => 'Посты вашего ребёнка';

  @override
  String get pChildContentEmpty => 'Пока нет постов.';

  @override
  String get pCases => 'Жалобы';

  @override
  String get pCasesEmpty => 'Нет жалоб, касающихся вашего ребёнка.';

  @override
  String get pControls => 'Управление';

  @override
  String get pTimeLimit => 'Дневной лимит времени';

  @override
  String get pNotifs => 'Уведомления';

  @override
  String get pConsentData => 'Согласие и данные';

  @override
  String get pConsentGranted => 'Согласие дано';

  @override
  String get pCollected => 'Собираемые данные';

  @override
  String get pNotCollected => 'Несобираемые данные';

  @override
  String get pExport => 'Скачать данные';

  @override
  String get pDelete => 'Удалить аккаунт';

  @override
  String get pNoLiveFeed =>
      'Нет ленты активности в реальном времени и индикатора «онлайн». Это сохраняет доверие ребёнка.';

  @override
  String get pMessagesEmpty => 'Пока нет сообщений.';

  @override
  String get pMessageTeacher => 'Сообщение учителю';

  @override
  String get rolesTitle => 'Роли в классе';

  @override
  String get rolesThisWeek => 'На этой неделе';

  @override
  String get rolesRotation => 'Порядок очерёдности';

  @override
  String get wallTitle => 'Общая стена';

  @override
  String wallContributors(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участников внесли вклад',
      many: '$count участников внесли вклад',
      few: '$count участника внесли вклад',
      one: '$count участник внёс вклад',
    );
    return '$_temp0';
  }

  @override
  String get wallAdd => 'Добавить отметку';

  @override
  String get wallDone => 'Вы внесли вклад';

  @override
  String get challengeScreenTitle => 'Еженедельный вызов';

  @override
  String challengeDeadline(String date) {
    return 'Срок: $date';
  }

  @override
  String get challengeSubmit => 'Участвовать';

  @override
  String get challengeEntries => 'Работы класса';

  @override
  String get challengeSubmitted => 'Ваша работа отправлена';

  @override
  String get capsuleTitle => 'Капсула времени';

  @override
  String get capsuleOpenHint => 'Напишите письмо себе в будущем';

  @override
  String capsuleSeals(String date) {
    return 'Будет опечатана $date';
  }

  @override
  String capsuleSealedOn(String date) {
    return 'Опечатана: $date';
  }

  @override
  String capsuleOpensOn(String date) {
    return 'Откроется: $date';
  }

  @override
  String capsuleNotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count писем',
      many: '$count писем',
      few: '$count письма',
      one: '$count письмо',
    );
    return '$_temp0';
  }

  @override
  String get capsuleWrite => 'Написать письмо';

  @override
  String get capsuleSaved => 'Ваше письмо сохранено в капсуле';

  @override
  String get tClassDetail => 'Класс';

  @override
  String get tRoster => 'Список';

  @override
  String get tGenerateCode => 'Создать код';

  @override
  String get tProjectGroups => 'Проектные группы';

  @override
  String get tImportTitle => 'Импорт списка';

  @override
  String get tImportManual => 'Добавить вручную';

  @override
  String get tImportCsv => 'Загрузить CSV';

  @override
  String get tImportChanges => 'Изменения';

  @override
  String get tImportApply => 'Применить';

  @override
  String get tCodeTitle => 'Код класса';

  @override
  String get tCodePrint => 'Печать A5';

  @override
  String get tCodeShareNote => 'Давайте этот код только своим ученикам.';

  @override
  String get tAnnounceTitle => 'Объявление';

  @override
  String get tAnnounceScope => 'Видимость';

  @override
  String get tScopeClass => 'Класс';

  @override
  String get tScopeSchool => 'Школа';

  @override
  String get tAnnounceHint => 'Текст объявления';

  @override
  String get tAnnouncePin => 'Закрепить вверху';

  @override
  String get tAnnouncePost => 'Опубликовать';

  @override
  String get tAnnouncePosted => 'Объявление опубликовано';

  @override
  String get tScheduleTitle => 'Запланировать состязание';

  @override
  String get tPickOpponent => 'Класс-соперник';

  @override
  String get tPickSubject => 'Предмет';

  @override
  String get tPickWindow => 'Временной интервал';

  @override
  String get tScheduleConfirm => 'Запланировать';

  @override
  String get tScheduled => 'Состязание запланировано';

  @override
  String get tChannelTitle => 'Канал класса';

  @override
  String get tChannelNote => 'Этот канал виден всему классу — он не личный.';

  @override
  String get tChronicleAdmin => 'Управление летописью';

  @override
  String get tSetCover => 'Установить обложку';

  @override
  String get tSeal => 'Опечатать';

  @override
  String get tExportPdf => 'Экспорт в PDF';

  @override
  String get meReadingHint => 'Какую книгу читаешь?';

  @override
  String get meListeningHint => 'Какую музыку слушаешь?';

  @override
  String get meBioHint => 'Коротко о себе';

  @override
  String get meEmpty => 'Пока не заполнено';

  @override
  String get meSave => 'Сохранить';

  @override
  String get classmatesTitle => 'Одноклассники';

  @override
  String get classmatesOpen => 'Показать одноклассников';

  @override
  String get classmatesSubtitle => 'Друзья из твоего класса';

  @override
  String get personReading => 'Читает';

  @override
  String get personListening => 'Слушает';

  @override
  String get personInterests => 'Интересы';

  @override
  String get personBio => 'О себе';

  @override
  String get personPhotos => 'Фото';

  @override
  String get personNoInfo => 'Пока нет информации';

  @override
  String get composeVideo => 'Видео';

  @override
  String get navFeed => 'Лента';

  @override
  String get navMunozara => 'Обсуждения';

  @override
  String get navCreate => 'Создать';

  @override
  String get navProfile => 'Профиль';

  @override
  String get createPhoto => 'Фото или видео';

  @override
  String get createText => 'Текст (обсуждение)';

  @override
  String get createTitle => 'Что создаём?';

  @override
  String get repost => 'Репост';

  @override
  String get repostDone => 'Репост сделан';

  @override
  String get repostRemoved => 'Репост удалён';

  @override
  String get repostedLabel => 'Вы сделали репост';

  @override
  String get repostedFrom => 'репост';

  @override
  String get share => 'Поделиться';

  @override
  String get munozaraTitle => 'Обсуждения';

  @override
  String get munozaraEmpty => 'Пока нет обсуждений. Напишите первым!';

  @override
  String get munozaraReply => 'Ответить';

  @override
  String get munozaraNew => 'Новое обсуждение';

  @override
  String get profileTabPosts => 'Посты';

  @override
  String get profileTabReposts => 'Репосты';

  @override
  String get profileTabChronicle => 'Летопись';

  @override
  String get profileHighlights => 'Актуальное';

  @override
  String get profileNoPosts => 'Пока нет постов';

  @override
  String get profileNoReposts => 'Пока нет репостов';

  @override
  String get feedPhotosEmpty => 'Пока нет фото. Опубликуйте первое!';

  @override
  String get gamesHubTitle => 'Игры';

  @override
  String get gamesHubLead => 'Соревнуйся в знаниях и поднимай класс в рейтинге';

  @override
  String get gamesBattle => 'Классный поединок';

  @override
  String get gamesBattleDesc => 'Быстрый поединок на знания';

  @override
  String get gamesLeague => 'Рейтинг';

  @override
  String get gamesLeagueDesc => 'Рейтинг класса и школы';

  @override
  String get gamesQuiz => 'Быстрая викторина';

  @override
  String get gamesQuizDesc => '10 вопросов на время';

  @override
  String get gamesQuizStart => 'Начать';

  @override
  String get gamesQuizNext => 'Далее';

  @override
  String get gamesQuizResult => 'Результат';

  @override
  String get gamesQuizAgain => 'Ещё раз';

  @override
  String get gamesScore => 'Очки';

  @override
  String get boardClassHub => 'Активности класса';

  @override
  String get gamesQuizClose => 'Закрыть';

  @override
  String get gamesQuizQuestion => 'Вопрос';

  @override
  String get accountsTitle => 'Аккаунты';

  @override
  String get accountSwitch => 'Сменить аккаунт';

  @override
  String get accountSwitched => 'Аккаунт изменён';
}
