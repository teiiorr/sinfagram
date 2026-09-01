// Sinfagram — barcha ma'lumotlar hardcoded (backend yo'q).
// Foto (lenta, story, klub qopqoqlari): LoremFlickr — real, tabiiy maktab
// sahnalari (parta, doska, kitob, laboratoriya), AI emas.
// Avatarlar: ism initsiali (rangli doira) — Avatar widgeti chizadi, tabiiy, AI-siz.

// ---------- Rasm yordamchilari ----------
// Endi tarmoq URL emas — SinfPhoto uchun "urugʻ": mavzu (tag) + tartib (lock).
// SinfPhoto shu urugʻdan gradient va mavzuga mos emoji chizadi (buzuq foto yoʻq).
String schoolPhoto(String tag, int lock) => '$tag#$lock';

// Avatar uchun ism — Avatar(...) widgeti undan initsial va rang chiqaradi.
String avatarFor(String seed) => seed;

// ---------- Joriy foydalanuvchi ----------
class SinfUser {
  final String name;
  final String avatar;
  final String className; // "9-A"
  final String school; // "45-maktab"
  final String role; // "O'quvchi" / "O'qituvchi" / "Ota-ona" / "Direktor"
  const SinfUser({
    required this.name,
    required this.avatar,
    required this.className,
    required this.school,
    required this.role,
  });
}

final SinfUser currentUser = SinfUser(
  name: 'Sardor Aliyev',
  avatar: avatarFor('sardor'),
  className: '9-A sinf',
  school: 'Toshkent 45-maktab',
  role: "O'quvchi",
);

// ---------- Story (sinf) ----------
class SinfStory {
  final String name;
  final String avatar;
  final String cover;
  final bool seen;
  const SinfStory(
      {required this.name,
      required this.avatar,
      required this.cover,
      this.seen = false});
}

final List<SinfStory> stories = [
  SinfStory(name: 'Siz', avatar: currentUser.avatar, cover: schoolPhoto('classroom', 11)),
  SinfStory(name: 'Dilnoza', avatar: avatarFor('dilnoza'), cover: schoolPhoto('blackboard', 12)),
  SinfStory(name: 'Jasur', avatar: avatarFor('jasur'), cover: schoolPhoto('library,books', 13)),
  SinfStory(name: 'Malika', avatar: avatarFor('malika'), cover: schoolPhoto('school,desk', 14)),
  SinfStory(name: 'Bekzod', avatar: avatarFor('bekzod'), cover: schoolPhoto('science,laboratory', 15)),
  SinfStory(name: 'Nodira', avatar: avatarFor('nodira'), cover: schoolPhoto('notebook,pen', 16)),
  SinfStory(name: 'Otabek', avatar: avatarFor('otabek'), cover: schoolPhoto('chalkboard', 17)),
  SinfStory(name: 'Sevara', avatar: avatarFor('sevara'), cover: schoolPhoto('globe,geography', 18)),
  SinfStory(name: 'Rustam', avatar: avatarFor('rustam'), cover: schoolPhoto('chess', 19)),
  SinfStory(name: 'Gulnora', avatar: avatarFor('gulnora'), cover: schoolPhoto('books,study', 20)),
];

// ---------- Sinf lentasi (xronologik, faqat o'z sinfi) ----------
enum PostType { photo, text, poll, question, material }

class PollOption {
  final String label;
  final int votes;
  const PollOption(this.label, this.votes);
}

class FeedPost {
  final PostType type;
  final String author;
  final String avatar;
  final String time; // "2 soat oldin"
  final String className;
  final String? text;
  final String? image; // photo posts
  final int likes;
  final int comments;
  final List<PollOption>? poll;
  final String? materialTitle; // material posts
  final String? materialSubject;
  const FeedPost({
    required this.type,
    required this.author,
    required this.avatar,
    required this.time,
    required this.className,
    this.text,
    this.image,
    this.likes = 0,
    this.comments = 0,
    this.poll,
    this.materialTitle,
    this.materialSubject,
  });
}

