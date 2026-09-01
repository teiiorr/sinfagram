import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../sinf_theme.dart';
import '../sinf_icons.dart';

/// Maktab loyihalari galereyasi — qopqoq, sarlavha, jamoa va tavsif.
class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: sinfAppBar('Maktab loyihalari'),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 6, bottom: 24),
        itemCount: projects.length,
        itemBuilder: (context, i) => FadeInUp(
          index: i,
          child: _ProjectCard(project: projects[i]),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final SchoolProject project;
  const _ProjectCard({Key? key, required this.project}) : super(key: key);

  static const double _h = 160;

  @override
  Widget build(BuildContext context) {
    return SinfCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: SinfPhoto(project.cover, height: _h, radius: 0),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: metro(size: 16, weight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Pill(project.team, icon: AppIcons.people),
                const SizedBox(height: 10),
                Text(
                  project.desc,
                  style: metro(size: 13, color: SinfColors.muted, weight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
