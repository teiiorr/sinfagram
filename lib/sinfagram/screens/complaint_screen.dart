import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// "Maxfiy shikoyat" — sabab tanlash + izoh (backend yo'q, faqat SnackBar).
class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  int _selected = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Shikoyating maxfiy yuborildi. Rahmat.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Maxfiy shikoyat'),
      body: ListView(
        padding: const EdgeInsets.only(top: 6, bottom: 28),
        children: [
          FadeInUp(
            index: 0,
            child: SinfCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: SinfColors.purple.withOpacity(0.08), shape: BoxShape.circle),
                    child: const Icon(AppIcons.lock, color: SinfColors.purple, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Shikoyating anonim emas, lekin MAXFIY — isming faqat masʼul kattalarga koʻrinadi.',
                      style: metro(size: 14, weight: FontWeight.w500).copyWith(height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FadeInUp(index: 1, child: const SectionHeader('Sabab')),
          ...List.generate(complaintReasons.length, (i) {
            final selected = _selected == i;
            return FadeInUp(
              index: i + 2,
              child: SinfCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                onTap: () => setState(() => _selected = i),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? SinfColors.purple : Colors.grey.shade400,
                          width: 2,
                        ),
                        color: selected ? SinfColors.purple : Colors.transparent,
                      ),
                      child: selected
                          ? const Icon(AppIcons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        complaintReasons[i],
                        style: metro(
                          size: 15,
                          weight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? SinfColors.primary : SinfColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          FadeInUp(index: complaintReasons.length + 2, child: const SectionHeader('Izoh')),
          FadeInUp(
            index: complaintReasons.length + 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 5,
                  style: metro(size: 14, weight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Nima boʻldi?',
                    hintStyle: metro(size: 14, color: SinfColors.muted),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          FadeInUp(
            index: complaintReasons.length + 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: GradientButton(
                label: 'Yuborish',
                icon: AppIcons.send,
                onTap: _submit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
