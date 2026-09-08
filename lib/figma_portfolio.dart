import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

const _bg = Color(0xff0c041b);
const _header = Color(0xff1a0b2e);
const _purple = Color(0xff7127ba);
const _violet = Color(0xffa362ff);

// mobile < 600 | tablet 600-899 | desktop >= 900

double _fs(double w, double mobile, double tablet, double desktop) =>
    w < 600 ? mobile : w < 900 ? tablet : desktop;

class FigmaPortfolioApp extends StatelessWidget {
  const FigmaPortfolioApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sahil Tamboli | Portfolio',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: _bg,
          textTheme: GoogleFonts.preahvihearTextTheme(ThemeData.dark().textTheme),
          useMaterial3: true,
        ),
        home: const _Portfolio(),
      );
}

class _Portfolio extends StatefulWidget {
  const _Portfolio();
  @override
  State<_Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<_Portfolio> {
  final _scrollCtrl = ScrollController();
  final _home    = GlobalKey();
  final _about   = GlobalKey();
  final _skills  = GlobalKey();
  final _exp     = GlobalKey();
  final _proj    = GlobalKey();
  final _contact = GlobalKey();

  void _scroll(GlobalKey k) {
    final ctx = k.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 650), curve: Curves.easeOutCubic);
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final mobile = w < 600;
    return Scaffold(
      body: Stack(children: [
        const Positioned.fill(child: IgnorePointer(child: _Glow())),
        SingleChildScrollView(
          controller: _scrollCtrl,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _NavBar(
              scrollCtrl: _scrollCtrl,
              mobile: mobile,
              onHome:    () => _scroll(_home),
              onAbout:   () => _scroll(_about),
              onSkills:  () => _scroll(_skills),
              onExp:     () => _scroll(_exp),
              onProj:    () => _scroll(_proj),
              onContact: () => launchUrl(Uri.parse('https://www.linkedin.com/in/sahiltamboli561'), mode: LaunchMode.externalApplication),
            ),
            _Pad(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _HeroSection(key: _home),
              _IntroSection(key: _about),
              _ExperienceSection(key: _exp),
              _SkillsSection(key: _skills),
              _ProjectsSection(key: _proj),
              _ContactSection(key: _contact),
            ])),
          ]),
        ),
      ]),
    );
  }
}
// Layout helpers ───────────────────────────────────────────────────────────

class _Pad extends StatelessWidget {
  const _Pad({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w < 600 ? 16 : 32),
          child: child,
        ),
      ),
    );
  }
}

// ─── NavBar ───────────────────────────────────────────────────────────────────

