import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:rustic/api/models/open_result.dart';
import 'package:rustic/state/server_bloc.dart';

class ShareUrlBloc extends Bloc<Uri, OpenResultModel?> {
  final ServerBloc serverBloc;

  ShareUrlBloc(this.serverBloc): super(null) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      ReceiveSharingIntent.getTextStreamAsUri()
          .listen((value) => this.add(value));
      ReceiveSharingIntent.getInitialTextAsUri()
          .then((value) {
            if (value == null) {
              return;
            }
            this.add(value);
          });
    }
    on<Uri>((event, emit) async {
      emit(await serverBloc.getApi()!.resolveShareUrl(event));
    });
  }
}
