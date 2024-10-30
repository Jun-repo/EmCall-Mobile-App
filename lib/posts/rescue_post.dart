import 'package:flutter/material.dart';
import 'details/post_details_rescuepage.dart'; // Update this import to your actual Rescue post details page

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

class RescuePostPage extends StatefulWidget {
  const RescuePostPage({super.key});

  @override
  RescuePostPageState createState() => RescuePostPageState();
}

class RescuePostPageState extends State<RescuePostPage> {
  final double coverHeight = 250;
  final double profileHeight = 144;

  // Initial list of posts
  List<Post> posts = [
    Post(
      imageUrl: 'assets/images/tip1.png',
      title: 'Rescue Techniques Overview',
      description:
          "Understanding basic rescue techniques is essential for effective emergency response. Familiarize yourself with different methods such as evacuation, extraction, and first aid. Understanding basic rescue techniques is essential for effective emergency response. Familiarize yourself with different methods such as evacuation, extraction, and first aid. Understanding basic rescue techniques is essential for effective emergency response. Familiarize yourself with different methods such as evacuation, extraction, and first aid. Understanding basic rescue techniques is essential for effective emergency response. Familiarize yourself with different methods such as evacuation, extraction, and first aid. Understanding basic rescue techniques is essential for effective emergency response. Familiarize yourself with different methods such as evacuation, extraction, and first aid. Understanding basic rescue techniques is essential for effective emergency response. Familiarize yourself with different methods such as evacuation, extraction, and first aid.",
    ),
    Post(
      imageUrl: 'assets/images/tutorial1.png',
      title: 'Basic First Aid for Rescuers',
      description:
          "As a rescuer, knowing basic first aid can help save lives. Learn how to perform CPR, manage wounds, and treat common injuries during emergencies.",
    ),
    Post(
      imageUrl: 'assets/images/tutorial2.png',
      title: 'Communication in Emergencies',
      description:
          "Effective communication is critical during emergencies. Establish clear lines of communication and ensure everyone involved knows their roles and responsibilities.",
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
            title: 'Assessing Situations',
            description:
                "Before initiating a rescue, assess the situation to ensure safety for both the rescuer and the victim. Determine potential hazards and create a plan.",
          ),
          Post(
            imageUrl: 'assets/images/tip1.png',
            title: 'Tools and Equipment',
            description:
                "Know the tools and equipment available for rescue operations. Familiarize yourself with their uses and ensure they are accessible during emergencies.",
          ),
          Post(
            imageUrl: 'assets/images/tutorial1.png',
            title: 'Team Coordination',
            description:
                "Rescue operations require teamwork. Ensure all team members understand their roles and communicate effectively to ensure a successful outcome.",
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
                            RescuePostDetailPage(rescuePost: post),
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
          'assets/images/rescue_thumbnail.png',
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
          backgroundImage: const AssetImage('assets/images/rescue_logo.png'),
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