// â”€â”€â”€ NavBar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _NavBar extends StatefulWidget {
  const _NavBar({
    required this.scrollCtrl,
    required this.mobile,
    required this.onHome,
    required this.onAbout,
    required this.onSkills,
    required this.onExp,
    required this.onProj,
    required this.onContact,
  });
  final ScrollController scrollCtrl;
  final bool mobile;
  final VoidCallback onHome, onAbout, onSkills, onExp, onProj, onContact;

  @override
  State<_NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<_NavBar> {
  bool _scrolled = false;
  bool _menuOpen = false;
  int _active = 0;

  static const _labels = ['Home', 'About', 'Skills', 'Experience', 'Projects', 'Contact'];

  @override
  void initState() {
    super.initState();
    widget.scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollCtrl.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final offset = widget.scrollCtrl.offset;
    final scrolled = offset > 10;
    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
    final int active;
    if (offset < 500)       active = 0;
    else if (offset < 1100) active = 1;
    else if (offset < 1700) active = 2;
    else if (offset < 2400) active = 3;
    else if (offset < 3200) active = 4;
    else                    active = 5;
    if (active != _active) setState(() => _active = active);
  }

  VoidCallback _cb(int i) =>
      [widget.onHome, widget.onAbout, widget.onSkills, widget.onExp, widget.onProj, widget.onContact][i];

  @override
  Widget build(BuildContext context) {
    final h = widget.mobile ? 60.0 : 72.0;
    return Stack(clipBehavior: Clip.none, children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: h,
        decoration: BoxDecoration(
          color: _scrolled ? _header.withOpacity(0.88) : _header,
          border: _scrolled
              ? Border(bottom: BorderSide(color: _purple.withOpacity(0.25), width: 1))
              : null,
          boxShadow: _scrolled
              ? [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 4))]
              : null,
        ),
        child: _Pad(
          child: Row(children: [
            GestureDetector(onTap: widget.onHome, child: const _Logo()),
            const Spacer(),
            if (widget.mobile)
              GestureDetector(
                onTap: () => setState(() => _menuOpen = !_menuOpen),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _menuOpen ? Icons.close_rounded : Icons.menu_rounded,
                    key: ValueKey(_menuOpen),
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              )
            else ...[
              for (int i = 0; i < _labels.length; i++) ...[
                _NavLink(label: _labels[i], active: _active == i, onTap: _cb(i)),
                if (i < _labels.length - 1) const SizedBox(width: 28),
              ],
              const SizedBox(width: 28),
              _ConnectBtn(onTap: widget.onContact),
            ],
          ]),
        ),
      ),
      if (widget.mobile && _menuOpen)
        Positioned(
          top: h,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: _header.withOpacity(0.97),
                border: Border(bottom: BorderSide(color: _purple.withOpacity(0.3), width: 1)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                for (int i = 0; i < _labels.length; i++)
                  InkWell(
                    onTap: () { setState(() => _menuOpen = false); _cb(i)(); },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: _active == i ? _violet : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        _labels[i],
                        style: GoogleFonts.plusJakartaSans(
                          color: _active == i ? _violet : Colors.white.withOpacity(0.8),
                          fontSize: 15,
                          fontWeight: _active == i ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: GestureDetector(
                    onTap: () { setState(() => _menuOpen = false); widget.onContact(); },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [_purple, Color(0xff5a1a9a)]),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: Text("Let's Connect",
                          style: GoogleFonts.plusJakartaSans(
                              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
    ]);
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;
  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final color = widget.active
        ? _violet
        : _hover ? Colors.white : Colors.white.withOpacity(0.6);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit:  (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: GoogleFonts.plusJakartaSans(
              color: color,
              fontSize: 14,
              fontWeight: widget.active ? FontWeight.w700 : FontWeight.w500,
            ),
            child: Text(widget.label),
          ),
          const SizedBox(height: 3),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: widget.active ? 20 : 0,
            decoration: BoxDecoration(
              color: _violet,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ]),
      ),
    );
  }
}

class _ConnectBtn extends StatefulWidget {
  const _ConnectBtn({required this.onTap});
  final VoidCallback onTap;
  @override
  State<_ConnectBtn> createState() => _ConnectBtnState();
}

class _ConnectBtnState extends State<_ConnectBtn> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit:  (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _hover ? [_violet, _purple] : [_purple, const Color(0xff5a1a9a)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: _hover
                  ? [BoxShadow(color: _violet.withOpacity(0.4), blurRadius: 16, spreadRadius: 1)]
                  : [],
            ),
            child: Text("Let's Connect",
                style: GoogleFonts.plusJakartaSans(
                    color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          ),
        ),
      );
}
class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) =>
      SizedBox(width: 28, height: 28, child: CustomPaint(painter: _LogoPainter()));
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = Colors.white
      ..strokeWidth = s.width * .11
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final w = s.width, h = s.height;
    final path = Path();
    // top arc of S
    path.moveTo(w * .76, h * .20);
    path.cubicTo(w * .76, h * .06, w * .24, h * .06, w * .24, h * .30);
    path.cubicTo(w * .24, h * .50, w * .76, h * .50, w * .76, h * .50);
    // bottom arc of S
    path.cubicTo(w * .76, h * .70, w * .24, h * .94, w * .24, h * .80);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_) => false;
}
const _rotatingPhrases = [
  "I'm an AI/ML Engineer.",
  "I'm a Software Developer.",
  "I'm a Cloud Enthusiast.",
  "I build intelligent applications.",
];

