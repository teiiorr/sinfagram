// Sinfagram — global reaktiv holat (ChangeNotifier).
// "Backend"ni frontendda jonlantiradi: layk, izoh, soʻrovnoma ovozi, obuna,
// yangi post, javob, chat, vazifa, kayfiyat, maqtov (kudos), reyting.
// Hammasi xotirada (sessiya davomida) saqlanadi — server yoʻq.
import 'package:flutter/foundation.dart';
import 'mock_data.dart';

// ---------------- Modellar ----------------
class Comment {
  final String author;
  final String text;
  final String time;
  const Comment(this.author, this.text, {this.time = 'hozir'});
}

class PollChoice {
  final String label;
  int votes;
  PollChoice(this.label, this.votes);
}

class Post {
  final String id;
  final PostType type;
  final String author;
  final String avatar;
  final String time;
  final String className;
  final String? text;
  final String? image;
  int likes;
  bool likedByMe;
  bool saved;
  final List<Comment> comments;
  final List<PollChoice>? poll;
  int? myVote; // qaysi variantga ovoz berildi
  final String? materialTitle;
  final String? materialSubject;
  final bool mine; // men yaratganman
  Post({
    required this.id,
    required this.type,
    required this.author,
    required this.avatar,
    required this.time,
    required this.className,
    this.text,
    this.image,
    this.likes = 0,
    this.likedByMe = false,
    this.saved = false,
    List<Comment>? comments,
    this.poll,
    this.myVote,
    this.materialTitle,
    this.materialSubject,
    this.mine = false,
  }) : comments = comments ?? [];

  int get totalVotes => poll == null ? 0 : poll!.fold(0, (a, b) => a + b.votes);
}

class Reply {
  final String author;
  final String text;
  final String time;
  final bool isMe;
  const Reply({required this.author, required this.text, required this.time, this.isMe = false});
}

class Thread {
  final String id;
  final String author;
  final String text;
  final String time;
  int likes;
  bool likedByMe;
  final List<Reply> replies;
  Thread({required this.id, required this.author, required this.text, required this.time, this.likes = 0, this.likedByMe = false, List<Reply>? replies}) : replies = replies ?? [];
}

class Birthday {
  final String name;
  final String date; // "12-avgust"
  final int daysLeft;
  bool greeted;
  Birthday(this.name, this.date, this.daysLeft, {this.greeted = false});
}

class Mood {
  final String label;
  const Mood(this.label);
}

const List<String> kMoods = ['Ajoyib', 'Yaxshi', 'Oʻrtacha', 'Charchadim', 'Xafa'];
const List<String> kKudos = ['Yordamchi', 'Ijodkor', 'Mehnatkash', 'Doʻst', 'Zukko', 'Faol'];

// ---------------- AppState ----------------
class AppState extends ChangeNotifier {
  AppState() {
    _seedFeed();
    _seedThreads();
    _seedChat();
    _seedNotifications();
    _seedBirthdays();
    _seedPoints();
  }

  // ===== LENTA =====
  final List<Post> feed = [];
  int _postSeq = 0;

  void _seedFeed() {
    for (int i = 0; i < feedPosts.length; i++) {
      final p = feedPosts[i];
      feed.add(Post(
        id: 'p$i',
        type: p.type,
        author: p.author,
        avatar: p.avatar,
        time: p.time,
        className: p.className,
        text: p.text,
        image: p.image,
        likes: p.likes,
        poll: p.poll?.map((o) => PollChoice(o.label, o.votes)).toList(),
        materialTitle: p.materialTitle,
        materialSubject: p.materialSubject,
        comments: _seedComments(p),
      ));
    }
  }

  List<Comment> _seedComments(FeedPost p) {
    // Bir-ikki namuna izoh (mavjud izoh soniga mos his qilishi uchun)
    switch (p.author.split(' ').first) {
      case 'Dilnoza':
        return [const Comment('Jasur', 'Zoʻr rasm! 🔬'), const Comment('Malika', 'Menga ham yoqdi')];
      case 'Jasur':
        return [const Comment('Sevara', 'Samarqand albatta!'), const Comment('Otabek', 'Buxoro ham zoʻr')];
      case 'Bekzod':
        return [const Comment('Nodira', 'Barakalla 📚')];
      case 'Otabek':
        return [const Comment('Dilnoza', 'Tabriklaymiz! 🎉'), const Comment('Malika', 'Zoʻr jamoa')];
      default:
        return [];
    }
  }