final List<FeedPost> feedPosts = [
  FeedPost(
    type: PostType.material,
    author: 'Nigora Karimova (sinf rahbari)',
    avatar: avatarFor('nigora-teacher'),
    time: '30 daqiqa oldin',
    className: '9-A',
    materialTitle: 'Algebra — 12-mavzu taqdimoti',
    materialSubject: 'Matematika',
    text: 'Ertangi dars uchun taqdimotni yuklab oling va 5-6 masalalarni koʻring.',
    likes: 12,
    comments: 3,
  ),
  FeedPost(
    type: PostType.photo,
    author: 'Dilnoza Rahimova',
    avatar: avatarFor('dilnoza'),
    time: '1 soat oldin',
    className: '9-A',
    text: 'Bugungi biologiya laboratoriyasi 🔬',
    image: schoolPhoto('science,laboratory', 31),
    likes: 24,
    comments: 5,
  ),
  FeedPost(
    type: PostType.poll,
    author: 'Jasur Toshmatov',
    avatar: avatarFor('jasur'),
    time: '2 soat oldin',
    className: '9-A',
    text: 'Sinf sayohatini qayerga uyushtiramiz?',
    poll: [
      PollOption('Samarqand', 14),
      PollOption('Buxoro', 9),
      PollOption('Chimyon togʻlari', 7),
    ],
    likes: 8,
    comments: 11,
  ),
  FeedPost(
    type: PostType.question,
    author: 'Malika Yusupova',
    avatar: avatarFor('malika'),
    time: '3 soat oldin',
    className: '9-A',
    text: 'Fizikadan uy vazifasining 4-masalasini kim tushuntira oladi? 🙏',
    likes: 6,
    comments: 8,
  ),
  FeedPost(
    type: PostType.photo,
    author: 'Bekzod Aliyev',
    avatar: avatarFor('bekzod'),
    time: '5 soat oldin',
    className: '9-A',
    text: 'Kutubxonada tayyorgarlik 📚',
    image: schoolPhoto('library,books', 32),
    likes: 31,
    comments: 4,
  ),
  FeedPost(
    type: PostType.text,
    author: 'Otabek Rashidov',
    avatar: avatarFor('otabek'),
    time: '6 soat oldin',
    className: '9-A',
    text: 'Bugun maktab shahmat turnirida 2-oʻrinni egalladik! Jamoaga rahmat ♟️',
    likes: 40,
    comments: 9,
  ),
  FeedPost(
    type: PostType.photo,
    author: 'Sevara Qodirova',
    avatar: avatarFor('sevara'),
    time: '8 soat oldin',
    className: '9-A',
    text: 'Geografiya darsi — globus bilan 🌍',
    image: schoolPhoto('globe,geography', 33),
    likes: 18,
    comments: 2,
  ),
];

// ---------- Sinf chati ----------
class ChatMsg {
  final String sender;
  final String avatar;
  final String text;
  final String time;
  final bool isMe;
  final bool isTeacher;
  const ChatMsg({
    required this.sender,
    required this.avatar,
    required this.text,
    required this.time,
    this.isMe = false,
    this.isTeacher = false,
  });
}

final List<ChatMsg> classChat = [
  ChatMsg(sender: 'Nigora Karimova', avatar: avatarFor('nigora-teacher'), isTeacher: true, time: '08:15', text: 'Assalomu alaykum, 9-A! Ertaga 1-soatdan matematika boʻladi.'),
  ChatMsg(sender: 'Jasur', avatar: avatarFor('jasur'), time: '08:20', text: 'Rahmat, ustoz!'),
  ChatMsg(sender: 'Dilnoza', avatar: avatarFor('dilnoza'), time: '08:22', text: 'Uy vazifasi qaysi sahifada edi?'),
  ChatMsg(sender: 'Malika', avatar: avatarFor('malika'), time: '08:24', text: '48-sahifa, 5-mashq 📖'),
  ChatMsg(sender: 'Siz', avatar: currentUser.avatar, isMe: true, time: '08:25', text: 'Rahmat! Kechqurun yechib chiqaman.'),
  ChatMsg(sender: 'Nigora Karimova', avatar: avatarFor('nigora-teacher'), isTeacher: true, time: '08:30', text: 'Barakalla. Savol boʻlsa shu yerda yozing.'),
];

