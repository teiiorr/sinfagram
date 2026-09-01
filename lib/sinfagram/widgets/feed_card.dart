import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mock_data.dart' show PostType, currentUser;
import '../app_state.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';

/// Sinf lentasidagi post — foto Instagram uslubida (jonli: layk, izoh, saqlash),
/// soʻrovnoma/savol/material karta koʻrinishida (ovoz berish ishlaydi).
class FeedCard extends StatefulWidget {
  final Post post;
  const FeedCard({Key? key, required this.post}) : super(key: key);

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> with SingleTickerProviderStateMixin {
  late final AnimationController _burst = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

  @override
  void dispose() {
    _burst.dispose();
    super.dispose();
  }

  void _like() => context.read<AppState>().toggleLike(widget.post);

  void _doubleTapLike() {
    if (!widget.post.likedByMe) context.read<AppState>().toggleLike(widget.post);
    _burst.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.post.type) {
      case PostType.photo:
        return _instagramPost();
      case PostType.poll:
        return _poll();
      case PostType.material:
        return _material();
      case PostType.question:
        return _textCard(questionTag: true);
      case PostType.text:
        return _textCard();
    }
  }

  // ---------------- INSTAGRAM USLUBIDAGI FOTO POST ----------------
  Widget _instagramPost() {
    final p = widget.post;
    final username = p.author.split(' ').first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: Row(
            children: [
              Avatar(p.author, radius: 18, ring: true),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.author, style: metro(size: 13.5, weight: FontWeight.w700)),
                    Text('${p.className} · ${p.time}', style: metro(size: 11.5, color: SinfColors.muted)),
                  ],
                ),
              ),
              const Icon(AppIcons.more, color: Colors.black87, size: 22),
            ],
          ),
        ),
        // Rasm (4:5 vertikal — mobil uslub) + ikki marta bosib layk
        GestureDetector(
          onDoubleTap: _doubleTapLike,
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PostMedia(p.author, p.image ?? p.id, fit: BoxFit.cover),
                _BurstHeart(_burst),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 12, 2),
          child: Row(
            children: [
              _IgLike(liked: p.likedByMe, onTap: _like),
              const SizedBox(width: 18),
              _IconBtn(AppIcons.comment, () => openComments(context, p)),
              const SizedBox(width: 18),
              _IconBtn(AppIcons.send, () => _shared(context)),
              const Spacer(),
              _IconBtn(p.saved ? AppIcons.saveFill : AppIcons.save, () => context.read<AppState>().toggleSave(p),
                  color: p.saved ? SinfColors.primary : Colors.black87),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 2, 14, 0),
          child: Text('${p.likes} yoqtirish', style: metro(size: 13.5, weight: FontWeight.w700)),
        ),
        if (p.text != null && p.text!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
            child: Text.rich(TextSpan(style: metro(size: 13.5), children: [
              TextSpan(text: '$username ', style: metro(size: 13.5, weight: FontWeight.w700)),
              TextSpan(text: p.text!),
            ])),
          ),
        if (p.comments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 5, 14, 0),
            child: GestureDetector(
              onTap: () => openComments(context, p),
              child: Text('Barcha ${p.comments.length} izohni koʻrish', style: metro(size: 12.5, color: SinfColors.muted)),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 5, 14, 16),
          child: Text(p.time, style: metro(size: 10.5, color: SinfColors.muted, spacing: 0.2)),
        ),
      ],
    );
  }

  void _shared(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sinfdoshingizga yuborildi'), duration: Duration(milliseconds: 900)),
    );
  }

  // ---------------- KARTA HEADER/FOOTER ----------------
  Widget _cardHeader() {
    final p = widget.post;
    return Row(
      children: [
        Avatar(p.author, radius: 20, ring: true),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.author, style: metro(size: 14, weight: FontWeight.w700)),
              Text('${p.className} · ${p.time}', style: metro(size: 12, color: SinfColors.muted)),
            ],
          ),
        ),
        const Icon(AppIcons.more, size: 20, color: Colors.black54),
      ],
    );
  }

  Widget _cardFooter() {
    final p = widget.post;
    return Row(
      children: [
        _IgLike(liked: p.likedByMe, onTap: _like, size: 22),
        const SizedBox(width: 7),
        Text('${p.likes}', style: metro(size: 13, color: SinfColors.muted, weight: FontWeight.w600)),
        const SizedBox(width: 20),
        _IconBtn(AppIcons.comment, () => openComments(context, p), size: 22, color: Colors.black54),
        const SizedBox(width: 7),
        Text('${p.comments.length}', style: metro(size: 13, color: SinfColors.muted, weight: FontWeight.w600)),
        const Spacer(),
        _IconBtn(p.saved ? AppIcons.saveFill : AppIcons.save, () => context.read<AppState>().toggleSave(p),
            size: 22, color: p.saved ? SinfColors.primary : Colors.black54),
      ],
    );
  }

  Widget _textCard({bool questionTag = false}) {
    final p = widget.post;
    return SinfCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(),
          const SizedBox(height: 8),
          if (questionTag)
            Padding(padding: const EdgeInsets.only(bottom: 8), child: Pill('Savol', color: Colors.orange.shade800, icon: AppIcons.question)),
          if (p.text != null) Text(p.text!, style: metro(size: 15)),
          const SizedBox(height: 14),
          _cardFooter(),
        ],
      ),
    );
  }

  Widget _poll() {
    final p = widget.post;
    final total = p.totalVotes;
    final voted = p.myVote != null;
    return SinfCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(),
          const SizedBox(height: 6),
          Padding(padding: const EdgeInsets.only(bottom: 4), child: Pill("Soʻrovnoma", color: SinfColors.purple, icon: AppIcons.poll)),
          if (p.text != null) Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text(p.text!, style: metro(size: 15, weight: FontWeight.w600))),
          for (int i = 0; i < p.poll!.length; i++) _pollOption(p, i, total, voted),
          const SizedBox(height: 6),
          Text(voted ? '$total ovoz · ovozingiz qabul qilindi' : '$total ovoz · tanlang', style: metro(size: 12, color: SinfColors.muted)),
          const SizedBox(height: 8),
          _cardFooter(),
        ],
      ),
    );
  }

  Widget _pollOption(Post p, int i, int total, bool voted) {
    final o = p.poll![i];
    final pct = total == 0 ? 0.0 : o.votes / total;
    final mine = p.myVote == i;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Pressable(
        onTap: () => context.read<AppState>().votePoll(p, i),
        scale: 0.98,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Icon(mine ? AppIcons.check : Icons.circle_outlined,
                    size: 16, color: mine ? SinfColors.primary : Colors.grey.shade400),
                const SizedBox(width: 7),
                Text(o.label, style: metro(size: 13.5, weight: mine ? FontWeight.w700 : FontWeight.w500)),
              ]),
              if (voted) Text('${(pct * 100).round()}%', style: metro(size: 12, color: SinfColors.purple, weight: FontWeight.bold)),
            ]),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: voted ? pct : 0.0),
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutCubic,
                builder: (_, v, __) => LinearProgressIndicator(
                  value: v,
                  minHeight: 9,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(mine ? SinfColors.primary : SinfColors.purple.withOpacity(0.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _material() {
    final p = widget.post;
    return SinfCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: SinfColors.blue.withOpacity(0.08), borderRadius: BorderRadius.circular(18)),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(gradient: sinfButtonGradient, borderRadius: BorderRadius.circular(14)),
                child: const Icon(AppIcons.material, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.materialTitle ?? 'Material', style: metro(size: 14, weight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(p.materialSubject ?? '', style: metro(size: 12, color: SinfColors.muted)),
                ]),
              ),
              Pressable(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Material yuklab olindi'), duration: Duration(milliseconds: 900)),
                ),
                child: const Icon(AppIcons.arrowRight, color: SinfColors.purple),
              ),
            ]),
          ),
          if (p.text != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(p.text!, style: metro(size: 14))),
          const SizedBox(height: 14),
          _cardFooter(),
        ],
      ),
    );
  }
}

