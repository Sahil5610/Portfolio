$file = 'd:\Projects\portfolio\lib\figma_portfolio.dart'
$src = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

$startIdx = $src.IndexOf('class _ContactSection extends StatelessWidget')
$endIdx   = $src.IndexOf('// ') # find next top-level comment after contact section

# More precise end: find the Ambient glow comment
$endIdx = $src.IndexOf('class _Glow extends StatelessWidget')
if ($startIdx -lt 0 -or $endIdx -lt 0) { Write-Host "Anchors not found"; exit 1 }

$newContact = @'
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

'@

$src = $src.Substring(0, $startIdx) + $newContact + $src.Substring($endIdx)
[System.IO.File]::WriteAllText($file, $src, [System.Text.Encoding]::UTF8)
Write-Host "Done"
