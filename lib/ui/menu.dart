import 'package:flutter/material.dart';

class MenuContainer extends StatelessWidget {
  final VoidCallback onTap;
  final List<MenuItem> items;
  final Widget child;

  MenuContainer({this.onTap, this.items, this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: this.onTap,
        onSecondaryTapDown: (event) {
          var left = event.globalPosition.dx;
          var top = event.globalPosition.dy;
          return showMenu(
              context: context,
              position: RelativeRect.fromLTRB(left, top, left + 8, top + 8),
              items: this.items.map((e) => e.desktop(context)).toList());
        },
        onLongPress: () => showModalBottomSheet(
            context: context,
            builder: (context) => DraggableScrollableSheet(
                  builder: (context, scrollController) => Container(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: this.items.length,
                      itemBuilder: (context, index) =>
                          this.items[index].mobile(context),
                    ),
                  ),
                )),
        child: this.child);
  }
}

class MenuItem {
  final VoidCallback onSelect;
  final String text;
  final IconData icon;

  MenuItem(this.text, {this.onSelect, this.icon});

  PopupMenuEntry desktop(BuildContext context) {
    return PopupMenuItem(
        child: GestureDetector(
            onTap: () {
              this.onSelect();
              Navigator.pop(context);
            },
            child: Text(this.text)));
  }

  Widget mobile(BuildContext context) {
    return ListTile(
        title: Text(this.text), leading: Icon(this.icon), onTap: this.onSelect);
  }
}
