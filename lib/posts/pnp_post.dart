import 'package:flutter/material.dart';
import 'details/post_details_pnppage.dart';

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

class PNPPostPage extends StatefulWidget {
  const PNPPostPage({super.key});

  @override
  PNPPostPageState createState() => PNPPostPageState();
}

class PNPPostPageState extends State<PNPPostPage> {
  final double coverHeight = 250;
  final double profileHeight = 144;
  // Initial list of posts
  List<Post> posts = [
    Post(
      imageUrl: 'assets/images/tip1.png',
      title: 'Community Safety Tips',
      description:
          "Stay aware of your surroundings and report any suspicious activity to local authorities. Familiarize yourself with emergency numbers and ensure your home is secure. Engage with your community to promote safety and vigilance. Remember, staying informed and connected can help prevent crime.",
    ),
    Post(
      imageUrl: 'assets/images/tutorial1.png',
      title: 'Emergency Procedures',
      description:
          "In case of an emergency, always call for help immediately. Know the fastest route to the nearest police station and keep emergency numbers handy. Stay calm and provide clear information about the situation to the authorities. Your safety is the priority, so act wisely.",
    ),
    Post(
      imageUrl: 'assets/images/tutorial2.png',
      title: 'How to Report a Crime',
      description:
          "Reporting a crime can be critical in maintaining community safety. Always provide detailed information such as the location, time, and nature of the crime. If possible, gather information about suspects or vehicles involved. Do not intervene; let the police handle the situation.",
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
            title: 'Neighborhood Watch',
            description:
                "Participating in a neighborhood watch program can enhance safety. Regular meetings and communication with local law enforcement foster a sense of security. Encourage community members to stay involved and report any unusual activity.",
          ),
          Post(
            imageUrl: 'assets/images/tip1.png',
            title: 'Personal Safety Tips',
            description:
                "Personal safety is paramount. Always keep your phone charged and accessible. Avoid walking alone at night in unfamiliar areas. If you feel threatened, seek help immediately from law enforcement or nearby individuals.",
          ),
          Post(
            imageUrl: 'assets/images/tutorial1.png',
            title: 'Traffic Safety',
            description:
                "Traffic rules are essential for everyone's safety. Always wear a seatbelt, follow speed limits, and be aware of pedestrians. Report any reckless driving behavior to the police for community safety.",
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
                        builder: (context) => PNPPostDetailPage(pnpPost: post),
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
          'assets/images/pnp.jpg',
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
          backgroundImage: const AssetImage('assets/images/pnp_logo.jpeg'),
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
