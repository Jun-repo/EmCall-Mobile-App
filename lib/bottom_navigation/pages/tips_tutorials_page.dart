import 'package:emcall/contents/agency_button.dart';
import 'package:emcall/tips&tutorials/tips_card.dart';
import 'package:emcall/tips&tutorials/tutorial_card.dart';
import 'package:flutter/material.dart';

class TipsTutorialsPage extends StatefulWidget {
  const TipsTutorialsPage({super.key});

  @override
  State<TipsTutorialsPage> createState() => _TipsTutorialsPageState();
}

class _TipsTutorialsPageState extends State<TipsTutorialsPage> {
  String selectedFilter = 'All'; // Selected filter option
  String searchPlaceholder =
      'Search tips or tutorials'; // Search bar placeholder

  // Example data for tips and tutorials
  List<Map<String, String>> tipsData = [
    {
      "title": "Stay Safe During Disasters",
      "agency": "Agency 1",
      "imageUrl": "assets/images/tip1.png", // Asset image
      "description": "Essential tips to ensure your safety during disasters.",
      "avatarUrl": "assets/images/avatar1.png", // Asset avatar
    },
    {
      "title": "First Aid Basics",
      "agency": "Agency 2",
      "imageUrl": "assets/images/tip2.png", // Asset image
      "description": "Learn the basics of first aid for common injuries.",
      "avatarUrl": "assets/images/avatar2.png", // Asset avatar
    },
  ];

  List<Map<String, String>> tutorialsData = [
    {
      "title": "Emergency Preparedness",
      "agency": "Agency 3",
      "imageUrl": "assets/images/tutorial1.png", // Asset image
      "description": "A detailed guide on how to prepare for emergencies.",
      "avatarUrl": "assets/images/avatar3.png", // Asset avatar
    },
    {
      "title": "CPR Techniques",
      "agency": "Agency 4",
      "imageUrl": "assets/images/tutorial2.png", // Asset image
      "description": "Learn how to perform CPR during critical situations.",
      "avatarUrl": "assets/images/avatar3.png", // Asset avatar
    },
  ];

  List<Map<String, String>> loadedTips = [];
  List<Map<String, String>> loadedTutorials = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      loadMoreTips();
      loadMoreTutorials();
    });
  }

  void loadMoreTips() {
    setState(() => isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loadedTips.addAll(tipsData);
        isLoading = false;
      });
    });
  }

  void loadMoreTutorials() {
    setState(() => isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loadedTutorials.addAll(tutorialsData);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        title: Text(
          "Tips & Tutorials",
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar with Filter Icon
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSearchBar(theme),
                    ),
                    const SizedBox(width: 10),
                    _buildFilterButton(context),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionLabel("Agencies", theme),
              const SizedBox(height: 10),
              _buildAgenciesRow(),
              const SizedBox(height: 20),
              _buildSectionLabel("Tips", theme),
              const SizedBox(height: 10),
              _buildTipsList(),
              const SizedBox(height: 20),
              _buildSectionLabel("Tutorials", theme),
              const SizedBox(height: 10),
              _buildTutorialsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? Colors.grey.withOpacity(0.3)
                : Colors.black.withOpacity(0.5),
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: theme.brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: searchPlaceholder,
                hintStyle: TextStyle(
                  color: theme.brightness == Brightness.light
                      ? Colors.grey
                      : Colors.white30,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: theme.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              onChanged: (value) {
                // Handle search logic
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.filter_list, color: Colors.white),
        onPressed: () => _showFilterMenu(context),
      ),
    );
  }

  Widget _buildSectionLabel(String label, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        label,
        style: theme.textTheme.headlineMedium,
      ),
    );
  }

  Widget _buildAgenciesRow() {
    return SizedBox(
      height: 70,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          AgencyButton(name: "PNP", icon: Icons.local_police),
          AgencyButton(name: "BFP", icon: Icons.warning),
          AgencyButton(name: "MDRRMO", icon: Icons.fire_extinguisher),
          AgencyButton(name: "Rescue", icon: Icons.local_hospital),
        ],
      ),
    );
  }

  Widget _buildTipsList() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: loadedTips.length + 1,
        itemBuilder: (context, index) {
          if (index < loadedTips.length) {
            final tip = loadedTips[index];
            return TipsCard(
              title: tip["title"]!,
              agency: tip["agency"]!,
              imageUrl: tip["imageUrl"]!,
              description: tip["description"]!,
              avatarUrl: tip["avatarUrl"]!,
            );
          } else {
            return _buildLoadMoreButton(loadMoreTips);
          }
        },
      ),
    );
  }

  Widget _buildTutorialsList() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: loadedTutorials.length,
          itemBuilder: (context, index) {
            final tutorial = loadedTutorials[index];
            return TutorialCard(
              title: tutorial["title"]!,
              agency: tutorial["agency"]!,
              imageUrl: tutorial["imageUrl"]!,
              description: tutorial["description"]!,
              avatarUrl: tutorial["avatarUrl"]!,
            );
          },
        ),
        const SizedBox(height: 10),
        if (isLoading) // Show loading indicator if still loading
          const CircularProgressIndicator(color: Colors.redAccent)
        else // Show "Load More" button if not loading
          _buildLoadMoreButton(loadMoreTutorials),
      ],
    );
  }

  Widget _buildLoadMoreButton(VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: onPressed,
        child:
            const Text('Load More!', style: TextStyle(color: Colors.redAccent)),
      ),
    );
  }

  // Method to show the filter menu
  void _showFilterMenu(BuildContext context) {
    showMenu<String>(
      context: context,
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white // Light mode menu background color
          : const Color(0xFF2C2C2C), // Dark mode menu background color
      position:
          const RelativeRect.fromLTRB(100, 100, 0, 0), // Customize the position
      items: [
        const PopupMenuItem<String>(
          value: 'All',
          child: Text('All Incidents'),
        ),
        const PopupMenuItem<String>(
          value: 'Earthquake',
          child: Text('Earthquake'),
        ),
        const PopupMenuItem<String>(
          value: 'Flood',
          child: Text('Flood'),
        ),
        const PopupMenuItem<String>(
          value: 'Fire',
          child: Text('Fire'),
        ),
        const PopupMenuItem<String>(
          value: 'Pandemic',
          child: Text('Pandemic'),
        ),
      ],
      elevation: 8.0,
    ).then((String? value) {
      if (value != null) {
        setState(() {
          selectedFilter = value;
          // Update the placeholder text based on the selected filter
          searchPlaceholder = 'Search $value tips or tutorials';
        });
      }
    });
  }
}
