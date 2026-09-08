$bytes = [System.IO.File]::ReadAllBytes('lib\figma_portfolio.dart')
$content = [System.Text.Encoding]::UTF8.GetString($bytes)

$startMarker = 'class _ProjectsSection'
$endMarker = 'class _ContactSection'

$start = $content.IndexOf($startMarker)
$end = $content.IndexOf($endMarker)

$before = $content.Substring(0, $start)
$after = $content.Substring($end)

$newSection = @'
class _ProjData {
  const _ProjData({required this.title, required this.desc, required this.tags, this.img});
  final String title, desc;
  final List<String> tags;
  final String? img;
}

const _projs = [
  _ProjData(
    title: 'AI Resume Reviewer Agent',
    desc: 'An AI-powered resume review agent that compares resumes with job descriptions, identifies missing skills, generates ATS improvement suggestions, and creates personalized interview questions using RAG and Generative AI.',
    tags: ['Python', 'LangChain', 'RAG', 'Gemini API', 'FastAPI', 'ChromaDB', 'Streamlit'],
  ),
  _ProjData(
    title: 'Smart Challan',
    desc: 'A RAG-based AI system that retrieves vehicle and traffic violation records and generates accurate, context-aware challans using semantic search and Generative AI.',
    tags: ['Python', 'GenAI', 'RAG', 'LlamaIndex', 'ChromaDB', 'Gemini API', 'FastAPI'],
  ),
  _ProjData(
    title: 'BayMax',
    desc: 'An AI-powered mobile application built with Flutter and Firebase for symptom tracking, health monitoring, emergency support, and secure cloud-based health record management.',
    tags: ['Flutter', 'Dart', 'Firebase', 'AI', 'Mobile Development'],
  ),
  _ProjData(
    title: 'Foodie AI',
    desc: 'An AI-powered food discovery and recommendation application that helps users explore food options and receive personalized recommendations based on their preferences.',
    tags: ['Flutter', 'Dart', 'AI', 'Python', 'API Integration'],
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

'@

$result = $before + $newSection + $after
[System.IO.File]::WriteAllText('lib\figma_portfolio.dart', $result, [System.Text.Encoding]::UTF8)
Write-Output "Done"
