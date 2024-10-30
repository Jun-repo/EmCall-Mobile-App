import 'package:flutter/material.dart';
import 'details/post_details_mdrrmopage.dart';

class Post {
  final String imageUrl;
  final String title;
  final String description;

  Post({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

class MDRRMOPostPage extends StatefulWidget {
  const MDRRMOPostPage({super.key});

  @override
  MDRRMOPostPageState createState() => MDRRMOPostPageState();
}

class MDRRMOPostPageState extends State<MDRRMOPostPage> {
  final double coverHeight = 250;
  final double profileHeight = 144;

  // Initial list of posts
  List<Post> posts = [
    Post(
      imageUrl: 'assets/images/tip1.png',
      title: 'Disaster Preparedness Tips',
      description:
          "Being prepared for disasters is crucial. Know the risks in your area, create an emergency plan, and ensure everyone in your household understands it. Stock up on essential supplies and stay informed about local alerts. Being prepared for disasters is crucial. Know the risks in your area, create an emergency plan, and ensure everyone in your household understands it. Stock up on essential supplies and stay informed about local alerts. Being prepared for disasters is crucial. Know the risks in your area, create an emergency plan, and ensure everyone in your household understands it. Stock up on essential supplies and stay informed about local alerts. Being prepared for disasters is crucial. Know the risks in your area, create an emergency plan, and ensure everyone in your household understands it. Stock up on essential supplies and stay informed about local alerts. Being prepared for disasters is crucial. Know the risks in your area, create an emergency plan, and ensure everyone in your household understands it. Stock up on essential supplies and stay informed about local alerts.",
    ),
    Post(
      imageUrl: 'assets/images/tutorial1.png',
      title: 'Emergency Evacuation Procedures',
      description:
          "Have a clear evacuation plan. Identify multiple routes to safety and practice the plan with your family. Make sure to include pets in your plan and have a designated meeting place.",
    ),
    Post(
      imageUrl: 'assets/images/tutorial2.png',
      title: 'Creating a Disaster Kit',
      description:
          "A disaster kit should include food, water, medications, and important documents. Don’t forget items for your pets. Check and update your kit regularly to ensure everything is usable.",
    ),
  ];

  bool isLoadingMore = false;

  // Simulate loading more posts
  void loadMorePosts() {
    setState(() {
      isLoadingMore = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        posts.addAll([
          Post(
            imageUrl: 'assets/images/tip2.png',
            title: 'First Aid Basics',
            description:
                "Knowing basic first aid can be invaluable during emergencies. Consider taking a first aid course to learn how to handle injuries and emergencies effectively.",
          ),
          Post(
            imageUrl: 'assets/images/tip1.png',
            title: 'Staying Informed',
            description:
                "Stay informed about weather conditions and alerts in your area. Sign up for local notifications and have a battery-operated radio on hand for updates.",
          ),
          Post(
            imageUrl: 'assets/images/tutorial1.png',
            title: 'Community Resources',
            description:
                "Know your local community resources and shelters. Having this information can make a big difference in emergency situations.",
          ),
        ]);
        isLoadingMore = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: coverHeight,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomRight,
                children: [
                  buildCoverImage(),
                  Positioned(
                    top: coverHeight - profileHeight / 1.5,
                    right: 16,
                    child: buildProfileImage(),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 0.3,
              color: const Color.fromARGB(154, 255, 82, 82),
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == posts.length) {
                  return Center(
                    child: isLoadingMore
                        ? const CircularProgressIndicator(
                            color: Colors.redAccent,
                          )
                        : TextButton(
                            onPressed: loadMorePosts,
                            child: const Text(
                              'Load More?',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  );
                }

                final post = posts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MDRRMOPostDetailPage(mdrrmoPost: post),
                      ),
                    );
                  },
                  child: buildPostCard(post, theme),
                );
              },
              childCount: posts.length + 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.asset(
          'assets/images/mdrrmocover.jpg',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.redAccent, // Set the border color
            width: 4, // Set the border width
          ),
        ),
        child: CircleAvatar(
          radius: profileHeight / 3,
          backgroundColor: Colors.grey.shade800,
          backgroundImage: const AssetImage('assets/images/mdrrmo.png'),
        ),
      );

  Widget buildPostCard(Post post, ThemeData theme) {
    return SizedBox(
      height: 120,
      child: Card(
        color: theme.scaffoldBackgroundColor,
        // shape: theme.cardTheme.shape,
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              child: Image.asset(
                post.imageUrl,
                width: 150,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.description.length > 70
                        ? '${post.description.substring(0, 70)}...'
                        : post.description,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
