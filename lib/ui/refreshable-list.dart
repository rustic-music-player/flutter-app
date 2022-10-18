import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rustic/state/list_bloc.dart';

class RefreshableList<TBloc extends ListBloc<TItem>, TItem>
    extends StatefulWidget {
  final Widget Function(BuildContext, TItem) builder;

  RefreshableList({required this.builder, Key? key}) : super(key: key);

  @override
  State<RefreshableList<TBloc, TItem>> createState() => _RefreshableListState();
}

class _RefreshableListState<TBloc extends ListBloc<TItem>, TItem>
    extends State<RefreshableList<TBloc, TItem>> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TBloc, ListState<TItem>>(
      builder: (context, state) {
        // TODO: show loading indicator when state.loading is true
        if (!state.loading) {
          _refreshController.refreshCompleted();
        }
        TBloc bloc = context.read();
        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          header: MaterialClassicHeader(),
          onRefresh: () => bloc.add(FetchList()),
          child: ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, i) =>
                widget.builder(context, state.items[i]),
          ),
        );
      },
    );
  }
}
