import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rustic/state/provider_bloc.dart';

const Map<String, ProviderStyle> providerMap = {
  'gmusic':
      ProviderStyle(MdiIcons.googlePlay, Color.fromARGB(255, 255, 87, 34)),
  'spotify': ProviderStyle(MdiIcons.spotify, Color.fromARGB(255, 29, 185, 84)),
  'soundcloud':
      ProviderStyle(MdiIcons.soundcloud, Color.fromARGB(255, 255, 85, 0)),
  'plex': ProviderStyle(MdiIcons.plex, Color.fromARGB(255, 229, 160, 13)),
  'youtube': ProviderStyle(MdiIcons.youtube, Color.fromARGB(255, 255, 0, 0)),
  'local': ProviderStyle(MdiIcons.folder, Color.fromARGB(255, 96, 125, 139)),
  'pocketcasts':
      ProviderStyle(MdiIcons.podcast, Color.fromARGB(255, 244, 67, 54))
};

class ProviderStyle {
  final IconData icon;
  final Color color;

  const ProviderStyle(this.icon, this.color);
}

class ProviderSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderBloc, ProviderList>(
        builder: (context, state) => Container(
              height: 64,
              padding: EdgeInsets.all(4),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: state.providers
                    .map((provider) => ProviderToggle(provider,
                        providerMap[provider], state.active.contains(provider)))
                    .toList(),
              ),
            ));
  }
}

class ProviderToggle extends StatelessWidget {
  final ProviderStyle providerStyle;
  final String provider;
  final bool active;

  const ProviderToggle(
    this.provider,
    this.providerStyle,
    this.active, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = context.bloc<ProviderBloc>();
    return Padding(
      padding: EdgeInsets.all(4),
      child: Ink(
        decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: active ? this.providerStyle.color : Colors.black87),
        child: IconButton(
          onPressed: () {
            bloc.add(ToggleProvider(this.provider));
          },
          icon: Icon(
            this.providerStyle.icon,
            color: this.active ? Colors.white70 : Colors.white54,
            size: 24,
          ),
        ),
      ),
    );
  }
}
