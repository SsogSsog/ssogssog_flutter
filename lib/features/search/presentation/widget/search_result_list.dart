import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/features/search/data/model/search_models.dart';

class SearchResultList extends StatelessWidget {
  final List<SearchStockItem> results;
  final String query;
  // Optional callback for infinite scroll (only used in Full Search)
  final ScrollController? scrollController;
  final bool isLoading;

  const SearchResultList({
    super.key,
    required this.results,
    required this.query,
    this.scrollController,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (results.isEmpty && !isLoading) {
      return Center(
        child: Text(
          '검색 결과가 없습니다',
          style: TextStyle(
            color: theme.hintColor.withOpacity(0.5),
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: results.length + (isLoading ? 1 : 0),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        if (index < results.length) {
          final item = results[index];
          return _buildStockTile(context, item, theme);
        } else {
          return const Center(child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }

  Widget _buildStockTile(BuildContext context, SearchStockItem item, ThemeData theme) {
    final isUp = item.changeRate >= 0;
    final rateColor = isUp ? const Color(0xFFE5484D) : const Color(0xFF2F6FED);

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.dividerColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        // Simple placeholder icon or could be image if API had logo
        child: const Icon(Icons.show_chart, size: 20),
      ),
      title: RichText(
        text: _highlightMatch(item.corpName, query, theme),
      ),
      subtitle: Row(
        children: [
          Text(item.stockCode, style: TextStyle( fontSize: 13, color: theme.hintColor)),
          const SizedBox(width: 6),
          // Price Info
          Text(
             '${item.closePrice}원', 
             style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)
          ),
          const SizedBox(width: 4),
          Text(
            '${isUp ? '+' : ''}${item.changeRate}%',
            style: TextStyle(fontSize: 13, color: rateColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: () {
        context.push('/stock/${item.stockCode}'); 
      },
    );
  }

  TextSpan _highlightMatch(String text, String query, ThemeData theme) {
    if (query.isEmpty) return TextSpan(text: text, style: TextStyle(color: theme.textTheme.bodyLarge?.color));

    final matches = text.toLowerCase().split(query.toLowerCase());
    if (matches.length <= 1) return TextSpan(text: text, style: TextStyle(color: theme.textTheme.bodyLarge?.color));

    final children = <TextSpan>[];
    
    // 단순 포함 여부 하이라이팅 (대소문자 무시)
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    int index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
       return TextSpan(text: text, style: TextStyle(color: theme.textTheme.bodyLarge?.color));
    }

    // 앞부분
    if (index > 0) {
      children.add(TextSpan(
        text: text.substring(0, index),
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      ));
    }

    // 매칭 부분
    children.add(TextSpan(
      text: text.substring(index, index + query.length),
      style: TextStyle(
        color: theme.colorScheme.primary, // 하이라이트 색상
        fontWeight: FontWeight.bold,
      ),
    ));

    // 뒷부분
    if (index + query.length < text.length) {
      children.add(TextSpan(
        text: text.substring(index + query.length),
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      ));
    }

    return TextSpan(children: children, style: const TextStyle(fontSize: 16));
  }
}
