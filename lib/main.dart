import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/supabase_config.dart';
import 'features/auth/data/datasources/supabase_auth_data_source.dart';
import 'features/auth/data/datasources/supabase_profile_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/repositories/profile_repository_impl.dart';
import 'features/auth/domain/usecases/sign_up_use_case.dart';
import 'features/auth/presentation/bloc/register_bloc.dart';
import 'features/auth/presentation/screens/register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!SupabaseConfig.isConfigured) {
    runApp(const _MissingConfigApp());
    return;
  }

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Composición: datos -> dominio -> presentación. Solo se hace aquí.
  final client = Supabase.instance.client;
  final authRepository = AuthRepositoryImpl(SupabaseAuthDataSource(client));
  final profileRepository =
      ProfileRepositoryImpl(SupabaseProfileDataSource(client));
  final signUpUseCase = SignUpUseCase(authRepository, profileRepository);

  runApp(MyApp(signUpUseCase: signUpUseCase));
}

class MyApp extends StatelessWidget {
  final SignUpUseCase signUpUseCase;
  const MyApp({super.key, required this.signUpUseCase});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(signUpUseCase),
      child: MaterialApp(
        title: 'Registro',
        theme: ThemeData(
          colorSchemeSeed: Colors.green,
          useMaterial3: true,
        ),
        home: const RegisterScreen(),
      ),
    );
  }
}

class _MissingConfigApp extends StatelessWidget {
  const _MissingConfigApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Faltan SUPABASE_URL y SUPABASE_ANON_KEY.\n'
              'Ejecuta con --dart-define (mira el README).',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
