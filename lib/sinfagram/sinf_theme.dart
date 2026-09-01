import 'package:flutter/material.dart';

/// Sinfagram dizayn tizimi — mavjud ilova uslubidan olingan
/// (Metropolis shrifti, 32-radiusli oq kartalar, binafsha→oltin gradient).
class SinfColors {
  static const primary = Color(0xFF9B2282); // story ring boshi
  static const accent = Color(0xFFEEA863); // story ring oxiri
  static const purple = Colors.purple;
  static const deepPurple = Colors.deepPurple;
  static const blue = Colors.blueAccent;
  static const bg = Colors.white;
  static const text = Colors.black;
  static Color muted = Colors.grey.shade600;
}

const kFont = 'Poppins';

// Story-ring / karta urgʻu gradienti (mavjud story_widget'dan).
const sinfRingGradient = LinearGradient(
  colors: [Color(0xFF9B2282), Color(0xFFEEA863)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// Tugma gradienti (mavjud login/welcome'dan).
const sinfButtonGradient = LinearGradient(
  colors: [Colors.purple, Colors.deepPurple, Colors.blueAccent],
  begin: Alignment.bottomRight,
  end: Alignment.topLeft,
);

TextStyle metro({
  double size = 14,
  FontWeight weight = FontWeight.w500,
  Color color = Colors.black,
  double? spacing,
}) =>
    TextStyle(
      fontFamily: kFont,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: spacing,
    );

/// Oq AppBar — mavjud ekranlar bilan bir xil. titleWidget berilsa (masalan
/// Billabong logotip) matn o'rniga u ishlatiladi.
AppBar sinfAppBar(String title, {List<Widget>? actions, bool back = true, Widget? titleWidget}) => AppBar(
      automaticallyImplyLeading: back,
      elevation: 0.0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      title: titleWidget ??
          Text(
            title,
            style: momo(size: 22),
          ),
      actions: actions,
    );

/// Standart oq karta (radius 32, yumshoq soya) — post kartasi uslubida.
class SinfCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  const SinfCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Material(
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Bo'lim sarlavhasi (ixtiyoriy "Ko'proq" tugmasi bilan).
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader(this.title, {Key? key, this.action, this.onAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(title, style: momo(size: 19), overflow: TextOverflow.ellipsis)),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!, style: metro(size: 13, color: SinfColors.purple, weight: FontWeight.w600))),
        ],
      ),
    );
  }
}

