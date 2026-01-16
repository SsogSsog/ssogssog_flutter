import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchResultList extends StatelessWidget {
  final List<String> results;
  final String query;

  const SearchResultList({
    super.key,
    required this.results,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (results.isEmpty) {
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
      itemCount: results.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final stockName = results[index];
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
            text: _highlightMatch(stockName, query, theme),
          ),
          subtitle: const Text('005930 · KOSPI'), // Mock sub detail
          trailing: const Icon(Icons.star_border), // 즐겨찾기 아이콘 (기능 미구현)
          onTap: () {
            // TODO: 상세 페이지로 이동
            // 임시로 Mock Code 하나 넘겨줌
            context.push('/stock/005930'); 
          },
        );
      },
    );
  }

  TextSpan _highlightMatch(String text, String query, ThemeData theme) {
    if (query.isEmpty) return TextSpan(text: text, style: TextStyle(color: theme.textTheme.bodyLarge?.color));

    final matches = text.toLowerCase().split(query.toLowerCase());
    if (matches.length <= 1) return TextSpan(text: text, style: TextStyle(color: theme.textTheme.bodyLarge?.color));

    final children = <TextSpan>[];
    int start = 0;
    
    // 단순 포함 여부 하이라이팅 (대소문자 무시)
    // 실제로는 정규식 등으로 더 정교하게 할 수 있음. 여기선 간단하게 처리.
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
