library firestore_api;

import 'dart:async';

import 'src/impl/unsupported.dart'
    if (dart.library.html) 'src/impl/browser.dart'
    if (dart.library.io) 'src/impl/io.dart';

part 'src/client.dart';
part 'src/token.dart';
part 'src/endpoints.dart';
part 'src/types/object.dart';

part 'src/types/vehicle.dart';