// ---------- Vazifalar taxtasi (uy vazifalari) ----------
class HomeworkTask {
  final String subject;
  final String title;
  final String due; // "Ertaga", "3 kun"
  bool done;
  HomeworkTask({required this.subject, required this.title, required this.due, this.done = false});
}

final List<HomeworkTask> tasks = [
  HomeworkTask(subject: 'Matematika', title: '48-bet, 5-mashq masalalarini yeching', due: 'Ertaga'),
  HomeworkTask(subject: 'Fizika', title: 'Laboratoriya ishi hisobotini tayyorlang', due: '2 kun'),
  HomeworkTask(subject: 'Ona tili', title: 'Insho: "Mening maktabim"', due: '3 kun'),
  HomeworkTask(subject: 'Ingliz tili', title: 'Unit 6 — yangi soʻzlarni yodlang', due: 'Ertaga', done: true),
  HomeworkTask(subject: 'Tarix', title: 'Amir Temur davri — konspekt', due: '4 kun'),
  HomeworkTask(subject: 'Biologiya', title: 'Hujayra tuzilishi — rasm chizing', due: '5 kun', done: true),
];

// ---------- Dars jadvali ----------
class Lesson {
  final String time;
  final String subject;
  final String room;
  const Lesson(this.time, this.subject, this.room);
}

class DaySchedule {
  final String day;
  final List<Lesson> lessons;
  const DaySchedule(this.day, this.lessons);
}

final List<DaySchedule> schedule = [
  DaySchedule('Dushanba', [
    Lesson('08:30', 'Matematika', '204'),
    Lesson('09:20', 'Ona tili', '108'),
    Lesson('10:20', 'Fizika', '301'),
    Lesson('11:10', 'Ingliz tili', '115'),
    Lesson('12:00', 'Jismoniy tarbiya', 'Sport zali'),
  ]),
  DaySchedule('Seshanba', [
    Lesson('08:30', 'Biologiya', '210'),
    Lesson('09:20', 'Tarix', '106'),
    Lesson('10:20', 'Matematika', '204'),
    Lesson('11:10', 'Geografiya', '112'),
  ]),
  DaySchedule('Chorshanba', [
    Lesson('08:30', 'Kimyo', '303'),
    Lesson('09:20', 'Adabiyot', '108'),
    Lesson('10:20', 'Ingliz tili', '115'),
    Lesson('11:10', 'Informatika', 'IT-lab'),
    Lesson('12:00', "Ma'naviyat", '101'),
  ]),
  DaySchedule('Payshanba', [
    Lesson('08:30', 'Matematika', '204'),
    Lesson('09:20', 'Fizika', '301'),
    Lesson('10:20', 'Ona tili', '108'),
    Lesson('11:10', 'Tarix', '106'),
  ]),
  DaySchedule('Juma', [
    Lesson('08:30', 'Geografiya', '112'),
    Lesson('09:20', 'Biologiya', '210'),
    Lesson('10:20', 'Adabiyot', '108'),
    Lesson('11:10', 'Jismoniy tarbiya', 'Sport zali'),
  ]),
];

// ---------- Kalendar (tadbirlar) ----------
class SinfEvent {
  final String date; // "12-avgust"
  final String title;
  final String type; // "Tadbir", "Ekskursiya", "Ma'naviyat soati"
  final String place;
  const SinfEvent({required this.date, required this.title, required this.type, required this.place});
}