class _HeroSection extends StatefulWidget {
  const _HeroSection({super.key});
  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with SingleTickerProviderStateMixin {
  int _phraseIndex = 0;
  String _displayed = '';
  bool _typing = true;
  late final _cursor = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _startCursorBlink();
    _typeNext();
  }

  void _startCursorBlink() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 530));
      if (mounted) _cursor.value = !_cursor.value;
    }
  }

  void _typeNext() async {
    final phrase = _rotatingPhrases[_phraseIndex];
    // type in
    for (var i = 1; i <= phrase.length; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 55));
      setState(() { _displayed = phrase.substring(0, i); _typing = true; });
    }
    await Future.delayed(const Duration(milliseconds: 1800));
    // erase
    for (var i = phrase.length - 1; i >= 0; i--) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 32));
      setState(() { _displayed = phrase.substring(0, i); _typing = false; });
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _phraseIndex = (_phraseIndex + 1) % _rotatingPhrases.length);
      _typeNext();
    }
  }

  @override
  void dispose() {
    _cursor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final mobile = w < 600;
    final imgSize = w < 400 ? 110.0 : mobile ? 140.0 : 180.0;
    final titleSize = _fs(w, 22, 32, 42);
    final subSize = _fs(w, 13, 15, 17);

    final typingWidget = ValueListenableBuilder<bool>(
      valueListenable: _cursor,
      builder: (_, cur, __) => RichText(
        text: TextSpan(
          style: TextStyle(fontSize: titleSize, height: 1.15, letterSpacing: .4),
          children: [
            TextSpan(text: _displayed, style: const TextStyle(color: _violet)),
            TextSpan(
              text: cur ? '|' : ' ',
              style: TextStyle(color: _violet, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );

    final subheading = Text(
      'Building intelligent applications with AI, Machine Learning, Flutter & Cloud.',
      style: TextStyle(fontSize: subSize, color: Colors.white60, height: 1.5),
    );

    final heroArt = Image.asset(
      'assets/figma/hero.png',
      width: imgSize, height: imgSize, fit: BoxFit.contain,
    );

    final heroWords = Column(
      crossAxisAlignment: mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text('A Developer who',
            textAlign: mobile ? TextAlign.center : TextAlign.left,
            style: const TextStyle(fontSize: 13, decoration: TextDecoration.underline,
                color: Colors.white70)),
        const SizedBox(height: 10),
        RichText(
          textAlign: mobile ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            style: TextStyle(fontSize: _fs(w, 18, 24, 28), height: 1.2, color: Colors.white),
            children: const [
              TextSpan(text: 'Turns ideas into '),
              TextSpan(text: 'intelligent', style: TextStyle(color: _purple)),
              TextSpan(text: ' products.'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text('AI · ML · Flutter · Cloud',
            textAlign: mobile ? TextAlign.center : TextAlign.left,
            style: TextStyle(fontSize: 11, color: _violet.withOpacity(.8),
                letterSpacing: 1.2)),
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: mobile ? 44 : 88),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // avatar + tagline card
        if (mobile)
          Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [heroArt, const SizedBox(height: 20), heroWords])
        else
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            heroArt,
            const SizedBox(width: 28),
            Expanded(child: heroWords),
          ]),
        SizedBox(height: mobile ? 36 : 56),
        // animated typing heading
        typingWidget,
        const SizedBox(height: 12),
        subheading,
      ]),
    );
  }
}

// ─── Intro ────────────────────────────────────────────────────────────────────

class _IntroSection extends StatelessWidget {
  const _IntroSection({super.key});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: w < 600 ? 56 : 96),
      child: Text(
        "I'm a passionate developer focused on building intelligent, scalable, and "
        'user-centric applications. I work across AI/ML, Generative AI, NLP, Flutter, '
        'Python, databases, and cloud technologies, turning ideas into practical digital products.',
        style: TextStyle(fontSize: _fs(w, 14, 17, 20), height: 1.75, letterSpacing: .3),
      ),
    );
  }
}

