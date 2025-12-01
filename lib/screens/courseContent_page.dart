import 'package:flutter/material.dart';

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
      appBar: AppBar(
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
              child: Row(
                children: const [
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
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Materials Tab
          _buildMaterialsTab(),
          // Discussions Tab
          _buildDiscussionsTab(),
          // Assignments Tab
          _buildAssignmentsTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context, 0),
    );
  }

  Widget _buildMaterialsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ResourceCard(
            icon: Icons.folder_outlined,
            title: 'Learning Resources',
            subtitle: 'Resource title',
            color: const Color(0xFF9B7EBD),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ResourceCard(
            icon: Icons.folder_outlined,
            title: 'Learning Resources',
            subtitle: 'Resource title',
            color: const Color(0xFF9B7EBD),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ResourceCard(
            icon: Icons.folder_outlined,
            title: 'Learning Resources',
            subtitle: 'Resource title',
            color: const Color(0xFF9B7EBD),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ResourceCard(
            icon: Icons.folder_outlined,
            title: 'Learning Resources',
            subtitle: 'Resource title',
            color: const Color(0xFF9B7EBD),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ResourceCard(
            icon: Icons.folder_outlined,
            title: 'Learning Resources',
            subtitle: 'Resource title',
            color: const Color(0xFF9B7EBD),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ResourceCard(
            icon: Icons.folder_outlined,
            title: 'Learning Resources',
            subtitle: 'Resource title',
            color: const Color(0xFF9B7EBD),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussionsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
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

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF6A4C93),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ResourceCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5A6C7D),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