final List<SinfEvent> events = [
  SinfEvent(date: '12-avgust', title: 'Bilimlar bayrami tayyorgarligi', type: 'Tadbir', place: 'Maktab hovlisi'),
  SinfEvent(date: '18-avgust', title: 'Samarqandga sinf ekskursiyasi', type: 'Ekskursiya', place: 'Registon'),
  SinfEvent(date: '25-avgust', title: 'Mustaqillik kuniga bagʻishlangan soat', type: "Ma'naviyat soati", place: '101-xona'),
  SinfEvent(date: '2-sentabr', title: 'Yangi oʻquv yili ochilishi', type: 'Tadbir', place: 'Maktab hovlisi'),
  SinfEvent(date: '9-sentabr', title: 'Kutubxona bilan uchrashuv', type: 'Tadbir', place: 'Kutubxona'),
];

// ---------- Klublar / to'garaklar ----------
class Club {
  final String name;
  final String emoji;
  final String curator;
  final int members;
  final String cover;
  const Club({required this.name, required this.emoji, required this.curator, required this.members, required this.cover});
}

final List<Club> clubs = [
  Club(name: 'Shaxmat toʻgaragi', emoji: '♟️', curator: 'Anvar Sobirov', members: 24, cover: schoolPhoto('chess', 41)),
  Club(name: 'Robototexnika', emoji: '🤖', curator: 'Kamola Yoʻldosheva', members: 18, cover: schoolPhoto('robot,technology', 42)),
  Club(name: 'Teatr studiyasi', emoji: '🎭', curator: 'Sevara Ismoilova', members: 15, cover: schoolPhoto('theater,stage', 43)),
  Club(name: 'IT / dasturlash', emoji: '💻', curator: 'Bekzod Rahimov', members: 30, cover: schoolPhoto('computer,coding', 44)),
  Club(name: 'Kitobxonlik klubi', emoji: '📚', curator: 'Nodira Aliyeva', members: 21, cover: schoolPhoto('books,reading', 45)),
  Club(name: 'Tabiat va ekologiya', emoji: '🌱', curator: 'Otabek Nazarov', members: 16, cover: schoolPhoto('nature,plants', 46)),
];

// ---------- Maktab loyihalari ----------
class SchoolProject {
  final String title;
  final String team;
  final String cover;
  final String desc;
  const SchoolProject({required this.title, required this.team, required this.cover, required this.desc});
}

final List<SchoolProject> projects = [
  SchoolProject(title: 'Aqlli maktab bogʻi', team: '9-A jamoasi', cover: schoolPhoto('garden,school', 51), desc: 'Maktab hovlisida avtomatik sugʻorish tizimi.'),
  SchoolProject(title: 'Elektron kutubxona', team: 'IT klubi', cover: schoolPhoto('library,digital', 52), desc: 'Darsliklarning raqamli katalogi.'),
  SchoolProject(title: 'Quyosh batareyasi maketi', team: 'Fizika toʻgaragi', cover: schoolPhoto('solar,energy', 53), desc: 'Muqobil energiya boʻyicha loyiha.'),
  SchoolProject(title: 'Maktab gazetasi', team: 'Jurnalistika', cover: schoolPhoto('newspaper,writing', 54), desc: 'Oylik raqamli gazeta.'),
];

// ---------- Olimpiada va tanlovlar taqvimi ----------
class Contest {
  final String title;
  final String subject;
  final String date;
  final String level; // "Maktab", "Tuman", "Respublika"
  final String deadline;
  const Contest({required this.title, required this.subject, required this.date, required this.level, required this.deadline});
}

final List<Contest> contests = [
  Contest(title: 'Matematika olimpiadasi', subject: 'Matematika', date: '20-avgust', level: 'Tuman', deadline: '15-avgust'),
  Contest(title: 'President Tech Award', subject: 'IT / Startap', date: '10-sentabr', level: 'Respublika', deadline: '1-sentabr'),
  Contest(title: 'Ingliz tili bilimdoni', subject: 'Ingliz tili', date: '28-avgust', level: 'Maktab', deadline: '24-avgust'),
  Contest(title: 'Upshift ijtimoiy loyiha', subject: 'Tadbirkorlik', date: '15-sentabr', level: 'Respublika', deadline: '5-sentabr'),
  Contest(title: 'Zakovat intellektual oʻyini', subject: 'Umumiy', date: '3-sentabr', level: 'Tuman', deadline: '30-avgust'),
];

