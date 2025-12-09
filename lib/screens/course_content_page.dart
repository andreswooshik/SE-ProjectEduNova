import 'package:flutter/material.dart';
import '../widgets/resource_card.dart';

class CourseContentPage extends StatefulWidget {
  final String courseName;

  const CourseContentPage({
    Key? key,
    required this.courseName,
  }) : super(key: key);

  @override
  State<CourseContentPage> createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7FFFD4),
      appBar: _buildAppBar(context),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMaterialsTab(),
          _buildDiscussionsTab(),
          _buildAssignmentsTab(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3E50)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Row(
              children: [
                Icon(Icons.menu, color: Color(0xFF6A4C93), size: 20),
                SizedBox(width: 8),
                Text(
                  'Course Materials',
                  style: TextStyle(
                    color: Color(0xFF2C3E50),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.person_outline,
                    color: Color(0xFF6A4C93), size: 20),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined,
              color: Color(0xFF2C3E50)),
          onPressed: () {},
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF6A4C93),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF6A4C93),
        tabs: const [
          Tab(text: 'Materials'),
          Tab(text: 'Discussions'),
          Tab(text: 'Assignments'),
        ],
      ),
    );
  }

  Widget _buildMaterialsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(6, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ResourceCard(
              icon: Icons.folder_outlined,
              title: 'Learning Resources',
              subtitle: 'Resource title',
              color: const Color(0xFF9B7EBD),
              onTap: () {},
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDiscussionsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 80,
            color: Color(0xFF9B7EBD),
          ),
          SizedBox(height: 16),
          Text(
            'No discussions yet',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF5A6C7D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: Color(0xFF9B7EBD),
          ),
          SizedBox(height: 16),
          Text(
            'No assignments yet',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF5A6C7D),
            ),
          ),
        ],
      ),
    );
  }
}
