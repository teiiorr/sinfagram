import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';

/// Munozara — Threads uslubidagi ekran: matnli postlar + koʻrinadigan javoblar.
/// Jonli: layk, javob, yangi mavzu AppState orqali saqlanadi.
class ThreadsScreen extends StatefulWidget {
  const ThreadsScreen({Key? key}) : super(key: key);

  @override
  State<ThreadsScreen> createState() => _ThreadsScreenState();
}

class _ThreadsScreenState extends State<ThreadsScreen> {
  final _composer = TextEditingController();

  @override
  void dispose() {
    _composer.dispose();
    super.dispose();
  }

  void _post() {
    final t = _composer.text.trim();
    if (t.isEmpty) return;
    context.read<AppState>().addThread(t);
    _composer.clear();
    FocusScope.of(context).unfocus();
  }

  void _reply(Thread th) {
    final ctrl = TextEditingController();
    final app = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 18, right: 18, top: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${th.author}ga javob', style: momo(size: 17)),
            const SizedBox(height: 10),
            TextField(
              controller: ctrl,
              autofocus: true,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Javobingiz...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: GradientButton(
                label: 'Javob berish',
                icon: AppIcons.send,
                onTap: () {
                  final r = ctrl.text.trim();
                  if (r.isEmpty) return;
                  app.addReply(th, r);
                  Navigator.pop(ctx);
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final threadsList = context.watch<AppState>().threadList;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Munozara'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 6, bottom: 12),
              itemCount: threadsList.length,
              itemBuilder: (context, i) => FadeInUp(index: i % 6, child: _threadCard(threadsList[i])),
            ),
          ),
          _composerBar(),
        ],
      ),
    );
  }

  Widget _threadCard(Thread th) {
    return SinfCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(th.author, radius: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(th.author, style: metro(size: 14, weight: FontWeight.w700))),
              Text(th.time, style: metro(size: 11.5, color: SinfColors.muted)),
            ],
          ),
          const SizedBox(height: 8),
          Text(th.text, style: metro(size: 14.5)),
          const SizedBox(height: 10),
          Row(
            children: [
              _LikeButton(
                liked: th.likedByMe,
                count: th.likes,
                onTap: () => context.read<AppState>().toggleThreadLike(th),
              ),
              const SizedBox(width: 20),
              Pressable(
                onTap: () => _reply(th),
                child: Row(children: [
                  const Icon(AppIcons.comment, size: 19, color: Color(0xFF8A8A8E)),
                  const SizedBox(width: 6),
                  Text('${th.replies.length}', style: metro(size: 13, color: SinfColors.muted, weight: FontWeight.w600)),
                ]),
              ),
            ],
          ),
          if (th.replies.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.grey.shade200, width: 2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: th.replies.map(_replyRow).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _replyRow(Reply r) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(r.author, radius: 13),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(r.author, style: metro(size: 12.5, weight: FontWeight.w700)),
                  const SizedBox(width: 6),
                  Text(r.time, style: metro(size: 10.5, color: SinfColors.muted)),
                ]),
                const SizedBox(height: 1),
                Text(r.text, style: metro(size: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _composerBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _composer,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Nimadir yozing...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Pressable(
              onTap: _post,
              child: Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: sinfButtonGradient),
                child: const Icon(AppIcons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Yoqtirish tugmasi — bosilganda kichik "bounce" animatsiya (kayf).
class _LikeButton extends StatefulWidget {
  final bool liked;
  final int count;
  final VoidCallback onTap;
  const _LikeButton({Key? key, required this.liked, required this.count, required this.onTap}) : super(key: key);

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
    TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 50),
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
      child: Row(children: [
        ScaleTransition(
          scale: _scale,
          child: Icon(widget.liked ? AppIcons.heartFill : AppIcons.heart, size: 20, color: widget.liked ? const Color(0xFFED4956) : SinfColors.muted),
        ),
        const SizedBox(width: 6),
        Text('${widget.count}', style: metro(size: 13, color: SinfColors.muted, weight: FontWeight.w600)),
      ]),
    );
  }
}
