$file = 'd:\Projects\portfolio\lib\figma_portfolio.dart'
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

$content = $content.Replace("title: 'AI Resume Reviewer Agent',`n    desc:", "title: 'AI Resume Reviewer Agent',`n    img: 'assets/project/Resume_reveiver.png',`n    desc:")
$content = $content.Replace("title: 'Smart Challan',`n    desc:", "title: 'Smart Challan',`n    img: 'assets/project/smart_challan.png',`n    desc:")
$content = $content.Replace("title: 'BayMax',`n`n    desc:", "title: 'BayMax',`n    img: 'assets/project/Bay_max.png',`n    desc:")
$content = $content.Replace("title: 'Foodie AI',`n    desc:", "title: 'Foodie AI',`n    img: 'assets/project/Foodie_ai.png',`n    desc:")

[System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
Write-Host "Done"
