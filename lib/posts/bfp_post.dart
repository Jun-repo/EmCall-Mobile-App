import 'package:emcall/posts/details/post_details_bfppage.dart';
import 'package:flutter/material.dart';

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

class BFPPostPage extends StatefulWidget {
  const BFPPostPage({super.key});

  @override
  BFPPostPageState createState() => BFPPostPageState();
}

class BFPPostPageState extends State<BFPPostPage> {
  final double coverHeight = 250;
  final double profileHeight = 144;

  List<Post> posts = [
    Post(
      imageUrl: 'assets/images/tip2.png',
      title: 'Fire Safety Tips',
      description:
          "Fire safety is crucial for protecting your home and loved ones. Make sure to install smoke detectors on every floor, especially near sleeping areas...",
    ),
    Post(
      imageUrl: 'assets/images/tip1.png',
      title: 'Emergency Procedures for Fires',
      description:
          "In the event of a fire, knowing what to do can save lives. Immediately alert everyone in the building...",
    ),
    Post(
      imageUrl: 'assets/images/tutorial1.png',
      title: 'Using a Fire Extinguisher',
      description:
          "Knowing how to use a fire extinguisher can be critical in an emergency. Remember the acronym PASS: Pull, Aim, Squeeze, Sweep...",
    ),
  ];

  bool isLoadingMore = false;

  void loadMorePosts() {
    setState(() {
      isLoadingMore = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        posts.addAll([
          Post(
            imageUrl: 'assets/images/tutorial1.png',
            title: 'Smoke Detector Maintenance',
            description:
                "Regular maintenance of smoke detectors is vital for safety...",
          ),
          Post(
            imageUrl: 'assets/images/tutorial2.png',
            title: 'Fire Drills',
            description:
                "Conducting regular fire drills can prepare your family for emergencies...",
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
                        builder: (context) => BFPPostDetailPage(bfpPost: post),
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
          'assets/images/thumbnail.jpg',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );
  Widget buildProfileWithName(String name) => Row(
        children: [
          buildProfileImage(),
          const SizedBox(
              width: 12), // Add some spacing between the avatar and the name
          Text(
            name,
            style: const TextStyle(
              fontSize: 16, // Customize the font size
              fontWeight: FontWeight.bold, // Customize the font weight
              color: Colors.black, // Customize the text color
            ),
          ),
        ],
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
          backgroundImage: const AssetImage('assets/images/profile_logo.jpg'),
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