// ---------- Ustoz-shogird (peer mentoring) ----------
class Mentor {
  final String name;
  final String avatar;
  final String grade; // "11-B"
  final List<String> subjects;
  final int hours; // portfolioga tushgan soatlar
  const Mentor({required this.name, required this.avatar, required this.grade, required this.subjects, required this.hours});
}

final List<Mentor> mentors = [
  Mentor(name: 'Aziz Karimov', avatar: avatarFor('aziz'), grade: '11-B', subjects: ['Matematika', 'Fizika'], hours: 12),
  Mentor(name: 'Zilola Ergasheva', avatar: avatarFor('zilola'), grade: '11-A', subjects: ['Ingliz tili'], hours: 9),
  Mentor(name: 'Farrux Sodiqov', avatar: avatarFor('farrux'), grade: '10-A', subjects: ['Informatika', 'Matematika'], hours: 15),
  Mentor(name: 'Madina Yusupova', avatar: avatarFor('madina'), grade: '11-B', subjects: ['Kimyo', 'Biologiya'], hours: 7),
];

// ---------- Portfolio ----------
enum PortfolioStatus { self, teacher, school }

class PortfolioItem {
  final String title;
  final String category; // "Sertifikat", "Loyiha", "To'garak", "Ijodiy ish"
  final String date;
  final PortfolioStatus status;
  const PortfolioItem({required this.title, required this.category, required this.date, required this.status});
}

final List<PortfolioItem> portfolio = [
  PortfolioItem(title: 'Matematika olimpiadasi — 2-oʻrin', category: 'Sertifikat', date: '2026-mart', status: PortfolioStatus.school),
  PortfolioItem(title: 'IT toʻgaragi — "Aqlli uy" loyihasi', category: 'Loyiha', date: '2026-fevral', status: PortfolioStatus.teacher),
  PortfolioItem(title: 'Ingliz tili B1 sertifikati', category: 'Sertifikat', date: '2026-yanvar', status: PortfolioStatus.school),
  PortfolioItem(title: 'Maktab gazetasiga maqola', category: 'Ijodiy ish', date: '2025-dekabr', status: PortfolioStatus.self),
  PortfolioItem(title: 'Shaxmat toʻgaragi ishtiroki', category: "To'garak", date: '2025-noyabr', status: PortfolioStatus.teacher),
];

// ---------- Shaxsiy o'sish jurnali (faqat o'ziga) ----------
class JournalEntry {
  final String date;
  final String mood; // emoji
  final String text;
  const JournalEntry({required this.date, required this.mood, required this.text});
}

final List<JournalEntry> journal = [
  JournalEntry(date: 'Bugun', mood: '🙂', text: 'Matematikadan yangi mavzuni tushundim. Ertaga masalalarni mustaqil yechishga harakat qilaman.'),
  JournalEntry(date: 'Kecha', mood: '😊', text: 'Kutubxonada 2 soat oʻtirdim, insho uchun material topdim.'),
  JournalEntry(date: '2 kun oldin', mood: '😐', text: 'Fizika biroz qiyin ketdi, ustozdan qoʻshimcha soʻrayman.'),
];

// ---------- Kasb yo'nalishi testi ----------
class CareerQuestion {
  final String question;
  final List<String> options;
  const CareerQuestion(this.question, this.options);
}

final List<CareerQuestion> careerTest = [
  CareerQuestion('Qaysi mashgʻulot senga koʻproq yoqadi?', ['Masala yechish', 'Rasm/dizayn', 'Odamlar bilan ishlash', 'Tajriba oʻtkazish']),
  CareerQuestion('Boʻsh vaqtingda nima qilasan?', ['Kod yozaman', 'Kitob oʻqiyman', 'Sport', 'Video montaj']),
  CareerQuestion('Qaysi fan qiziqroq?', ['Matematika', 'Biologiya', 'Tarix', 'Informatika']),
  CareerQuestion('Kelajakda nimani xohlaysan?', ['Muhandis', 'Shifokor', "O'qituvchi", 'Tadbirkor']),
];