// ─── Experience ───────────────────────────────────────────────────────────────

class _ExpData {
  const _ExpData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
    required this.buttonLabel,
    this.certificateAsset,
  });
  final IconData icon;
  final String title, subtitle, description, buttonLabel;
  final List<String> tags;
  final String? certificateAsset;
}

const _expItems = [
  _ExpData(
    icon: Icons.memory_rounded,
    title: 'IoT & Robotics Intern',
    subtitle: 'Incubator System | Technology  •  Jan 2026 – Feb 2026',
    description:
        'Gained hands-on experience in IoT, robotics, embedded systems, sensors, '
        'microcontrollers, and wireless communication. Worked with C++ and Python '
        'and developed Shastranetra, an IoT-based smart monitoring and surveillance system.',
    tags: ['IoT', 'Robotics', 'C++', 'Python', 'Embedded Systems'],
    buttonLabel: 'VIEW EXPERIENCE',
    certificateAsset: 'assets/certificates/internship_certificate.jpeg',
  ),
  _ExpData(
    icon: Icons.emoji_events_rounded,
    title: 'Super X Project Competition',
    subtitle: 'Core2Web  •  Achievement',
    description:
        'Participated in the Super X Project Competition organised by Core2Web '
        'and secured a position among the Top 12+ teams.',
    tags: ['Competition', 'Project Development', 'AI', 'Problem Solving'],
    buttonLabel: 'VIEW ACHIEVEMENT',
    certificateAsset: 'assets/certificates/super_x.jpg',
  ),
  _ExpData(
    icon: Icons.workspace_premium_rounded,
    title: 'Generative AI Certification',
    subtitle: 'Core2Web  •  Certification',
    description:
        'Completed hands-on training in Generative AI covering LLMs, Prompt Engineering, '
        'RAG, Vector Databases, AI Agents, LangChain, and Gemini APIs.',
    tags: ['GenAI', 'LLMs', 'RAG', 'LangChain', 'Gemini API'],
    buttonLabel: 'VIEW CERTIFICATION',
    certificateAsset: 'assets/certificates/GenAi_certificate.png',
  ),
  _ExpData(
    icon: Icons.model_training_rounded,
    title: 'AI Masterclass',
    subtitle: 'Core2Web  •  Sep 2025',
    description:
        'Completed a two-day AI Masterclass covering Artificial Intelligence, Machine Learning, '
        'Computer Vision, NLP, automation, and real-world AI applications.',
    tags: ['AI', 'Machine Learning', 'Computer Vision', 'NLP', 'Automation'],
    buttonLabel: 'VIEW TRAINING',
    certificateAsset: 'assets/certificates/python_certificate.png',
  ),
];

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection({super.key});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final mobile = w < 600;
    return Padding(
      padding: const EdgeInsets.only(bottom: 96),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Experience & Highlights',
            style: TextStyle(fontSize: _fs(w, 24, 30, 36), letterSpacing: .6)),
        const SizedBox(height: 28),
        if (mobile)
          Column(children: _expItems
              .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _ExpCard(data: e)))
              .toList())
        else
          Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _ExpCard(data: _expItems[0])),
              const SizedBox(width: 14),
              Expanded(child: _ExpCard(data: _expItems[1])),
            ]),
            const SizedBox(height: 14),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _ExpCard(data: _expItems[2])),
              const SizedBox(width: 14),
              Expanded(child: _ExpCard(data: _expItems[3])),
            ]),
          ]),
      ]),
    );
  }
}

