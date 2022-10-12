import 'package:flutter/material.dart';
import 'package:rustic/views/search/search.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () => Navigator.of(context).pushNamed(SearchView.routeName),
      tooltip: 'Search',
    );
  }
}