  void toggleLike(Post p) {
    p.likedByMe = !p.likedByMe;
    p.likes += p.likedByMe ? 1 : -1;
    if (p.likedByMe) _addPoints(p.author, 1);
    notifyListeners();
  }

  void toggleSave(Post p) {
    p.saved = !p.saved;
    notifyListeners();
  }

  List<Post> get savedPosts => feed.where((p) => p.saved).toList();

  void addComment(Post p, String text) {
    if (text.trim().isEmpty) return;
    p.comments.add(Comment(currentUser.name, text.trim()));
    _addPoints(p.author, 1);
    notifyListeners();
  }

  void votePoll(Post p, int index) {
    if (p.poll == null) return;
    if (p.myVote != null) {
      if (p.myVote == index) return;
      p.poll![p.myVote!].votes -= 1; // ovozni koʻchirish
    }
    p.poll![index].votes += 1;
    p.myVote = index;
    notifyListeners();
  }

  void addPost({required PostType type, String? text, String? image, List<String>? pollLabels, String? materialTitle, String? materialSubject}) {
    final post = Post(
      id: 'new${_postSeq++}',
      type: type,
      author: currentUser.name,
      avatar: currentUser.avatar,
      time: 'hozir',
      className: currentUser.className.replaceAll(' sinf', ''),
      text: text,
      image: image,
      poll: pollLabels?.map((l) => PollChoice(l, 0)).toList(),
      materialTitle: materialTitle,
      materialSubject: materialSubject,
      mine: true,
    );
    feed.insert(0, post);
    if (type == PostType.photo) myPostsExtra.insert(0, image ?? post.id);
    _myPoints += 3;
    addNotification('Siz yangi post joyladingiz', 'hozir');
    notifyListeners();
  }

  // Profilga qoʻshilgan yangi fotolar (grid uchun)
  final List<String> myPostsExtra = [];

  // ===== OBUNA =====
  final Set<String> _followed = {};
  bool isFollowing(String name) => _followed.contains(name);
  int followersOf(String baseName, int base) => base + (_followed.contains(baseName) ? 1 : 0);
  int get myFollowingCount => myFollowing + _followed.length;

  void toggleFollow(String name) {
    if (_followed.contains(name)) {
      _followed.remove(name);
    } else {
      _followed.add(name);
      addNotification('Siz $name ga obuna boʻldingiz', 'hozir');
      _addPoints(name, 2);
    }
    notifyListeners();
  }

  // ===== MUNOZARA (Threads) =====
  final List<Thread> threadList = [];
  int _threadSeq = 0;

  void _seedThreads() {
    for (int i = 0; i < threads.length; i++) {
      final t = threads[i];
      threadList.add(Thread(
        id: 't$i',
        author: t.author,
        text: t.text,
        time: t.time,
        likes: t.likes,
        replies: t.replies.map((r) => Reply(author: r.author, text: r.text, time: r.time, isMe: r.isMe)).toList(),
      ));
    }
  }

  void toggleThreadLike(Thread t) {
    t.likedByMe = !t.likedByMe;
    t.likes += t.likedByMe ? 1 : -1;
    notifyListeners();
  }

  void addReply(Thread t, String text) {
    if (text.trim().isEmpty) return;
    t.replies.add(Reply(author: currentUser.name, text: text.trim(), time: 'hozir', isMe: true));
    notifyListeners();
  }

  void addThread(String text) {
    if (text.trim().isEmpty) return;
    threadList.insert(0, Thread(id: 'tnew${_threadSeq++}', author: currentUser.name, text: text.trim(), time: 'hozir'));
    _myPoints += 2;
    notifyListeners();
  }

  // ===== CHAT =====
  final List<ChatMsg> chat = [];
  void _seedChat() => chat.addAll(classChat);

  void sendChat(String text) {
    if (text.trim().isEmpty) return;
    chat.add(ChatMsg(sender: 'Siz', avatar: currentUser.avatar, isMe: true, time: 'hozir', text: text.trim()));
    notifyListeners();
  }

  // ===== VAZIFALAR =====
  List<HomeworkTask> get taskList => tasks;
  void toggleTask(HomeworkTask t) {
    t.done = !t.done;
    if (t.done) _myPoints += 2;
    notifyListeners();
  }

  double get taskProgress => tasks.isEmpty ? 0 : tasks.where((t) => t.done).length / tasks.length;

  // ===== BILDIRISHNOMALAR =====
  final List<Map<String, String>> notifications = [];
  void _seedNotifications() {
    for (final a in activityFeed) {
      notifications.add({'who': a['who']!, 'action': a['action']!, 'time': a['time']!});
    }
  }

