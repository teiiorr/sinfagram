import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../mock_data.dart';
import '../sinf_icons.dart';
import '../sinf_theme.dart';

/// Sinf chati — messenjer uslubidagi xabarlar + pastda kiritish qatori.
/// Xabarlar AppState orqali saqlanadi (backend yoʻq): yuborilgan xabar
/// darhol roʻyxatga qoʻshiladi va sessiya davomida qoladi.
class ClassChatScreen extends StatefulWidget {
  const ClassChatScreen({Key? key}) : super(key: key);

  @override
  State<ClassChatScreen> createState() => _ClassChatScreenState();
}

class _ClassChatScreenState extends State<ClassChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<AppState>().sendChat(text);
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<AppState>().chat;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('9-A sinf chati'),
      body: Column(
        children: [
          _noteCard(),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, i) =>
                  FadeInUp(index: i % 8, child: _bubble(messages[i])),
            ),
          ),
          _inputRow(),
        ],
      ),
    );
  }

  Widget _noteCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 2),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: SinfColors.purple.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(AppIcons.safety, size: 16, color: SinfColors.purple),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Shaxsiy xabarlarni hech kim (oʻqituvchi ham) oʻqimaydi',
              style: metro(size: 12, color: SinfColors.primary, weight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(ChatMsg m) {
    if (m.isMe) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(64, 4, 14, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: const BoxDecoration(
                  gradient: sinfButtonGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(m.text, style: metro(size: 14, color: Colors.white, weight: FontWeight.w500)),
                    const SizedBox(height: 3),
                    Text(m.time, style: metro(size: 10, color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final bubbleColor =
        m.isTeacher ? SinfColors.purple.withOpacity(0.10) : Colors.grey.shade100;
    final nameColor = m.isTeacher ? SinfColors.primary : SinfColors.muted;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 64, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Avatar(m.sender, radius: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (m.isTeacher)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Pill('Sinf rahbari', color: SinfColors.primary, icon: AppIcons.verify),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.sender, style: metro(size: 12, color: nameColor, weight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(m.text, style: metro(size: 14, color: Colors.black87)),
                      const SizedBox(height: 3),
                      Text(m.time, style: metro(size: 10, color: SinfColors.muted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputRow() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 1,
                  maxLines: 4,
                  style: metro(size: 14),
                  decoration: InputDecoration(
                    hintText: 'Xabar yozing...',
                    hintStyle: metro(size: 14, color: SinfColors.muted),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Pressable(
              onTap: _send,
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: sinfButtonGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(AppIcons.send, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
