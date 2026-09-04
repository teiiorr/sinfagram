# Product decisions (deviations from spec)

Per `docs/14` ("Never add a feature not in docs/08/09 without an explicit product
decision recorded in this repository"), deliberate departures from the spec are
logged here.

## 2026-08-04 · Chalkboard header on the class feed (S10)

**Decision.** The class feed (`day_page_screen.dart`) shows a green wooden
classroom chalkboard at the top, with chalk-style handwriting (bundled `Caveat`
font) displaying the day's title, date, class label and a short chalk motto.

**Deviates from.** `docs/05 §5` ("nothing decorative"), `§5.2` (Inter only),
`§5.3`/`§8` (no wood/skeuomorphism, flat surfaces). Scope is contained to the
single `ChalkBoard` widget; the rest of the app remains flat and on-token.

**Requested by.** Product owner (teiior), directly. A warm, familiar classroom
cue at the top of the pupil's most-opened screen.

**Reversible.** Remove the `ChalkBoard` from `_dayList` and the `Caveat` font
entry to return to a fully spec-flat feed.

## 2026-08-04 · Elevated "best modern" design language

**Decision.** The product owner asked for a radically more modern, delightful,
animated look — bolder than the spec's austere baseline. The visual layer is
upgraded across the whole app: richer motion tokens (springier curves, slightly
longer, more noticeable entrances/transitions), a gradient accent on hero
surfaces and primary CTAs, layered soft depth, a tasteful skeleton shimmer,
animated bottom-nav indicators, staggered list entrances, and press/spring
micro-interactions.

**Deviates from.** `docs/05 §5` (flat, "nothing decorative", no gradients/glow),
`docs/06` (minimal 200–300 ms motion, no shimmer, "remove any animation you can").
This is an explicit product override of the visual restraint — the information
architecture, safety rules, privacy and no-dark-pattern constraints are
UNCHANGED.

**Guardrails kept.** All motion is compositing-only (Transform/Opacity),
RepaintBoundary around animated cards, honours `MediaQuery.disableAnimations`
(reduce-motion), and targets 60 fps on the low-end reference device (docs/11).

**Requested by.** Product owner (teiior), directly and emphatically.

---

## D-07 — Instagram-style social layer (2026-09-01)

**Deviation.** The Ministry spec deliberately restrains social mechanics (no
public counters, finite chronological day-page, no vanity features). The product
owner explicitly overrode this for the class-social experience, asking for a
"creative, colourful, non-governmental" Instagram-like app. Added:

- **Stories** — a top-of-feed ring tray, full-screen viewer (progress bars,
  tap/hold/swipe, auto-advance), and the pupil's own story (add caption slides).
  Slides are **text on a per-author gradient** — no child/AI imagery.
- **Rich profile "About me"** — editable bio, "now reading" (book), "now
  listening" (music), and interests chips (`me_screen` editor + `Person` model).
- **Classmates grid** — restored the older "one button → all classmates pop in
  with animation" (staggered `Reveal`), each opening a colourful person profile.
- **Friends carousel** — on the board (доска): an auto-advancing, swipeable,
  animated `PageView` of "which friend wrote what, and when".
- **Double-tap to thank** — Instagram-style heart burst on `PostCard`
  (compositing-only; only ever *adds* thanks, never removes; honours
  reduce-motion). The private, count-less thanks model from the spec is kept.
- **Real photo attach** — `image_picker` from the device gallery, previewed in
  the composer and rendered in the post (device photos only; never AI/remote).

**Privacy kept.** No DMs between pupils, no public per-pupil tallies, no
collection of phone/address/PINFL/biometrics. Personality fields are text the
pupil chooses to share. All imagery is either the user's own device photo or a
decorative gradient placeholder — never AI or photorealistic imagery of minors.

## D-08 — Local persistence via shared_preferences (2026-09-01)

**Deviation / interim.** docs/11 specifies a drift cache + outbox behind the
repositories. Until that lands, the pupil's own user-generated content —
profile ("About me"), story slides, composed posts, and the private thanks set —
is persisted with `shared_preferences` (JSON) so it survives an app restart
("чтобы работало"). The providers keep the same public API, so the drift/outbox
layer slots in behind them unchanged. Injected via a `ProviderScope` override in
`main()` (`sharedPrefsProvider`).

## D-09 — Instagram-parallel information architecture (2026-09-01)

**Deviation.** Product owner asked to go past MVP and make it "to the ideal",
fully Instagram-like. Bottom navigation is now 5 slots: **Lenta** (photos-only
feed + stories + auto-advancing friends slide, 3s) · **Munozara** (text/threads
discussions with reply/like/repost) · **➕ Create** (centre action → photo/video
to Lenta, text to Munozara) · **Oʻyinlar** (clearer games hub + a new rapid-quiz
game) · **Profil** (Instagram-exact layout).

Key rules kept from the product owner's own answers:
- **Count-less by design** — the IG-look profile shows NO follower/post/like
  numbers (their explicit choice), preserving the spec's no-public-counters
  privacy rule while looking like Instagram.
- **Likes are red** (filled heart) with a red double-tap burst; **reposts** added
  (count-less, green when active, "You reposted" marker).
- Feed carries only media posts; text posts route to Munozara. Board (доска)
  keeps its button but is now school-info only (the friends slide moved into the
  feed). Chronicle (Solnoma) moved into the profile as a tab.

Posts split by `Post.hasMedia`; new derived providers `feedPhotoPostsProvider`,
`munozaraPostsProvider`, `repostedPostsProvider`. All still count-less and
privacy-preserving; all motion compositing-only + reduce-motion.

## D-10 — "Play" visual redesign from Claude Design handoff (2026-09-01)

**Source.** Product owner supplied a Claude Design handoff ("Sinfagram — Play
mobile redesign", `Sinfagram Play.dc.html` + README) — a high-fidelity spec with
exact tokens. Applied to the pupil app.

**Foundation changes (lib/core/theme + shared):**
- **Fonts** — replaced Inter on pupil surfaces with **Baloo 2** (display/titles/
  scores/initials) + **Fredoka** (body/labels). Bundled variable fonts in
  `fonts/baloo2` + `fonts/fredoka` (OFL, from google/fonts); default family set
  in `app_theme` (Fredoka base merged under Baloo 2 slots). This is the single
  biggest driver of the playful feel (Inter read as institutional).
- **Palette** — exact handoff tokens: soft lavender `bg #F3EFFF` (never stark
  white), violet `primary #6A4CE6`, warm semantics; full dark set.
- **Shadows** — signature **violet-tinted glow** (not neutral grey) on cards /
  nav / lifts.
- **Radii** — bigger & softer: cards 26, nav 28, hero 24, chip 10, control 15,
  FAB 20, feed header bottom 42.
- **Gradients** — feed hero, avatar ring, battle, league, static conic story
  ring; `AppGradients.of()` now accent→darker-35%.
- **Motion** — playful overshoot entrance `cubic(.2,.9,.28,1.3)` (Reveal, 560ms,
  65ms stagger) + bouncy press squish `cubic(.34,1.56,.64,1)` (TapScale, nav
  blob). All compositing-only + reduce-motion.
- **Nav** — floating rounded bar + sliding `primarySubtle` blob + gradient
  rounded-square create FAB.

**Two product tweaks (this session):** feed carries the **school-board slide
only** (friends carousel removed on request); **story rings do not spin** (static
conic ring; viewer auto-advance kept).

All D-07/D-08/D-09 product constraints preserved: count-less, private "Rahmat",
double-tap only adds, anonymous reports, no DMs, no AI/real imagery of minors.
`Sinfagram.dc.html` (earlier flatter iteration) was superseded per the handoff.

## D-11 — Strict Instagram design system (supersedes D-10 "Play") (2026-09-05)

**Deviation / reversal.** Product owner supplied a detailed "content-first
Instagram" design brief and asked to redo the design from scratch. This
**replaces** the D-10 "Play" look. Foundation:
- **No custom font** — styles omit fontFamily so each platform renders its
  native UI face (SF Pro / Roboto). Baloo 2 + Fredoka unregistered.
- **Palette** — white canvas, black text, one blue action `#0095F6`, red
  `#ED4956` for like/error; everything else grey. Dark theme = pure black
  inversion; blue + story ring unchanged between themes.
- **No shadows on static elements** — `Shadows.card/soft/lift` are empty;
  shadows only on dropdown/modal/toast.
- **No gradients** except `AppGradients.storyRing` (classic IG 45° ring).
- **Radii** — feed media 0 (full-bleed), posts are not cards (0), buttons 8,
  fields 4, modals/sheets 12, previews 8, avatars round.
- **Type scale** — small & exact, nothing >16px in chrome; icon-only actions.
- **Motion** — `Reveal` is now a pass-through (no entrance/scroll animations);
  `TapScale` presses with opacity 0.7 (not scale). Like/double-tap burst kept.

**Product constraints preserved** (D-07/08/09): count-less (no follower/post/
like numbers), private "Rahmat", reposts count-less + icon-only, no DMs,
anonymous reports, no AI/real imagery of minors. The two prior tweaks stand:
feed shows the school-board slide only (friends carousel removed); story rings
static (no spin).
