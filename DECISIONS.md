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
