import 'package:get_it/get_it.dart';
import 'package:quiz/app/data/local/preference/score_local_source.dart';
import 'package:quiz/app/data/local/preference/score_local_source_impl.dart';
import 'package:quiz/app/data/local/question_local/questions_local_source.dart';
import 'package:quiz/app/data/local/question_local/questions_local_source_impl.dart';
import 'package:quiz/app/data/remote/fetch/remote_source.dart';
import 'package:quiz/app/data/remote/fetch/remote_source_impl.dart';
import 'package:quiz/app/data/repository/questions_repository_source.dart';
import 'package:quiz/app/data/repository/questions_repository_source_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

class ServiceLocator {
  static Future<void> setUpServiceLocator() async {
    // serviceLocator.registerLazySingleton<RemoteSource>(
    //   () => RemoteSourceImpl(remoteSource: serviceLocator()),
    // );

    serviceLocator.registerLazySingleton<QuestionLocalSource>(
      () => QustionsLocalSourceImpl(),
    );

    serviceLocator.registerLazySingleton<QuestionRepositorySource>(
      () => QuestionRepositorySourceImpl(),
    );

    serviceLocator.registerLazySingleton<RemoteSource>(
      () => RemoteSourceImpl(),
    );

    final prefs = await SharedPreferences.getInstance();

    serviceLocator.registerSingleton<SharedPreferences>(prefs);
    serviceLocator.registerLazySingleton<ScoreLocalSource>(
      () => ScoreLocalSourceImpl(serviceLocator<SharedPreferences>()),
    );
    // serviceLocator.registerFactory<DatabaseHelper>(() => DatabaseHelper());

    // serviceLocator.registerLazySingleton<PrefManager>(() => PrefManagerImpl());
  }
}