class _ExpCard extends StatefulWidget {
  const _ExpCard({required this.data});
  final _ExpData data;
  @override
  State<_ExpCard> createState() => _ExpCardState();
}

class _ExpCardState extends State<_ExpCard> {
  bool _hover = false;

  void _openCertificate(BuildContext context, _ExpData d) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xff130428),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .9,
            maxHeight: MediaQuery.of(context).size.height * .85,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 8, 0),
              child: Row(children: [
                Expanded(
                  child: Text(d.title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffe3c7ff))),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16)),
                child: Image.asset(
                  d.certificateAsset!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.image_not_supported_rounded,
                          color: Colors.white30, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'Certificate image not found.\nPlace the file at:\n${d.certificateAsset}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white38, height: 1.6),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final mobile = w < 600;
    final d = widget.data;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(mobile ? 14 : 18),
        decoration: _cardDeco(_hover),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // icon + title row
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                      colors: [Color(0xff6b28b8), Colors.transparent])),
              child: Icon(d.icon, color: const Color(0xffe3c7ff),
                  size: mobile ? 20 : 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(d.title,
                    style: TextStyle(
                        fontSize: mobile ? 13 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 3),
                Text(d.subtitle,
                    style: TextStyle(
                        fontSize: mobile ? 10 : 11,
                        color: _violet.withOpacity(.85),
                        height: 1.4)),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          // description
          Text(d.description,
              style: TextStyle(
                  fontSize: mobile ? 11 : 12,
                  height: 1.55,
                  color: Colors.white70)),
          const SizedBox(height: 12),
          // tags
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: d.tags
                .map((t) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0x33a362ff),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0x66a362ff)),
                      ),
                      child: Text(t,
                          style: const TextStyle(
                              fontSize: 10, color: Color(0xffd3c7ff))),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          // button
          OutlinedButton(
            onPressed: d.certificateAsset != null
                ? () => _openCertificate(context, d)
                : null,
            style: OutlinedButton.styleFrom(
                minimumSize: const Size(90, 28),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                side: const BorderSide(color: Color(0xff7540ad)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: Text(d.buttonLabel,
                style: const TextStyle(fontSize: 10, color: _violet)),
          ),
        ]),
      ),
    );
  }
}

BoxDecoration _cardDeco(bool hover) => BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
          color: hover ? const Color(0xff9b54f1) : const Color(0xff5b24a1),
          width: hover ? 1.5 : 1),
      gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff130428),
            Color(0xff251043),
            Color(0xff38126d),
            Color(0xff190633)
          ]),
      boxShadow: [
        BoxShadow(
            color: hover ? const Color(0x99000000) : const Color(0x55000000),
            blurRadius: hover ? 28 : 16,
            offset: const Offset(3, 6))
      ],
    );

// ─── Skills ───────────────────────────────────────────────────────────────────

const _cats = [
  _Cat('AI & Machine Learning', Icons.psychology_rounded, [
    'Machine Learning', 'Deep Learning', 'Generative AI',
    'Natural Language Processing', 'Large Language Models',
    'Prompt Engineering', 'AI Application Development', 'Model Development',
  ]),
  _Cat('Cloud & AWS', Icons.cloud_rounded, [
    'AWS', 'Amazon EC2', 'Amazon S3', 'AWS IAM', 'Amazon VPC',
    'Subnets', 'Security Groups', 'Application Load Balancer',
    'Target Groups', 'Auto Scaling', 'Amazon RDS', 'Amazon Route 53',
    'Cloud Computing', 'Linux Server Administration', 'Nginx',
  ]),
  _Cat('Development', Icons.code_rounded, [
    'Python', 'Flutter', 'Dart', 'SQL', 'HTML5', 'CSS3',
    'REST APIs', 'Responsive UI Development', 'Cross-Platform Development',
  ]),
  _Cat('Databases', Icons.storage_rounded, [
    'MySQL', 'SQL', 'Relational Database Design',
  ]),
  _Cat('Tools & Technologies', Icons.build_rounded, [
    'Git', 'GitHub', 'VS Code', 'Figma', 'Postman', 'Linux', 'Vim',
  ]),
];