/// Gradientli "pill" tugma (login uslubi).
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  const GradientButton({Key? key, required this.label, this.onTap, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          gradient: sinfButtonGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, color: Colors.white, size: 18), const SizedBox(width: 8)],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: metro(color: Colors.white, weight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ayol ismlari (birinchi ism) — qolganlari erkak deb olinadi.
const Set<String> _femaleFirstNames = {
  'dilnoza', 'malika', 'nodira', 'sevara', 'gulnora', 'madina', 'nigora', 'zilola',
  'kamola', 'aziza', 'feruza', 'sevinch', 'shahnoza', 'dildora', 'muslima', 'rayhona',
  'zarina', 'nilufar', 'oygul', 'gulbahor', 'mohira', 'sabina', 'diyora', 'robiya',
  'xadicha', 'maftuna', 'zebo', 'barno', 'nozima', 'charos', 'sitora', 'yulduz',
  'iroda', 'dilfuza', 'munisa', 'shoira', 'oysha', 'gulchehra', 'dilrabo', 'nafisa',
  'zuhra', 'laylo', 'mehri', 'sarvinoz', 'gavhar', 'komila', 'saida', 'ruxsora',
};

bool _isFemaleName(String name) {
  final letters = name.toLowerCase().replaceAll(RegExp(r"[^a-zʻ']"), ' ').trim();
  if (letters.isEmpty) return false;
  final first = letters.split(RegExp(r'\s+')).first;
  return _femaleFirstNames.contains(first);
}

int _nameHash(String s) {
  var h = 0;
  for (final c in s.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  return h;
}

/// Ochiq (Twemoji) multfilm personaj-avatari: erkak ismga oʻgʻil, ayol ismga qiz.
/// Real bolalar emas, offline, ishonchli.
class Avatar extends StatelessWidget {
  final String name;
  final double radius;
  final bool ring;
  const Avatar(this.name, {Key? key, this.radius = 22, this.ring = false}) : super(key: key);

  static const _bg = [
    Color(0xFFFDE7F1),
    Color(0xFFE7EEFD),
    Color(0xFFE7F7EF),
    Color(0xFFFDF1E1),
    Color(0xFFF1E9FB),
    Color(0xFFE6F5FA),
    Color(0xFFFBE9E9),
  ];

  static const _fg = [
    Color(0xFF9B2282),
    Color(0xFF6A4CAF),
    Color(0xFF2F72C6),
    Color(0xFF2E9E83),
    Color(0xFFC77A22),
    Color(0xFFB3436B),
    Color(0xFF4B7BA6),
  ];

  @override
  Widget build(BuildContext context) {
    final h = _nameHash(name);
    final female = _isFemaleName(name);
    final fg = _fg[(h ~/ 7) % _fg.length];
    // Erkak → mashina, ayol → gul (real foto). Orqada ikonka — foto chiqmasa ham bo'sh bo'lmaydi.
    final circle = Container(
      width: radius * 2,
      height: radius * 2,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(shape: BoxShape.circle, color: _bg[h % _bg.length]),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(child: Icon(female ? Icons.local_florist : Icons.directions_car, color: fg, size: radius * 1.2)),
          Image.asset(
            mediaAsset(name, h),
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
    if (!ring) return circle;
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: const BoxDecoration(shape: BoxShape.circle, gradient: sinfRingGradient),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: circle,
      ),
    );
  }
}

/// Sderjan, tabiiy yorliq — ikonka + rangli matn (to'ldirilgan "pill" emas).
class Pill extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const Pill(this.text, {Key? key, this.color = Colors.purple, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 15, color: color), const SizedBox(width: 6)],
        Text(text, style: metro(size: 12, color: color, weight: FontWeight.w600, spacing: 0.1)),
      ],
    );
  }
}

/// Katta gradientli banner-sarlavha (bo'lim ustidagi hero).
class SinfHero extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const SinfHero({Key? key, required this.title, required this.subtitle, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: sinfButtonGradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: momo(size: 24, color: Colors.white)),
                const SizedBox(height: 6),
                Text(subtitle, style: metro(size: 13, color: Colors.white70)),
              ],
            ),
          ),
          Icon(icon, color: Colors.white, size: 40),
        ],
      ),
    );
  }
}

// ===================== TIPOGRAFIYA =====================

/// Billabong — skript logotip/sarlavha (Instagram uslubidagi "kayf").
TextStyle billabong({double size = 28, Color color = Colors.black}) =>
    TextStyle(fontFamily: 'Billabong', fontSize: size, color: color, fontWeight: FontWeight.w400);

TextStyle pacifico({double size = 20, Color color = Colors.black}) =>
    TextStyle(fontFamily: 'Pacifico', fontSize: size, color: color);

/// Momo Trust Display — sarlavhalar uchun (rounded display, kreativ + chiroyli).
TextStyle momo({double size = 20, Color color = Colors.black, FontWeight weight = FontWeight.w400}) =>
    TextStyle(fontFamily: 'MomoTrust', fontSize: size, color: color, fontWeight: weight, letterSpacing: 0.2);

/// AppBar uchun "Sinfagram" skript logotipi.
Widget sinfWordmark({double size = 27, Color color = Colors.black}) =>
    Text('Sinfagram', style: billabong(size: size, color: color));

// ===================== ANIMATSIYALAR =====================

/// Ro'yxat elementlari uchun pastdan silliq paydo bo'lish (fade + slide up).
/// `index` bilan bosqichma-bosqich (staggered) effekt beriladi.
class FadeInUp extends StatelessWidget {
  final Widget child;
  final int index;
  final double offset;
  final Duration duration;
  const FadeInUp({Key? key, required this.child, this.index = 0, this.offset = 26, this.duration = const Duration(milliseconds: 480)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration + Duration(milliseconds: 70 * index),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.translate(offset: Offset(0, offset * (1 - t)), child: child),
      ),
      child: child,
    );
  }
}

