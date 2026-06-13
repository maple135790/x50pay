import 'package:x50pay/providers/environment_provider.dart';

class RepositoryFactory {
  const RepositoryFactory._();

  static T create<T>(
    EnvironmentProvider envProvider, {
    required T Function() apiBuilder,
    required T Function() localBuilder,
  }) {
    if (envProvider.isServiceOnline) return apiBuilder();
    return localBuilder();
  }
}
