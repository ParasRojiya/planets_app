import 'dart:math';
import 'package:flutter/material.dart';
import '../global/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController sunAnimationController;
  late Animation offsetAnimation;
  late Animation rotationAnimation;
  late Animation sunRotationAnimation;

  @override
  void initState() {
    super.initState();

    sunAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    rotationAnimation =
        Tween(begin: 0, end: pi * 2).animate(animationController);
    sunRotationAnimation =
        Tween(begin: 0, end: pi * 2).animate(sunAnimationController);

    offsetAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, -2), end: const Offset(0, 2)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, 2), end: const Offset(0, -2)),
          weight: 1),
    ]).animate(sunAnimationController);

    animationController.repeat();
    sunAnimationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade900,
          ),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 60,
                collapsedHeight: 60,
                expandedHeight: 210,
                pinned: true,
                title: AnimatedBuilder(
                  animation: sunAnimationController,
                  builder: (context, widget) {
                    return Transform.translate(
                      offset: offsetAnimation.value,
                      child: Transform.rotate(
                        angle: sunRotationAnimation
                            .value, //animationController.value,
                        child: widget,
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/sun.png"),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  title: const Text("Solar System"),
                  background: Image.asset(
                    "assets/images/solar_system.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('detail_page',
                            arguments: Global.planetDetails[i]);
                      },
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 160,
                            width: width * 0.9,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.blue.shade900,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: Offset(0, 0),
                                  ),
                                ]),
                            margin: const EdgeInsets.only(
                                top: 22, left: 85, right: 22, bottom: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${Global.planetDetails[i]['name']}"
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "${Global.planetDetails[i]['galaxy']}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on_sharp,
                                      size: 18,
                                      color: Colors.white70,
                                    ),
                                    Text(
                                      "${Global.planetDetails[i]['surface_area']}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    const Icon(Icons.compare_arrows,
                                        size: 20, color: Colors.white70),
                                    Text(
                                      "${Global.planetDetails[i]['gravity']}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          AnimatedBuilder(
                            animation: animationController,
                            builder: (context, widget) {
                              return Hero(
                                tag: "${Global.planetDetails[i]['name']}",
                                child: Transform.rotate(
                                  angle: rotationAnimation.value,
                                  child: widget,
                                ),
                              );
                            },
                            child: Container(
                              height: 110,
                              width: 110,
                              // margin: const EdgeInsets.only(left: 35),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage(
                                      "${Global.planetDetails[i]['image']}"),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: Global.planetDetails.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