/// Bosilganda silliq kichrayadigan wrapper (delight uchun).
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  const Pressable({Key? key, required this.child, this.onTap, this.scale = 0.96}) : super(key: key);

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Silliq sahifa o'tishi (fade + pastdan surilish).
Route<T> sinfRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (context, animation, secondary, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Rasm yuklanayotganda shimmer-placeholder.
class Shimmer extends StatefulWidget {
  final double? width;
  final double height;
  final double radius;
  const Shimmer({Key? key, this.width, this.height = 120, this.radius = 20}) : super(key: key);
  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 - 2 * _c.value, 0),
              end: Alignment(1 - 2 * _c.value, 0),
              colors: [Colors.grey.shade200, Colors.grey.shade100, Colors.grey.shade200],
            ),
          ),
        );
      },
    );
  }
}

// ===================== DIZAYNERLIK MUQOVA (tarmoqsiz, ishonchli) =====================
// Foto o'rniga: gradient + mavzuga mos emoji. Hech qachon "buzuq" bo'lmaydi,
// real odamlar/bolalar yo'q, offline ishlaydi.

const List<List<Color>> _coverGradients = [
  [Color(0xFF8B2FC9), Color(0xFFEF5DA8)], // binafsha → magenta
  [Color(0xFF2F80ED), Color(0xFF12B39B)], // koʻk → teal
  [Color(0xFFEF5DA8), Color(0xFFF2994A)], // pushti → sariq
  [Color(0xFF12B39B), Color(0xFF27AE60)], // teal → yashil
  [Color(0xFFF2994A), Color(0xFFEB4D8C)], // sariq → pushti
  [Color(0xFF5B5BD6), Color(0xFF2F80ED)], // indigo → koʻk
  [Color(0xFF8B2FC9), Color(0xFFF2994A)], // binafsha → sariq
  [Color(0xFFEF5DA8), Color(0xFF5B5BD6)], // magenta → indigo
];

int _seedHash(String s) {
  var h = 0;
  for (final c in s.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  return h;
}

// Material ikonka (har doim renderlanadi — emoji "tofu" muammosi yoʻq).
IconData _iconForSeed(String seed) {
  final s = seed.toLowerCase();
  if (s.contains('chess') || s.contains('shaxmat')) return Icons.grid_view_rounded;
  if (s.contains('book') || s.contains('library') || s.contains('read') || s.contains('kitob')) return Icons.menu_book_rounded;
  if (s.contains('lab') || s.contains('science') || s.contains('micro') || s.contains('chem')) return Icons.science_rounded;
  if (s.contains('black') || s.contains('chalk') || s.contains('board')) return Icons.co_present_rounded;
  if (s.contains('globe') || s.contains('geo') || s.contains('map')) return Icons.public_rounded;
  if (s.contains('note') || s.contains('pen') || s.contains('pencil')) return Icons.edit_note_rounded;
  if (s.contains('art') || s.contains('paint')) return Icons.palette_rounded;
  if (s.contains('music') || s.contains('instrument')) return Icons.music_note_rounded;
  if (s.contains('robot') || s.contains('tech') || s.contains('comput') || s.contains('cod') || s.contains('digital')) return Icons.computer_rounded;
  if (s.contains('theater') || s.contains('stage') || s.contains('drama')) return Icons.theater_comedy_rounded;
  if (s.contains('sport') || s.contains('ball') || s.contains('foot')) return Icons.sports_soccer_rounded;
  if (s.contains('nature') || s.contains('plant') || s.contains('garden') || s.contains('flower') || s.contains('eco')) return Icons.eco_rounded;
  if (s.contains('solar') || s.contains('energy')) return Icons.wb_sunny_rounded;
  if (s.contains('news') || s.contains('writ')) return Icons.article_rounded;
  if (s.contains('star') || s.contains('telescope') || s.contains('astro')) return Icons.auto_awesome_rounded;
  if (s.contains('desk') || s.contains('class') || s.contains('school')) return Icons.school_rounded;
  if (s.contains('calc') || s.contains('math')) return Icons.calculate_rounded;
  const pool = [
    Icons.menu_book_rounded,
    Icons.science_rounded,
    Icons.edit_note_rounded,
    Icons.palette_rounded,
    Icons.public_rounded,
    Icons.computer_rounded,
    Icons.calculate_rounded,
    Icons.music_note_rounded,
    Icons.school_rounded,
    Icons.auto_awesome_rounded,
  ];
  return pool[_seedHash(seed) % pool.length];
}

/// Post/muqova rasmi o'rniga dizaynerlik gradient karta.
class SinfPhoto extends StatelessWidget {
  final String seed;
  final double? height;
  final double radius;
  const SinfPhoto(this.seed, {Key? key, this.height, this.radius = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final g = _coverGradients[_seedHash(seed) % _coverGradients.length];
    final icon = _iconForSeed(seed);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        width: height == null ? null : double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: g, begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            final hh = c.maxHeight.isFinite ? c.maxHeight : (height ?? 120);
            final ww = c.maxWidth.isFinite ? c.maxWidth : hh;
            final base = hh < ww ? hh : ww;
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  right: -base * 0.22,
                  top: -base * 0.22,
                  child: Container(
                    width: base * 0.75,
                    height: base * 0.75,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.10)),
                  ),
                ),
                Positioned(
                  left: -base * 0.18,
                  bottom: -base * 0.18,
                  child: Container(
                    width: base * 0.5,
                    height: base * 0.5,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.06)),
                  ),
                ),
                Center(child: Icon(icon, size: base * 0.4, color: Colors.white.withOpacity(0.92))),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ===================== SOCHLI (JUICY) DIZAYN =====================