  void addNotification(String action, String time) {
    notifications.insert(0, {'who': 'Siz', 'action': action, 'time': time});
  }

  // ===== KAYFIYAT =====
  String? myMood;
  final Map<String, int> moodCounts = {'Ajoyib': 6, 'Yaxshi': 11, 'Oʻrtacha': 5, 'Charchadim': 3, 'Xafa': 1};

  void setMood(String mood) {
    if (myMood != null && moodCounts.containsKey(myMood)) {
      moodCounts[myMood!] = (moodCounts[myMood!]! - 1).clamp(0, 9999);
    }
    myMood = mood;
    moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
    notifyListeners();
  }

  int get moodTotal => moodCounts.values.fold(0, (a, b) => a + b);

  // ===== MAQTOV (KUDOS) =====
  // Har bir sinfdosh olgan maqtovlar: {ism: {label: son}}
  final Map<String, Map<String, int>> kudos = {};
  void giveKudos(String name, String label) {
    final m = kudos.putIfAbsent(name, () => {});
    m[label] = (m[label] ?? 0) + 1;
    _addPoints(name, 5);
    addNotification('Siz $name ga "$label" maqtovini berdingiz', 'hozir');
    notifyListeners();
  }

  int kudosCount(String name) => (kudos[name] ?? {}).values.fold(0, (a, b) => a + b);
  Map<String, int> kudosFor(String name) => kudos[name] ?? {};

  // ===== REYTING (POINTS) =====
  final Map<String, int> _points = {};
  int _myPoints = 24;
  void _seedPoints() {
    for (int i = 0; i < classmates.length; i++) {
      _points[classmates[i].name] = 40 - i * 2 + (classmates[i].posts * 2);
    }
  }

  void _addPoints(String name, int n) {
    if (name == currentUser.name) {
      _myPoints += n;
    } else {
      _points[name] = (_points[name] ?? 0) + n;
    }
  }

  int pointsOf(String name) => name == currentUser.name ? _myPoints : (_points[name] ?? 0);
  int get myPoints => _myPoints;

  /// Reyting jadvali (kamayish tartibida) — [ {name, points} ], joriy user ham ichida.
  List<MapEntry<String, int>> get leaderboard {
    final all = <String, int>{};
    for (final c in classmates) {
      all[c.name] = pointsOf(c.name) + kudosCount(c.name) * 3;
    }
    all[currentUser.name] = _myPoints + kudosCount(currentUser.name) * 3;
    final list = all.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return list;
  }

  int myRank() {
    final lb = leaderboard;
    for (int i = 0; i < lb.length; i++) {
      if (lb[i].key == currentUser.name) return i + 1;
    }
    return lb.length;
  }

  // ===== TUGʻILGAN KUNLAR =====
  final List<Birthday> birthdays = [];
  void _seedBirthdays() {
    birthdays.addAll([
      Birthday('Malika Yusupova', 'Bugun', 0),
      Birthday('Bekzod Aliyev', '3 kundan soʻng', 3),
      Birthday('Sevara Qodirova', '9-avgust', 5),
      Birthday('Rustam Sodiqov', '14-avgust', 10),
      Birthday('Nodira Karimova', '21-avgust', 17),
    ]);
  }

  void greet(Birthday b) {
    if (b.greeted) return;
    b.greeted = true;
    _addPoints(b.name, 2);
    // Tabrik lentaga tushadi
    feed.insert(
      0,
      Post(
        id: 'new${_postSeq++}',
        type: PostType.text,
        author: currentUser.name,
        avatar: currentUser.avatar,
        time: 'hozir',
        className: currentUser.className.replaceAll(' sinf', ''),
        text: '${b.name}, tugʻilgan kuning muborak boʻlsin! 🎉',
        mine: true,
      ),
    );
    addNotification('Siz ${b.name} ni tabrikladingiz', 'hozir');
    notifyListeners();
  }

  // ===== STORY =====
  final Set<int> seenStories = {};
  void markStorySeen(int i) {
    seenStories.add(i);
    notifyListeners();
  }

  // ===== QIDIRUV =====
  List<Classmate> searchClassmates(String q) {
    final s = q.trim().toLowerCase();
    if (s.isEmpty) return classmates;
    return classmates.where((c) => c.name.toLowerCase().contains(s) || c.bio.toLowerCase().contains(s)).toList();
  }

  List<Post> searchPosts(String q) {
    final s = q.trim().toLowerCase();
    if (s.isEmpty) return [];
    return feed.where((p) => (p.text ?? '').toLowerCase().contains(s) || p.author.toLowerCase().contains(s)).toList();
  }
}
