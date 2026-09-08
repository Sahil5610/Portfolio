$file = 'd:\Projects\portfolio\lib\figma_portfolio.dart'
$src = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

# Fix 1: line 94 — missing "// " prefix on the Layout helpers comment
$src = $src.Replace("`nLayout helpers ", "`n// Layout helpers ")

# Fix 2: _ExperienceSection constructor — add {super.key}
$src = $src.Replace("const _ExperienceSection();", "const _ExperienceSection({super.key});")

# Fix 3: _SkillsSection constructor — add {super.key}
$src = $src.Replace("const _SkillsSection();", "const _SkillsSection({super.key});")

# Fix 4: _ContactSection constructor — add {super.key}
$src = $src.Replace("const _ContactSection();", "const _ContactSection({super.key});")

[System.IO.File]::WriteAllText($file, $src, [System.Text.Encoding]::UTF8)
Write-Host "Done"
