$file = 'd:\Projects\portfolio\lib\figma_portfolio.dart'
$src = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

# ── Splice 1: Replace _PortfolioState (from "class _PortfolioState" to just before "// ﾄﾄﾄ Layout")
$startA = $src.IndexOf('class _PortfolioState')
$endA   = $src.IndexOf('Layout helpers')
if ($startA -lt 0 -or $endA -lt 0) { Write-Host "ANCHOR A not found"; exit 1 }

$newState = @'
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
              onContact: () => _scroll(_contact),
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

'@

$src = $src.Substring(0, $startA) + $newState + $src.Substring($endA)

# ── Splice 2: Replace _NavBar + _NavLink (from "// ﾄﾄﾄ NavBar" to just before "class _Logo")
$startB = $src.IndexOf('class _NavBar')
$endB   = $src.IndexOf('class _Logo extends StatelessWidget')
if ($startB -lt 0 -or $endB -lt 0) { Write-Host "ANCHOR B not found"; exit 1 }

$newNav = @'
// ─── NavBar ──────────────────────────────────────────────────────────────────

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

'@

$src = $src.Substring(0, $startB) + $newNav + $src.Substring($endB)

[System.IO.File]::WriteAllText($file, $src, [System.Text.Encoding]::UTF8)
Write-Host "Done"
