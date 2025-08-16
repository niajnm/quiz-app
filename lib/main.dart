import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quiz/app/route/route_services.dart';
import 'package:quiz/app/core/provider/provider.dart';
import 'package:quiz/app/core/services/service_locator.dart';
import 'package:quiz/flavors/build_config.dart';
import 'package:quiz/flavors/env_config.dart';
import 'package:quiz/flavors/environment.dart';

void main() async {
  EnvConfig devConfig = EnvConfig(
    appName: "Flutter Dev",
    baseUrl: "https://api.com/",

    /// un used
    shouldCollectCrashLog: true,
  );

  BuildConfig.instantiate(
    envType: Environment.DEVELOPMENT,
    envConfig: devConfig,
  );

  WidgetsFlutterBinding.ensureInitialized();

  // await GetStorage.init(databaseName);
  await ScreenUtil.ensureScreenSize();
  await ServiceLocator.setUpServiceLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(providers: ProviderPath.providersList, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Quiz App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,

      initialRoute: '/',
      onGenerateRoute: RouteServices.generateRoute,
    );
  }
}
