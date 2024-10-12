import 'package:flutter/material.dart';
import 'package:magadige/all.locations.view.dart';
import 'package:magadige/constants.dart';
import 'package:magadige/models/category.model.dart';
import 'package:magadige/models/travel.location.model.dart';
import 'package:magadige/modules/emergency.view.dart';
import 'package:magadige/modules/events/event.list.view.dart';
import 'package:magadige/modules/home/all.categories.view.dart';
import 'package:magadige/modules/home/all.locations.view.dart';

import 'package:magadige/modules/home/single.loaction.view.dart';
import 'package:magadige/modules/home/travel.location.service.dart';
import 'package:magadige/modules/plan/create.plan.view.dart';
import 'package:magadige/modules/profile/view.dart';
import 'package:magadige/modules/shortcuts/all.shortcuts.view.dart';
import 'package:magadige/utils/index.dart';
import 'package:magadige/widgets/app.drawer.dart';

const String bannerImage =
    "https://www.travelandleisure.com/thmb/aoP7c7Yw7cV9CxLNHQENJFths8g=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/blue-ridge-parkway-virginia-BEAUTYSTS0522-944c1625862847b790a8739a5af1c3a9.jpg";

class HomeWidget extends StatelessWidget {
  final List<TravelLocation> locations =
      dummyLocations; // Use the dummy data here

  HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          context.navigator(context, const CreatePlanView());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Sliver AppBar with animation
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Your Outdoor Partner",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              background: Image.network(
                bannerImage,
                fit: BoxFit.cover,
              ),
            ),
            // leading: IconButton(
            //   icon: const Icon(Icons.menu),
            //   onPressed: () {},
            // ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  child: IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      context.navigator(context, const ProfileView());
                    },
                  ),
                ),
              ),
            ],
          ),

          // Sliver Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search any places...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      context.navigator(context, const AllCategoriesView());
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    categories.map((e) => _CategoryIcon(category: e)).toList(),
              ),
            ),
          ),

          // Most Visited Locations
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Most Visited',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      context.navigator(context, const AllLocationsView());
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<List<TravelLocation>>(
            stream: TravelLocationService().getTravelLocations(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('No locations available')),
                );
              }

              final locations = snapshot.data!;

              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      final location = locations[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _MostVisitedCard(location: location),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          // Shortcuts Section
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shortcuts',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      context.navigator(context, const AllShortCutsView());
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ShortcutButton(
                    label: 'Emergency',
                    icon: Icons.warning,
                    onTap: () {
                      context.navigator(context, const EmergencyView());
                    },
                  ),
                  _ShortcutButton(
                    label: 'Map',
                    icon: Icons.map,
                    onTap: () {
                      context.navigator(context, const AllLocationsMapView());
                    },
                  ),
                  _ShortcutButton(
                    label: 'Trips',
                    icon: Icons.directions_car,
                    onTap: () {
                      context.navigator(context, const EventListView());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final CategoryModel category;

  const _CategoryIcon({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.green[100],
          child: Image.asset(category.imageUrl),
        ),
        const SizedBox(height: 8),
        Text(category.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _MostVisitedCard extends StatelessWidget {
  final TravelLocation location;

  const _MostVisitedCard({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigator(context, SingleLocationView(location: location));
      },
      child: SizedBox(
        width: 160,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Stack(
            children: [
              Image.network(location.imageUrl, fit: BoxFit.cover),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    location.name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShortcutButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ShortcutButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.green[100],
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