class _Cat {
  const _Cat(this.title, this.icon, this.skills);
  final String title;
  final IconData icon;
  final List<String> skills;
}

class _SkillsSection extends StatelessWidget {
  const _SkillsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final mobile = w < 600;
    final cols = w < 600 ? 1 : w < 900 ? 2 : 3;
    return Padding(
      padding: const EdgeInsets.only(bottom: 96),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Skills',
            style: TextStyle(fontSize: _fs(w, 24, 30, 36), letterSpacing: .6)),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: mobile ? 13 : 14, height: 1.5, color: Colors.white70),
            children: const [
              TextSpan(text: 'Technologies and tools I work with across '),
              TextSpan(
                  text: 'AI, Cloud, and Software Development',
                  style: TextStyle(color: _violet)),
              TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _SkillGrid(cols: cols),
      ]),
    );
  }
}

class _SkillGrid extends StatelessWidget {
  const _SkillGrid({required this.cols});
  final int cols;
  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < _cats.length; i += cols) {
      final slice = _cats.sublist(i, (i + cols).clamp(0, _cats.length));
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var j = 0; j < slice.length; j++) ...[
            if (j > 0) const SizedBox(width: 14),
            Expanded(child: _SkillCard(cat: slice[j])),
          ],
          for (var k = slice.length; k < cols; k++) ...[
            const SizedBox(width: 14),
            const Expanded(child: SizedBox()),
          ],
        ],
      ));
      if (i + cols < _cats.length) rows.add(const SizedBox(height: 14));
    }
    return Column(children: rows);
  }
}

class _SkillCard extends StatefulWidget {
  const _SkillCard({required this.cat});
  final _Cat cat;
  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: _cardDeco(_hover),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: const Color(0x336b28b8),
                    borderRadius: BorderRadius.circular(7)),
                child: Icon(widget.cat.icon, color: _violet, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(widget.cat.title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffe3c7ff))),
              ),
            ]),
            const SizedBox(height: 12),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: widget.cat.skills.map(_chip).toList(),
            ),
          ]),
        ),
      );

  Widget _chip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0x33a362ff),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x66a362ff)),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 10, color: Color(0xffd3c7ff))),
      );
}

// ─── Projects ─────────────────────────────────────────────────────────────────

class _ProjData {
  const _ProjData({required this.title, required this.desc, required this.tags, this.img});
  final String title, desc;
  final List<String> tags;
  final String? img;
}

