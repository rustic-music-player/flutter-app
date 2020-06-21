import 'dart:developer';

import 'package:bloc/bloc.dart';

class BlocLoggerDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    log(transition.toString());
    super.onTransition(bloc, transition);
  }
}