// ---------------- IZOHLAR (bottom sheet) ----------------
void openComments(BuildContext context, Post p) {
  final ctrl = TextEditingController();
  final app = context.read<AppState>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
    builder: (sheetCtx) {
      return ChangeNotifierProvider.value(
        value: app,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.45,
            maxChildSize: 0.92,
            expand: false,
            builder: (c, scroll) => Column(
              children: [
                const SizedBox(height: 10),
                Container(width: 42, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3))),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text('Izohlar', style: momo(size: 18)),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Consumer<AppState>(
                    builder: (c, s, _) {
                      if (p.comments.isEmpty) {
                        return Center(child: Text('Hozircha izoh yoʻq — birinchi boʻling!', style: metro(size: 13, color: SinfColors.muted)));
                      }
                      return ListView.builder(
                        controller: scroll,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        itemCount: p.comments.length,
                        itemBuilder: (c, i) {
                          final cm = p.comments[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Avatar(cm.author, radius: 17),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(cm.author, style: metro(size: 13, weight: FontWeight.w700)),
                                      const SizedBox(height: 2),
                                      Text(cm.text, style: metro(size: 13.5)),
                                      const SizedBox(height: 2),
                                      Text(cm.time, style: metro(size: 10.5, color: SinfColors.muted)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 8, 12),
                  child: Row(
                    children: [
                      Avatar(currentUserName, radius: 16),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: ctrl,
                          decoration: InputDecoration(
                            hintText: 'Izoh yozing...',
                            hintStyle: metro(size: 13.5, color: SinfColors.muted),
                            border: InputBorder.none,
                          ),
                          style: metro(size: 13.5),
                        ),
                      ),
                      Builder(builder: (c) {
                        return IconButton(
                          icon: const Icon(AppIcons.send, color: SinfColors.primary),
                          onPressed: () {
                            s_send(c, p, ctrl);
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void s_send(BuildContext context, Post p, TextEditingController ctrl) {
  final t = ctrl.text.trim();
  if (t.isEmpty) return;
  context.read<AppState>().addComment(p, t);
  ctrl.clear();
  FocusScope.of(context).unfocus();
}

// currentUser ismini olish uchun kichik yordamchi (mock_data import qilmay)
String get currentUserName => currentUser.name;

/// Instagram uslubidagi yoqtirish tugmasi — bosilganda pulsatsiya.
class _IgLike extends StatefulWidget {
  final bool liked;
  final VoidCallback onTap;
  final double size;
  const _IgLike({Key? key, required this.liked, required this.onTap, this.size = 27}) : super(key: key);

  @override
  State<_IgLike> createState() => _IgLikeState();
}

class _IgLikeState extends State<_IgLike> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  late final Animation<double> _s = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.45).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
    TweenSequenceItem(tween: Tween(begin: 1.45, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 50),
  ]).animate(_c);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _c.forward(from: 0);
        widget.onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _s,
        child: Icon(
          widget.liked ? AppIcons.heartFill : AppIcons.heart,
          size: widget.size,
          color: widget.liked ? const Color(0xFFED4956) : Colors.black87,
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color color;
  const _IconBtn(this.icon, this.onTap, {Key? key, this.size = 26, this.color = Colors.black87}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Icon(icon, size: size, color: color),
    );
  }
}

/// Ikki marta bosilganda paydo boʻladigan katta yurak (Instagram effekti).
class _BurstHeart extends StatelessWidget {
  final AnimationController c;
  const _BurstHeart(this.c, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: c,
      builder: (_, __) {
        if (c.value == 0 || c.value == 1) return const SizedBox.shrink();
        final scale = 0.6 + 0.6 * Curves.easeOutBack.transform(c.value.clamp(0.0, 1.0));
        final opacity = c.value < 0.5 ? 1.0 : (1 - (c.value - 0.5) * 2);
        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: scale,
            child: const Icon(AppIcons.heartFill, color: Colors.white, size: 96),
          ),
        );
      },
    );
  }
}
