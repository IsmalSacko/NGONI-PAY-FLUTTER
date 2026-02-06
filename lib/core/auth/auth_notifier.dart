import 'package:flutter/foundation.dart';

final ValueNotifier<int> authRefreshNotifier = ValueNotifier<int>(0);

void notifyAuthChanged() {
  authRefreshNotifier.value++;
}