// ---------- Ma'naviyat / vatanparvarlik viktorinasi ----------
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correct;
  const QuizQuestion(this.question, this.options, this.correct);
}

final List<QuizQuestion> spiritualityQuiz = [
  QuizQuestion("O'zbekiston mustaqillikka qachon erishgan?", ['1990', '1991', '1992', '1989'], 1),
  QuizQuestion('Amir Temur qaysi shaharni poytaxt qilgan?', ['Buxoro', 'Xiva', 'Samarqand', 'Toshkent'], 2),
  QuizQuestion('"Boburnoma" asari muallifi kim?', ['Alisher Navoiy', 'Zahiriddin Bobur', 'Abdulla Qodiriy', 'Choʻlpon'], 1),
  QuizQuestion("O'zbekiston Davlat bayrogʻida nechta yulduz bor?", ['10', '12', '14', '16'], 1),
];

final List<Map<String, String>> spiritualityMaterials = [
  {'title': 'Amir Temur — buyuk sarkarda', 'type': 'Tarixiy material'},
  {'title': 'Alisher Navoiy hayoti va ijodi', 'type': 'Tarixiy material'},
  {'title': 'Mahalla — el-yurt tayanchi', 'type': 'Mahalla topshirigʻi'},
  {'title': 'Mustaqillik — 34 yil', 'type': 'Viktorina'},
];

// ---------- Xavfsizlik: shikoyat sabablari ----------
final List<String> complaintReasons = [
  'Bulling / kamsitish',
  'Ogʻzaki haqorat',
  'Jismoniy zoʻravonlik',
  'Ijtimoiy izolyatsiya',
  'Boshqa',
];

// ---------- "Meni kim ko'radi" (shaffoflik) ----------
class VisibilityRow {
  final String what;
  final String whoSees;
  const VisibilityRow(this.what, this.whoSees);
}

final List<VisibilityRow> visibility = [
  VisibilityRow('Sinf lentasidagi postlaring', 'Faqat sinfdoshlaring va sinf rahbaring'),
  VisibilityRow('Shaxsiy oʻsish jurnaling', 'Faqat sen — hech kim koʻrmaydi'),
  VisibilityRow('Portfoliong', 'Sen, oʻqituvchi va maktab (tasdiqlash uchun)'),
  VisibilityRow('Baholaring va davomating', 'Sen va ota-onang'),
  VisibilityRow('Shaxsiy xabarlaring', 'Faqat sen va suhbatdoshing — hech kim oʻqimaydi'),
  VisibilityRow('SOS murojaating', 'Faqat psixolog va sinf rahbaring (maxfiy)'),
];

// ---------- Ota-ona xabarnomasi ----------
final List<Map<String, String>> parentNotifications = [
  {'type': 'Davomat', 'text': 'Sardor bugun barcha darslarda qatnashdi.', 'action': 'Harakat talab etilmaydi'},
  {'type': 'Vazifa', 'text': 'Fizikadan uy vazifasi bajarilmagan.', 'action': 'Bola bilan suhbatlashing'},
  {'type': 'Baho', 'text': 'Matematikadan "5" baho olindi.', 'action': 'Ragʻbatlantiring'},
];

// ---------- Direktor dashboard (agregat) ----------
final Map<String, String> directorStats = {
  'Faol oʻquvchilar': '842 / 910',
  'Klublar qamrovi': '64%',
  'Bu haftadagi tadbirlar': '5',
  'Bajarilgan vazifalar': '78%',
};

// ---------- O'qituvchi paneli (agregat) ----------
final Map<String, String> teacherStats = {
  'Sinf oʻquvchilari': '28',
  'Bugun faol': '25',
  'Bajarilgan vazifalar': '82%',
  'Ochilmagan shikoyatlar': '0',
};