const _projs = [
  _ProjData(
    title: 'AI Resume Reviewer Agent',
    img: 'assets/project/Resume_reveiver.png',
    desc: 'An AI-powered resume review agent that compares resumes with job descriptions, identifies missing skills, generates ATS improvement suggestions, and creates personalized interview questions using RAG and Generative AI.',
    tags: ['Python', 'LangChain', 'RAG', 'Gemini API', 'FastAPI', 'ChromaDB', 'Streamlit'],
  ),
  _ProjData(
    title: 'Smart Challan',
    img: 'assets/project/smart_challan.png',
    desc: 'A RAG-based AI system that retrieves vehicle and traffic violation records and generates accurate, context-aware challans using semantic search and Generative AI.',
    tags: ['Python', 'GenAI', 'RAG', 'LlamaIndex', 'ChromaDB', 'Gemini API', 'FastAPI'],
  ),
  _ProjData(
    title:'BayMax', 
    img:'assets/project/Bay_max.png',
    desc: 'An AI-powered mobile application built with Flutter and Firebase for symptom tracking, health monitoring, emergency support, and secure cloud-based health record management.',
    tags: ['Flutter', 'Dart', 'Firebase', 'AI', 'Mobile Development'],
  ),
  _ProjData(
    title: 'Foodie AI',
    img: 'assets/project/Foodie_ai.png',
    desc: 'An AI-powered food discovery and recommendation application that helps users explore food options and receive personalized recommendations based on their preferences.',
    tags: ['Streamlit', 'FastApi', 'AI', 'Python', 'RAG','LlamaIndex','API Integration','VectorDB'],
  ),
];

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final mobile = w < 600;
    final gap = SizedBox(height: mobile ? 48 : 80);
    return Padding(
      padding: const EdgeInsets.only(bottom: 96),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Featured Projects',
            style: TextStyle(fontSize: _fs(w, 24, 30, 36), letterSpacing: .6)),
        const SizedBox(height: 48),
        _ProjectRow(proj: _projs[0], reverse: false),
        gap,
        _ProjectRow(proj: _projs[1], reverse: true),
        gap,
        _ProjectRow(proj: _projs[2], reverse: false),
        gap,
        _ProjectRow(proj: _projs[3], reverse: true),
      ]),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  const _ProjectRow({required this.proj, required this.reverse});
  final _ProjData proj;
  final bool reverse;
  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 600;
    final text = _ProjectText(proj: proj, alignRight: reverse && !mobile);
    final img = _ProjectImg(proj: proj);
    if (mobile) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [text, const SizedBox(height: 18), img]);
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: reverse
        ? [Expanded(child: img), const SizedBox(width: 36), Expanded(child: text)]
        : [Expanded(child: text), const SizedBox(width: 36), Expanded(child: img)]);
  }
}

class _ProjectText extends StatelessWidget {
  const _ProjectText({required this.proj, required this.alignRight});
  final _ProjData proj;
  final bool alignRight;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final mobile = w < 600;
    final cross = alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final align = alignRight ? TextAlign.right : TextAlign.left;
    return Column(crossAxisAlignment: cross, children: [
      Text('Featured Project',
          textAlign: align,
          style: TextStyle(fontSize: mobile ? 11 : 13, color: _violet, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      Text(proj.title,
          textAlign: align,
          style: TextStyle(fontSize: _fs(w, 20, 26, 32), color: const Color(0xffd7d5ff), fontWeight: FontWeight.w600)),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xee241f42), borderRadius: BorderRadius.circular(10)),
        child: Text(proj.desc, textAlign: align,
            style: TextStyle(fontSize: mobile ? 12 : 13, height: 1.55, color: const Color(0xffd3d1e9))),
      ),
      const SizedBox(height: 12),
      Wrap(
        alignment: alignRight ? WrapAlignment.end : WrapAlignment.start,
        spacing: 6, runSpacing: 6,
        children: proj.tags.map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0x33a362ff),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x66a362ff)),
          ),
          child: Text(t, style: const TextStyle(fontSize: 10, color: Color(0xffd3c7ff))),
        )).toList(),
      ),
    ]);
  }
}

class _ProjectImg extends StatefulWidget {
  const _ProjectImg({required this.proj});
  final _ProjData proj;
  @override
  State<_ProjectImg> createState() => _ProjectImgState();
}

class _ProjectImgState extends State<_ProjectImg> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = w < 600 ? 180.0 : 220.0;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: h,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xff1a0b2e),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _hover ? const Color(0xff9b54f1) : const Color(0xff3d1a6e)),
          boxShadow: [BoxShadow(
              color: _hover ? const Color(0xbb7127ba) : const Color(0x887127ba),
              blurRadius: _hover ? 56 : 40, spreadRadius: 3)],
        ),
        child: widget.proj.img != null
            ? Image.asset(widget.proj.img!, fit: BoxFit.cover, width: double.infinity)
            : _ProjPlaceholder(title: widget.proj.title),
      ),
    );
  }
}

