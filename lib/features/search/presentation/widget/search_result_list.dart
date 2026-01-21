import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/features/search/data/model/search_models.dart';

class SearchResultList extends StatelessWidget {
  final List<SearchStockItem> results;
  final String query;
  // Optional callback for infinite scroll (only used in Full Search)
  final ScrollController? scrollController;
  final bool isLoading;
  // Flag to distinguish between Autocomplete (List) and Full Search (Card)
  final bool isFullSearch;

  const SearchResultList({
    super.key,
    required this.results,
    required this.query,
    this.scrollController,
    this.isLoading = false,
    this.isFullSearch = false,
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
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: isFullSearch ? 16 : 0),
      itemBuilder: (context, index) {
        if (index < results.length) {
          final item = results[index];
          if (isFullSearch) {
             return _FullResultCard(item: item, theme: theme, query: query);
          } else {
             return _AutocompleteListTile(item: item, theme: theme, query: query);
          }
        } else {
          return const Center(child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }
}


class _AutocompleteListTile extends StatelessWidget {
  final SearchStockItem item;
  final ThemeData theme;
  final String query;

  const _AutocompleteListTile({required this.item, required this.theme, required this.query});

  @override
  Widget build(BuildContext context) {
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
        child: const Icon(Icons.show_chart, size: 20),
      ),
      title: RichText(
        text: _highlightMatch(item.corpName, query, theme),
      ),
      subtitle: Row(
        children: [
          Text(item.stockCode, style: TextStyle( fontSize: 13, color: theme.hintColor)),
          const SizedBox(width: 6),
          Text(
             '${_formatInt(item.closePrice)}원', 
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
}

class _FullResultCard extends StatelessWidget {
  final SearchStockItem item;
  final ThemeData theme;
  final String query;

  const _FullResultCard({required this.item, required this.theme, required this.query});

  @override
  Widget build(BuildContext context) {
    final isUp = item.changeRate >= 0;
    final rateColor = isUp ? const Color(0xFFE5484D) : const Color(0xFF2F6FED);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
           BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
             context.push('/stock/${item.stockCode}'); 
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: _highlightMatch(item.corpName, query, theme, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.stockCode,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.hintColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_formatInt(item.closePrice)}원',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${isUp ? '+' : ''}${item.changeRate}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: rateColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                     Row(
                      children: [
                        Icon(Icons.bar_chart_rounded, size: 14, color: theme.hintColor),
                        const SizedBox(width: 2),
                        Text(
                          '거래량 ${_formatInt(item.volume)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.hintColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatInt(int n) {
    final neg = n < 0;
    final s = n.abs().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
        final posFromEnd = s.length - i;
        buf.write(s[i]);
        if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write(',');
    }
    return neg ? '-${buf.toString()}' : buf.toString();
}

TextSpan _highlightMatch(String text, String query, ThemeData theme, {double fontSize = 16}) {
  final baseStyle = TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: fontSize, fontWeight: FontWeight.w600);
  final highlightStyle = TextStyle(color: theme.colorScheme.primary, fontSize: fontSize, fontWeight: FontWeight.w800);

  if (query.isEmpty) return TextSpan(text: text, style: baseStyle);

  // 대소문자 무시 매칭
  final lowerText = text.toLowerCase();
  final lowerQuery = query.toLowerCase();
  int index = lowerText.indexOf(lowerQuery);

  if (index == -1) {
      return TextSpan(text: text, style: baseStyle);
  }

  return TextSpan(
    children: [
      if (index > 0)
        TextSpan(text: text.substring(0, index), style: baseStyle),
      TextSpan(
        text: text.substring(index, index + query.length),
        style: highlightStyle,
      ),
      if (index + query.length < text.length)
        TextSpan(text: text.substring(index + query.length), style: baseStyle),
    ],
  );
}
