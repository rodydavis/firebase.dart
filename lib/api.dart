library firebase_rest_api;

import 'dart:async';
import 'dart:convert';

import 'src/impl/unsupported.dart'
    if (dart.library.html) 'src/impl/browser.dart'
    if (dart.library.io) 'src/impl/io.dart';
import 'utils/push_id_generator.dart';

part 'src/client.dart';
part 'src/endpoints.dart';
part 'src/token.dart';
part 'src/types/collection_reference.dart';
part 'src/types/document_reference.dart';
part 'src/types/document_snapshot.dart';
part 'src/types/user/user.dart';
part 'src/types/user/providers.dart';
part 'src/types/object.dart';
part 'src/types/reference.dart';
