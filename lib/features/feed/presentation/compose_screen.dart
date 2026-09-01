import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/features/feed/application/day_page_controller.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';
import 'package:sinfagram/shared/widgets/post_video.dart';

/// S12 — full-screen composer for a new class post (docs/08 §Day page).
///
/// Owns the text controller and a local `hasPhoto` flag, so it is a
/// [ConsumerStatefulWidget]. The screen wears an app-bar-style top row — a close
/// (X) on the left, the centred title, and a primary [AppButton] on the right,
/// enabled only once the trimmed text is non-empty; on press it hands the body to
/// [DayPageController.addPost] and pops back to the day page — the feed provider
/// notifies the list, so this screen never rebuilds it by hand.
///
/// The real post would go through the content filter and may return
/// CONTENT_HELD; here [DayPageController.addPost] appends optimistically.
class ComposeScreen extends ConsumerStatefulWidget {
  const ComposeScreen({super.key});

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  final TextEditingController _controller = TextEditingController();

  // The body input lives in its own focus scope so the first-frame autofocus
  // lands on the text field rather than the top bar's controls. Focus is driven
  // by traversal within this scope (the field is the only focusable inside it).
  final FocusScopeNode _bodyScope = FocusScopeNode();

  // Real media picked from the device, attached to the post. A post carries at
  // most one of photo / video (picking one clears the other). Null = text-only.
  final ImagePicker _picker = ImagePicker();
  String? _photoPath;
  String? _videoPath;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _bodyScope.nextFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _bodyScope.dispose();
    super.dispose();
  }

  // Rebuild on every keystroke so the post button re-evaluates enabled state.
  void _handleChanged() => setState(() {});

  bool get _canPost => _controller.text.trim().isNotEmpty;

  void _submit() {
    ref.read(dayPageProvider.notifier).addPost(
          _controller.text,
          photoPath: _photoPath,
          videoPath: _videoPath,
        );
    context.pop();
  }

  Future<void> _pickPhoto() async {
    if (_photoPath != null) {
      setState(() => _photoPath = null); // tap again to remove
      return;
    }
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (file != null && mounted) {
      setState(() {
        _photoPath = file.path;
        _videoPath = null; // photo and video are mutually exclusive
      });
    }
  }

  Future<void> _pickVideo() async {
    if (_videoPath != null) {
      setState(() => _videoPath = null); // tap again to remove
      return;
    }
    final XFile? file = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 2),
    );
    if (file != null && mounted) {
      setState(() {
        _videoPath = file.path;
        _photoPath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final authorName = ref.watch(sessionProvider)?.displayName ?? 'Siz';
    // ?mode=text opens a pure text composer (→ Munozara); ?mode=photo / no mode
    // keeps the media buttons (→ Lenta).
    final isTextMode =
        GoRouterState.of(context).uri.queryParameters['mode'] == 'text';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context, l, colors),
            Expanded(
              child: FocusScope(
                node: _bodyScope,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    Space.gutter,
                    Space.md,
                    Space.gutter,
                    Space.xxl,
                  ),
                  children: [
                    Row(
                      children: [
                        Avatar(name: authorName, size: 40),
                        const SizedBox(width: Space.sm),
                        Expanded(
                          child: Text(
                            authorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodyStrong
                                .copyWith(color: colors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Space.md),
                    // Borderless, box-free body input — the placeholder carries
                    // the prompt and the field grows with the text.
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 5,
                      maxLines: null,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(500),
                      ],
                      cursorColor: colors.primary,
                      style: AppText.body.copyWith(color: colors.textPrimary),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: l.composeHint,
                        hintStyle:
                            AppText.body.copyWith(color: colors.textTertiary),
                      ),
                    ),
                    const SizedBox(height: Space.md),
                    if (_photoPath != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Radii.media),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child:
                              Image.file(File(_photoPath!), fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: Space.sm),
                    ],
                    if (_videoPath != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Radii.media),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: PostVideo(path: _videoPath!),
                        ),
                      ),
                      const SizedBox(height: Space.sm),
                    ],
                    if (!isTextMode)
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              l.composePhoto,
                              onPressed: _pickPhoto,
                              variant: AppButtonVariant.secondary,
                              // Flips to a check once a real image is attached;
                              // tap again to remove it.
                              icon: _photoPath != null
                                  ? LucideIcons.check
                                  : LucideIcons.image,
                            ),
                          ),
                          const SizedBox(width: Space.sm),
                          Expanded(
                            child: AppButton(
                              l.composeVideo,
                              onPressed: _pickVideo,
                              variant: AppButtonVariant.secondary,
                              icon: _videoPath != null
                                  ? LucideIcons.check
                                  : LucideIcons.video,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// App-bar-style header: close (X) left, centred title, post button right.
  /// A [Stack] keeps the title truly centred regardless of the side controls'
  /// widths. The post button is a primary [AppButton] — the brand gradient when
  /// there is text to post, its own flat disabled fill otherwise.
  Widget _topBar(BuildContext context, AppL10n l, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.all(Space.sm),
      child: SizedBox(
        height: 48,
        child: Stack(
          children: [
            Center(
              child: Text(
                l.composeTitle,
                style: AppText.h3.copyWith(color: colors.textPrimary),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => context.pop(),
                tooltip: l.actionCancel,
                icon: Icon(LucideIcons.x, color: colors.textSecondary),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton(
                l.composePost,
                onPressed: _canPost ? _submit : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
