import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../mock_data.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';

/// "Yangi post" tabi — sinf lentasiga haqiqiy post joylash (AppState orqali).
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  int _type = 0;
  bool _hasImage = false;
  final TextEditingController _controller = TextEditingController();
  final List<TextEditingController> _options = [TextEditingController(), TextEditingController()];

  static const _types = [
    _PostTypeInfo('Post', AppIcons.material),
    _PostTypeInfo('Savol', AppIcons.question),
    _PostTypeInfo('Soʻrovnoma', AppIcons.poll),
    _PostTypeInfo('Material', AppIcons.book),
  ];

  static const _hints = [
    'Nima yangiliklar? Faqat oʻz sinfing koʻradi',
    'Savolingni yoz — sinfdoshlaring javob beradi',
    'Soʻrovnoma savolini yoz, variantlarni pastda qoʻsh',
    'Material nomini yoz',
  ];

  @override
  void dispose() {
    _controller.dispose();
    for (final c in _options) c.dispose();
    super.dispose();
  }

  void _submit() {
    final app = context.read<AppState>();
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Avval matn yozing')));
      return;
    }
    switch (_type) {
      case 1:
        app.addPost(type: PostType.question, text: text);
        break;
      case 2:
        final opts = _options.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();
        if (opts.length < 2) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kamida 2 ta variant kiriting')));
          return;
        }
        app.addPost(type: PostType.poll, text: text, pollLabels: opts);
        break;
      case 3:
        app.addPost(type: PostType.material, materialTitle: text, materialSubject: 'Material', text: 'Yangi material qoʻshildi');
        break;
      default:
        if (_hasImage) {
          app.addPost(type: PostType.photo, text: text, image: 'me${DateTime.now().microsecond}');
        } else {
          app.addPost(type: PostType.text, text: text);
        }
    }
    FocusScope.of(context).unfocus();
    _controller.clear();
    for (final c in _options) c.clear();
    setState(() => _hasImage = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post sinf lentasiga joylandi ✓'), duration: Duration(milliseconds: 1100)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Yangi post', back: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 28),
        children: [
          FadeInUp(index: 0, child: _authorRow()),
          const SizedBox(height: 16),
          FadeInUp(index: 1, child: _typeSelector()),
          const SizedBox(height: 16),
          FadeInUp(index: 2, child: _textField()),
          if (_type == 2) ...[
            const SizedBox(height: 12),
            FadeInUp(index: 3, child: _pollOptions()),
          ],
          if (_type == 0) ...[
            const SizedBox(height: 14),
            FadeInUp(index: 3, child: _imageBox()),
          ],
          const SizedBox(height: 20),
          FadeInUp(index: 4, child: GradientButton(label: 'Joylash', icon: AppIcons.send, onTap: _submit)),
          const SizedBox(height: 16),
          FadeInUp(index: 5, child: _note()),
        ],
      ),
    );
  }

  Widget _authorRow() {
    return Row(
      children: [
        Avatar(currentUser.name, radius: 24, ring: true),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentUser.name, style: metro(size: 15, weight: FontWeight.w700)),
            const SizedBox(height: 3),
            Pill(currentUser.className, color: SinfColors.purple, icon: AppIcons.people),
          ],
        ),
      ],
    );
  }

  Widget _typeSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(22)),
      child: Row(
        children: List.generate(_types.length, (i) {
          final selected = _type == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _type = i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                decoration: BoxDecoration(gradient: selected ? sinfButtonGradient : null, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Icon(_types[i].icon, size: 20, color: selected ? Colors.white : SinfColors.muted),
                    const SizedBox(height: 6),
                    Text(_types[i].label, maxLines: 1, overflow: TextOverflow.ellipsis, style: metro(size: 11, weight: FontWeight.w700, color: selected ? Colors.white : SinfColors.muted)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _textField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.grey.shade200)),
      child: TextField(
        controller: _controller,
        maxLines: 6,
        minLines: 4,
        style: metro(size: 15, weight: FontWeight.w500),
        cursorColor: SinfColors.purple,
        decoration: InputDecoration(border: InputBorder.none, hintText: _hints[_type], hintStyle: metro(size: 15, color: SinfColors.muted, weight: FontWeight.w500)),
      ),
    );
  }

  Widget _pollOptions() {
    return Column(
      children: [
        for (int i = 0; i < _options.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                    child: TextField(
                      controller: _options[i],
                      style: metro(size: 14),
                      decoration: InputDecoration(border: InputBorder.none, hintText: '${i + 1}-variant', hintStyle: metro(size: 14, color: SinfColors.muted)),
                    ),
                  ),
                ),
                if (_options.length > 2)
                  IconButton(
                    icon: const Icon(AppIcons.close, color: Colors.black38),
                    onPressed: () => setState(() => _options.removeAt(i)),
                  ),
              ],
            ),
          ),
        if (_options.length < 4)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _options.add(TextEditingController())),
              icon: const Icon(AppIcons.add, size: 18, color: SinfColors.purple),
              label: Text('Variant qoʻshish', style: metro(size: 13, color: SinfColors.purple, weight: FontWeight.w600)),
            ),
          ),
      ],
    );
  }

  Widget _imageBox() {
    if (_hasImage) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: AspectRatio(aspectRatio: 4 / 5, child: PostMedia(currentUser.name, 'newpost')),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Pressable(
              onTap: () => setState(() => _hasImage = false),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(AppIcons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: () => setState(() => _hasImage = true),
      child: CustomPaint(
        painter: _DashedRectPainter(color: Colors.grey.shade400, radius: 22),
        child: Container(
          height: 120,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(AppIcons.camera, size: 30, color: SinfColors.muted),
              const SizedBox(height: 10),
              Text('Rasm qoʻshish', style: metro(size: 13, weight: FontWeight.w600, color: SinfColors.muted)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _note() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(AppIcons.safety, size: 16, color: SinfColors.muted),
        const SizedBox(width: 8),
        Expanded(
          child: Text('Post faqat 9-A sinf lentasida koʻrinadi. Anonim post yoʻq.', style: metro(size: 12, color: SinfColors.muted, weight: FontWeight.w500)),
        ),
      ],
    );
  }
}

class _PostTypeInfo {
  final String label;
  final IconData icon;
  const _PostTypeInfo(this.label, this.icon);
}

/// Nuqtali (dashed) yumaloq ramka chizuvchi — "Rasm qoʻshish" qutisi uchun.
class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  const _DashedRectPainter({required this.color, this.radius = 22});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    const dashWidth = 6.0;
    const dashSpace = 5.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next.clamp(0, metric.length)), paint);
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) => oldDelegate.color != color || oldDelegate.radius != radius;
}
