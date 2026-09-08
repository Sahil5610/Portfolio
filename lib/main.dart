import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'figma_portfolio.dart';

void main() {
  runApp(const FigmaPortfolioApp());
}

class SahilPortfolio extends StatelessWidget {
  const SahilPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sahil Tamboli | Software Engineer',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F14),
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4FD1C5),
          brightness: Brightness.dark,
        ),
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey homeKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey skillsKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey experienceKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  void scrollTo(GlobalKey key) {
    final context = key.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildNavbar(isMobile),
                _buildHero(isMobile),
                _buildAbout(isMobile),
                _buildSkills(isMobile),
                _buildProjects(isMobile),
                _buildExperience(isMobile),
                _buildEducation(isMobile),
                _buildContact(isMobile),
                _buildFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // NAVBAR
  // ------------------------------------------------------------

  Widget _buildNavbar(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 70,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F14).withOpacity(0.95),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFF1D2730),
          ),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'SAHIL.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          const Spacer(),

          if (!isMobile) ...[
            _navItem('Home', homeKey),
            _navItem('About', aboutKey),
            _navItem('Skills', skillsKey),
            _navItem('Projects', projectsKey),
            _navItem('Experience', experienceKey),
            _navItem('Contact', contactKey),
          ],

          if (isMobile)
            IconButton(
              onPressed: () {
                _showMobileMenu(context);
              },
              icon: const Icon(Icons.menu),
            ),
        ],
      ),
    );
  }

  Widget _navItem(String title, GlobalKey key) {
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: TextButton(
        onPressed: () => scrollTo(key),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111820),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _mobileNavButton('Home', homeKey),
              _mobileNavButton('About', aboutKey),
              _mobileNavButton('Skills', skillsKey),
              _mobileNavButton('Projects', projectsKey),
              _mobileNavButton('Experience', experienceKey),
              _mobileNavButton('Contact', contactKey),
            ],
          ),
        );
      },
    );
  }

  Widget _mobileNavButton(String title, GlobalKey key) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        scrollTo(key);
      },
    );
  }

  // ------------------------------------------------------------
  // HERO
  // ------------------------------------------------------------

  Widget _buildHero(bool isMobile) {
    return Container(
      key: homeKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 80 : 120,
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _heroText(),
                const SizedBox(height: 50),
                _heroCodeCard(),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 6,
                  child: _heroText(),
                ),
                const SizedBox(width: 70),
                Expanded(
                  flex: 4,
                  child: _heroCodeCard(),
                ),
              ],
            ),
    );
  }

  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HELLO, I\'M',
          style: TextStyle(
            color: Color(0xFF4FD1C5),
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'Sahil\nTamboli',
          style: TextStyle(
            fontSize: 64,
            height: 1.0,
            fontWeight: FontWeight.w800,
            letterSpacing: -2,
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'Software Engineer • AI & Data Science',
          style: TextStyle(
            fontSize: 21,
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 20),

        const SizedBox(
          width: 650,
          child: Text(
            'I build AI-powered applications, scalable APIs, '
            'data-driven solutions and cloud-based systems.',
            style: TextStyle(
              fontSize: 17,
              height: 1.7,
              color: Colors.white54,
            ),
          ),
        ),

        const SizedBox(height: 35),

        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            ElevatedButton(
              onPressed: () => scrollTo(projectsKey),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FD1C5),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
              ),
              child: const Text(
                'View Projects',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            OutlinedButton(
              onPressed: () {
                openUrl(
                  'https://www.linkedin.com/in/sahiltamboli561',
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
              ),
              child: const Text('LinkedIn'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroCodeCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF111820),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF24313B),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.red,
              ),
              SizedBox(width: 7),
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.yellow,
              ),
              SizedBox(width: 7),
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.green,
              ),
            ],
          ),

          SizedBox(height: 25),

          Text(
            'developer.dart',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 13,
            ),
          ),

          SizedBox(height: 20),

          Text(
            'class Developer {\\n'
            '  String name = "Sahil";\\n'
            '  String role = "Software Engineer";\\n'
            '  List<String> skills = [\\n'
            '    "Python",\\n'
            '    "AWS",\\n'
            '    "AI / ML",\\n'
            '    "FastAPI",\\n'
            '    "GenAI"\\n'
            '  ];\\n'
            '}',
            style: TextStyle(
              fontFamily: 'monospace',
              height: 1.7,
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ABOUT
  // ------------------------------------------------------------

  Widget _buildAbout(bool isMobile) {
    return _section(
      key: aboutKey,
      title: 'About Me',
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isMobile ? 0 : 1,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Building things that solve\nreal problems.',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: isMobile ? 0 : 60,
            height: isMobile ? 30 : 0,
          ),

          Expanded(
            flex: isMobile ? 0 : 2,
            child: const Text(
              'I am an Artificial Intelligence & Data Science undergraduate '
              'with a strong foundation in Python, Data Structures & '
              'Algorithms, Object-Oriented Programming and software development. '
              'I enjoy building practical applications using APIs, Machine '
              'Learning, Generative AI, databases and cloud technologies.\n\n'
              'My goal is to combine software engineering with AI and cloud '
              'technologies to build reliable, scalable and useful products.',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 17,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SKILLS
  // ------------------------------------------------------------

  Widget _buildSkills(bool isMobile) {
    final skills = {
      'Programming': [
        'Python',
        'C++',
        'SQL',
        'Dart',
      ],
      'Software Engineering': [
        'DSA',
        'OOP',
        'REST APIs',
        'FastAPI',
        'Git',
        'GitHub',
        'Docker',
      ],
      'Cloud': [
        'AWS EC2',
        'S3',
        'IAM',
        'VPC',
        'RDS',
        'Load Balancer',
        'Auto Scaling',
        'CloudWatch',
      ],
      'AI & Data': [
        'Machine Learning',
        'Deep Learning',
        'NLP',
        'Pandas',
        'NumPy',
        'Scikit-learn',
        'PyTorch',
      ],
      'Generative AI': [
        'RAG',
        'LLMs',
        'LangChain',
        'LlamaIndex',
        'ChromaDB',
        'Gemini API',
        'Prompt Engineering',
      ],
      'Development': [
        'Flutter',
        'Firebase',
        'Streamlit',
      ],
    };

    return _section(
      key: skillsKey,
      title: 'Skills',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: skills.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 1 : 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: isMobile ? 3 : 2.4,
        ),
        itemBuilder: (context, index) {
          final entry = skills.entries.elementAt(index);

          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF111820),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF202C35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    color: Color(0xFF4FD1C5),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: entry.value
                      .map(
                        (skill) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF18232C),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // PROJECTS
  // ------------------------------------------------------------

  Widget _buildProjects(bool isMobile) {
    final projects = [
      {
        'title': 'Cloud AI Customer Analytics',
        'description':
            'A cloud-ready customer analytics and churn prediction platform '
            'combining Machine Learning, FastAPI, Docker and AWS.',
        'tags': [
          'Python',
          'FastAPI',
          'AWS',
          'Docker',
          'MySQL',
          'ML',
        ],
      },
      {
        'title': 'Customer Churn Prediction',
        'description':
            'End-to-end Machine Learning application for predicting customer '
            'churn with a FastAPI REST API, MySQL database and Docker.',
        'tags': [
          'Python',
          'Scikit-learn',
          'FastAPI',
          'MySQL',
          'Docker',
        ],
      },
      {
        'title': 'AI Resume Reviewer',
        'description':
            'AI-powered resume analysis system using RAG to compare resumes '
            'against job descriptions and identify skill gaps.',
        'tags': [
          'LangChain',
          'RAG',
          'Gemini',
          'ChromaDB',
          'FastAPI',
        ],
      },
      {
        'title': 'Smart Challan',
        'description':
            'RAG-based system that retrieves vehicle and traffic records '
            'and generates context-aware challans.',
        'tags': [
          'LlamaIndex',
          'RAG',
          'ChromaDB',
          'Gemini',
          'FastAPI',
        ],
      },
      {
        'title': 'BayMax',
        'description':
            'AI-powered Flutter application for health monitoring, symptom '
            'tracking, emergency support and cloud-based records.',
        'tags': [
          'Flutter',
          'Dart',
          'Firebase',
          'AI',
        ],
      },
    ];

    return _section(
      key: projectsKey,
      title: 'Featured Projects',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: projects.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 1 : 2,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
          childAspectRatio: isMobile ? 1.2 : 1.15,
        ),
        itemBuilder: (context, index) {
          final project = projects[index];

          return _projectCard(
            project['title'] as String,
            project['description'] as String,
            project['tags'] as List<String>,
            index == 0,
          );
        },
      ),
    );
  }

  Widget _projectCard(
    String title,
    String description,
    List<String> tags,
    bool featured,
  ) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF111820),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: featured
              ? const Color(0xFF4FD1C5).withOpacity(0.5)
              : const Color(0xFF202C35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF18252D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.code,
                  color: Color(0xFF4FD1C5),
                ),
              ),

              const Spacer(),

              if (featured)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4FD1C5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'FEATURED',
                    style: TextStyle(
                      color: Color(0xFF4FD1C5),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 25),

          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            description,
            style: const TextStyle(
              color: Colors.white54,
              height: 1.6,
            ),
          ),

          const Spacer(),

          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: tags
                .map(
                  (tag) => Text(
                    '#$tag',
                    style: const TextStyle(
                      color: Color(0xFF4FD1C5),
                      fontSize: 12,
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 20),

          TextButton.icon(
            onPressed: () {
              // Add GitHub repository URL here.
            },
            icon: const Icon(Icons.arrow_outward),
            label: const Text('View Project'),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // EXPERIENCE
  // ------------------------------------------------------------

  Widget _buildExperience(bool isMobile) {
    return _section(
      key: experienceKey,
      title: 'Experience',
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF111820),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF202C35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'IoT & Robotics Intern',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Incubator System • Jan 2026 – Feb 2026',
              style: TextStyle(
                color: Color(0xFF4FD1C5),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Worked on IoT, embedded systems, sensors, microcontrollers '
              'and wireless communication. Developed Shastranetra, a smart '
              'monitoring and surveillance system for collecting environmental '
              'data and transmitting it through a wireless network for '
              'real-time monitoring.',
              style: TextStyle(
                color: Colors.white60,
                height: 1.7,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                'Python',
                'C++',
                'IoT',
                'Robotics',
                'Wi-Fi',
                'Sensors',
              ]
                  .map(
                    (skill) => Chip(
                      label: Text(skill),
                      backgroundColor: const Color(0xFF18232C),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // EDUCATION
  // ------------------------------------------------------------

  Widget _buildEducation(bool isMobile) {
    return _section(
      title: 'Education',
      child: const Column(
        children: [
          _EducationCard(
            degree: 'B.E. Artificial Intelligence & Data Science',
            institute: 'Dr. D. Y. Patil Institute of Technology',
            duration: '2023 – 2027',
            result: 'CGPA: 8.59 / 10',
          ),
          SizedBox(height: 20),
          _EducationCard(
            degree: '12th',
            institute:
                'Dnyan Prasarak Vidya Mandir & Junior College, Pune',
            duration: '2023',
            result: '70%',
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // CONTACT
  // ------------------------------------------------------------

  Widget _buildContact(bool isMobile) {
    return _section(
      key: contactKey,
      title: 'Let\'s Connect',
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 30 : 55),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF111820),
              Color(0xFF142029),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xFF24313B),
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Have a project or opportunity?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'I\'m always interested in building something meaningful.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              runSpacing: 15,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    openUrl(
                      'mailto:sahiltamboli561@gmail.com',
                    );
                  },
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Email Me'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4FD1C5),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 17,
                    ),
                  ),
                ),

                OutlinedButton.icon(
                  onPressed: () {
                    openUrl(
                      'https://www.linkedin.com/in/sahiltamboli561',
                    );
                  },
                  icon: const Icon(Icons.work_outline),
                  label: const Text('LinkedIn'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 17,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // FOOTER
  // ------------------------------------------------------------

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 35,
      ),
      child: const Column(
        children: [
          Divider(
            color: Color(0xFF202C35),
          ),

          SizedBox(height: 25),

          Text(
            'Designed & Built with Flutter',
            style: TextStyle(
              color: Colors.white38,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '© 2026 Sahil Tamboli',
            style: TextStyle(
              color: Colors.white24,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTION
  // ------------------------------------------------------------

  Widget _section({
    GlobalKey? key,
    required String title,
    required Widget child,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1150,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 5,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4FD1C5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 45),

              child,
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// EDUCATION CARD
// ------------------------------------------------------------

class _EducationCard extends StatelessWidget {
  final String degree;
  final String institute;
  final String duration;
  final String result;

  const _EducationCard({
    required this.degree,
    required this.institute,
    required this.duration,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF111820),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF202C35),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF18252D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school_outlined,
              color: Color(0xFF4FD1C5),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  degree,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  institute,
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '$duration • $result',
                  style: const TextStyle(
                    color: Color(0xFF4FD1C5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