// ---------- Profil: fotolar to'ri va sinfdoshlar ----------
const List<String> _photoTags = [
  'classroom', 'blackboard', 'library,books', 'school,desk', 'science,laboratory',
  'notebook,pen', 'chalkboard', 'globe,geography', 'chess', 'books,study',
  'painting,art', 'sport,ball', 'robot,technology', 'flowers,nature', 'music,instrument',
];

// har bir foydalanuvchi uchun barqaror rasmlar to'plami (lock — takrorlanmas)
List<String> photosFor(int base, int n) =>
    List<String>.generate(n, (i) => schoolPhoto(_photoTags[(base + i) % _photoTags.length], 100 + base * 20 + i));

// Joriy foydalanuvchi profili
final List<String> myPosts = photosFor(0, 9);
const int myPostsCount = 9;
const int myFollowers = 31;
const int myFollowing = 88;
const String myBio = 'Matematika va IT ixlosmandi · Shaxmat toʻgaragi ♟️';

// Sinfdoshlar
class Classmate {
  final String name;
  final String className;
  final String bio;
  final int posts;
  final int followers;
  final int following;
  final List<String> photos;
  const Classmate({
    required this.name,
    required this.className,
    required this.bio,
    required this.posts,
    required this.followers,
    required this.following,
    required this.photos,
  });
}

final List<Classmate> classmates = [
  Classmate(name: 'Dilnoza Rahimova', className: '9-A sinf', bio: 'Kitobxonlik klubi 📚 · biologiya', posts: 12, followers: 31, following: 98, photos: photosFor(1, 12)),
  Classmate(name: 'Jasur Toshmatov', className: '9-A sinf', bio: 'Futbol ⚽ · matematika', posts: 8, followers: 31, following: 84, photos: photosFor(2, 8)),
  Classmate(name: 'Malika Yusupova', className: '9-A sinf', bio: 'Rassomlik 🎨 · ingliz tili', posts: 15, followers: 31, following: 112, photos: photosFor(3, 15)),
  Classmate(name: 'Bekzod Aliyev', className: '9-A sinf', bio: 'Robototexnika 🤖', posts: 7, followers: 31, following: 76, photos: photosFor(4, 7)),
  Classmate(name: 'Nodira Karimova', className: '9-A sinf', bio: 'Musiqa 🎵 · adabiyot', posts: 11, followers: 31, following: 90, photos: photosFor(5, 11)),
  Classmate(name: 'Otabek Rashidov', className: '9-A sinf', bio: 'Shaxmat ♟️ · fizika', posts: 9, followers: 31, following: 88, photos: photosFor(6, 9)),
  Classmate(name: 'Sevara Qodirova', className: '9-A sinf', bio: 'Geografiya 🌍 · sayohat', posts: 13, followers: 31, following: 101, photos: photosFor(7, 13)),
  Classmate(name: 'Rustam Sodiqov', className: '9-A sinf', bio: 'IT / dasturlash 💻', posts: 10, followers: 31, following: 93, photos: photosFor(8, 10)),
  Classmate(name: 'Gulnora Aliyeva', className: '9-A sinf', bio: 'Teatr 🎭 · ona tili', posts: 14, followers: 31, following: 105, photos: photosFor(9, 14)),
  Classmate(name: 'Farrux Nazarov', className: '9-A sinf', bio: 'Tabiat va ekologiya 🌱', posts: 6, followers: 31, following: 70, photos: photosFor(10, 6)),
  Classmate(name: 'Madina Yoʻldosheva', className: '9-A sinf', bio: 'Kimyo 🔬 · biologiya', posts: 12, followers: 31, following: 95, photos: photosFor(11, 12)),
  Classmate(name: 'Sardorbek Umarov', className: '9-A sinf', bio: 'Tarix 📜 · shaxmat', posts: 8, followers: 31, following: 82, photos: photosFor(12, 8)),
];

