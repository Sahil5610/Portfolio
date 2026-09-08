$f = 'd:\Projects\portfolio\lib\figma_portfolio.dart'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

$startIdx = $c.IndexOf('class _LogoPainter extends CustomPainter')
$endIdx   = $c.IndexOf('// ﾄﾄﾄ Hero')
if ($startIdx -lt 0 -or $endIdx -lt 0) {
    # fallback: find by plain text
    $endIdx = $c.IndexOf('const _rotatingPhrases')
}
if ($startIdx -lt 0 -or $endIdx -lt 0) { Write-Host "Anchors not found"; exit 1 }

$newPainter = @'
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

'@

$c = $c.Substring(0, $startIdx) + $newPainter + $c.Substring($endIdx)
[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "Done"
