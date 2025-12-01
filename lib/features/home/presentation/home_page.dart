import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/features/home/presentation/widget/action_blocks_section.dart';
import 'package:ssogssog_flutter/features/home/presentation/widget/market_rank_section.dart';
import 'package:ssogssog_flutter/features/home/presentation/widget/home_app_bar.dart';
import 'package:ssogssog_flutter/features/home/presentation/widget/main_banner.dart';
import 'package:ssogssog_flutter/features/home/presentation/widget/my_picks_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MainBanner(),
            ActionBlocksSection(),
            MyPicksBanner(),
            MarketRankingSection(),
          ],
        ),
      ),
    );
  }
}