/// Yorqin, "sochli" bo'lim ranglari.
const List<Color> kJuicy = [
  Color(0xFF8B2FC9), // binafsha
  Color(0xFF2F80ED), // ko'k
  Color(0xFF12B39B), // teal
  Color(0xFFF2994A), // to'q sariq
  Color(0xFFEB4D8C), // pushti
  Color(0xFF27AE60), // yashil
  Color(0xFFEF5DA8), // magenta
  Color(0xFF5B5BD6), // indigo
];

Color juicyFor(String seed) {
  var h = 0;
  for (final c in seed.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  return kJuicy[h % kJuicy.length];
}

/// Katta ikonka + "oq havo" li chiroyli karta (bosilganda animatsiya).
class BigIconCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final VoidCallback? onTap;
  final bool wide;
  const BigIconCard({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.color,
    this.onTap,
    this.wide = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.94,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.16), blurRadius: 24, offset: const Offset(0, 12)),
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, Color.lerp(color, Colors.white, 0.28)!], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: color.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 6))],
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 18),
            Text(title, style: metro(size: 15.5, weight: FontWeight.w700)),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!, style: metro(size: 12, color: SinfColors.muted), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ],
        ),
      ),
    );
  }
}

// ===================== MASHINA / GUL MEDIASI =====================
// Erkak ism → mashina fotosi, ayol ism → gul fotosi (har xil, real).
String mediaAsset(String name, int variant) {
  final female = _isFemaleName(name);
  final n = (variant % 10) + 1;
  return female ? 'assets/flowers/flower$n.jpg' : 'assets/cars/car$n.jpg';
}

/// Post/story/to'r uchun real foto (egasi jinsiga qarab mashina yoki gul).
class PostMedia extends StatelessWidget {
  final String owner; // egasining ismi (jinsni aniqlaydi)
  final String seed; // qaysi rasm (barqaror)
  final double? height;
  final double radius;
  final BoxFit fit;
  const PostMedia(this.owner, this.seed, {Key? key, this.height, this.radius = 0, this.fit = BoxFit.cover}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final female = _isFemaleName(owner);
    // Orqada — ikonka (foto renderlanmasa ham hech qachon boʻsh boʻlmaydi).
    final stack = Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: female ? const Color(0xFFFCE7F0) : const Color(0xFFE7EEFB),
          alignment: Alignment.center,
          child: Icon(female ? Icons.local_florist : Icons.directions_car, color: female ? const Color(0xFFD6488E) : const Color(0xFF3E74C8), size: 46),
        ),
        Image.asset(
          mediaAsset(owner, _nameHash(seed)),
          fit: fit,
          errorBuilder: (c, e, s) => const SizedBox.shrink(),
        ),
      ],
    );
    final sized = height == null ? stack : SizedBox(height: height, width: double.infinity, child: stack);
    if (radius <= 0) return sized;
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: sized);
  }
}