class _ProjPlaceholder extends StatelessWidget {
  const _ProjPlaceholder({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xff1a0b2e), Color(0xff2d1060), Color(0xff1a0b2e)]),
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(shape: BoxShape.circle,
            border: Border.all(color: const Color(0x66a362ff), width: 1.5)),
        child: const Icon(Icons.code_rounded, color: _violet, size: 28),
      ),
      const SizedBox(height: 10),
      Text(title, textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Color(0xffe3c7ff), fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      const Text('Screenshot coming soon', style: TextStyle(fontSize: 10, color: Colors.white30)),
    ]),
  );
}
class _ContactSection extends StatelessWidget {
  const _ContactSection({super.key});

  static Future<void> _launch(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  static const _items = [
    _ContactItem(
      icon: Icons.email_outlined,
      label: 'Email',
      display: 'sahiltamboli561@gmail.com',
      url: 'mailto:sahiltamboli561@gmail.com',
    ),
    _ContactItem(
      icon: Icons.phone_outlined,
      label: 'Phone',
      display: '+91 9130681232',
      url: 'tel:+919130681232',
    ),
    _ContactItem(
      icon: Icons.link_rounded,
      label: 'LinkedIn',
      display: 'Sahil Tamboli',
      url: 'https://www.linkedin.com/in/sahiltamboli561',
    ),
    _ContactItem(
      icon: Icons.code_rounded,
      label: 'GitHub',
      display: 'Sahil5610',
      url: 'https://github.com/Sahil5610',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final mobile = w < 600;
    return Padding(
      padding: const EdgeInsets.only(bottom: 72),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Contact', style: TextStyle(fontSize: _fs(w, 22, 26, 28))),
        const SizedBox(height: 40),
        Text(
          "I'm always excited to work on challenging problems and build meaningful products with AI, Machine "
          "Learning, Flutter, and Cloud technologies. Have a project or opportunity in mind? Let's connect.",
          style: TextStyle(fontSize: mobile ? 13 : 14, height: 1.8),
        ),
        const SizedBox(height: 32),
        mobile
            ? Column(
                children: _items
                    .map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ContactCard(item: item, onTap: () => _launch(item.url)),
                        ))
                    .toList(),
              )
            : Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _items
                    .map((item) => SizedBox(
                          width: (w.clamp(0, 1100) - 64 - 48) / 4,
                          child: _ContactCard(item: item, onTap: () => _launch(item.url)),
                        ))
                    .toList(),
              ),
      ]),
    );
  }
}

class _ContactItem {
  const _ContactItem({
    required this.icon,
    required this.label,
    required this.display,
    required this.url,
  });
  final IconData icon;
  final String label, display, url;
}

class _ContactCard extends StatefulWidget {
  const _ContactCard({required this.item, required this.onTap});
  final _ContactItem item;
  final VoidCallback onTap;
  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit:  (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff130428), Color(0xff190633)],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hover ? _violet.withOpacity(0.6) : _purple.withOpacity(0.25),
              width: 1,
            ),
            boxShadow: _hover
                ? [BoxShadow(color: _violet.withOpacity(0.18), blurRadius: 18, spreadRadius: 1)]
                : [],
          ),
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _purple.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.item.icon, color: _violet, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  widget.item.label,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.item.display,
                  style: GoogleFonts.plusJakartaSans(
                    color: _hover ? _violet : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ]),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: _hover ? _violet : Colors.white.withOpacity(0.2),
              size: 13,
            ),
          ]),
        ),
      ),
    );
  }
}
class _Glow extends StatelessWidget {
  const _Glow();
  @override
  Widget build(BuildContext context) => Stack(children: const [
        _GlowBlob(top: 800, size: 420),
        _GlowBlob(top: 2200, size: 380),
        _GlowBlob(top: 3000, size: 360),
      ]);
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.top, required this.size});
  final double top, size;
  @override
  Widget build(BuildContext context) => Positioned(
        top: top,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                  colors: [Color(0x557127ba), Color(0x007127ba)], stops: [0, .7]),
            ),
          ),
        ),
      );
}