// ---------- Faoliyat (like tugmasi) ----------
final List<Map<String, String>> activityFeed = [
  {'who': 'Dilnoza Rahimova', 'action': 'postingizni yoqtirdi', 'time': '5 daqiqa oldin'},
  {'who': 'Jasur Toshmatov', 'action': 'izoh qoldirdi: "Zoʻr ish!"', 'time': '20 daqiqa oldin'},
  {'who': 'Malika Yusupova', 'action': 'sizni kuzatishni boshladi', 'time': '1 soat oldin'},
  {'who': 'Bekzod Aliyev', 'action': 'postingizni yoqtirdi', 'time': '2 soat oldin'},
  {'who': 'Nodira Karimova', 'action': 'portfoliongizni koʻrdi', 'time': '3 soat oldin'},
  {'who': 'Otabek Rashidov', 'action': 'izoh qoldirdi: "Rahmat!"', 'time': '5 soat oldin'},
  {'who': 'Sevara Qodirova', 'action': 'postingizni yoqtirdi', 'time': 'kecha'},
];

// ---------- Munozara (Threads uslubidagi) — post + koʻrinadigan javoblar ----------
class ThreadReply {
  final String author;
  final String text;
  final String time;
  final bool isMe;
  const ThreadReply({required this.author, required this.text, required this.time, this.isMe = false});
}

class ThreadPost {
  final String author;
  final String text;
  final String time;
  final int likes;
  final List<ThreadReply> replies;
  const ThreadPost({required this.author, required this.text, required this.time, this.likes = 0, this.replies = const []});
}

final List<ThreadPost> threads = [
  ThreadPost(
    author: 'Malika Yusupova',
    text: 'Ertangi tarix imtihoniga qaysi mavzular kiradi? 📖',
    time: '15 daqiqa oldin',
    likes: 9,
    replies: [
      ThreadReply(author: 'Jasur', text: 'Amir Temur davri va Buyuk ipak yoʻli', time: '12 daqiqa oldin'),
      ThreadReply(author: 'Dilnoza', text: 'Ustoz 5-8 paragraflarni aytdi', time: '10 daqiqa oldin'),
      ThreadReply(author: 'Siz', text: 'Rahmat! Bugun takrorlaymiz 💪', time: '8 daqiqa oldin', isMe: true),
    ],
  ),
  ThreadPost(
    author: 'Bekzod Aliyev',
    text: 'Robototexnika toʻgaragiga yangi aʼzolar kerak. Kim qiziqadi? 🤖',
    time: '1 soat oldin',
    likes: 14,
    replies: [
      ThreadReply(author: 'Rustam', text: 'Men boraman!', time: '55 daqiqa oldin'),
      ThreadReply(author: 'Sardorbek', text: 'Qachon yigʻilish boʻladi?', time: '50 daqiqa oldin'),
    ],
  ),
  ThreadPost(
    author: 'Nodira Karimova',
    text: 'Kutubxonaga yangi kitoblar keldi — Choʻlpon va Qodiriy 📚',
    time: '2 soat oldin',
    likes: 21,
    replies: [
      ThreadReply(author: 'Malika', text: '«Oʻtkan kunlar»ni olib qoʻydim 😍', time: '1 soat oldin'),
    ],
  ),
  ThreadPost(
    author: 'Otabek Rashidov',
    text: 'Shanba kuni sinf boʻlib futbol oʻynaymizmi? ⚽',
    time: '3 soat oldin',
    likes: 17,
    replies: [
      ThreadReply(author: 'Jasur', text: 'Albatta! Men darvozabon 🧤', time: '2 soat oldin'),
      ThreadReply(author: 'Bekzod', text: 'Men ham bor', time: '2 soat oldin'),
      ThreadReply(author: 'Farrux', text: 'Soat nechada?', time: '1 soat oldin'),
    ],
  ),
  ThreadPost(
    author: 'Sevara Qodirova',
    text: 'Geografiyadan referat mavzusini kim tanladi? 🌍',
    time: '5 soat oldin',
    likes: 6,
    replies: [
      ThreadReply(author: 'Gulnora', text: 'Men Oʻzbekiston relyefi haqida', time: '4 soat oldin'),
    ],
  ),
];
