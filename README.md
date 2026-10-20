# Registro con arquitectura limpia (Flutter + Bloc + Supabase)

Laboratorio 5: registrar un usuario = crear la cuenta (Supabase Auth) y guardar su perfil (tabla `profiles`).

## Arquitectura

```
presentation  RegisterScreen -> RegisterBloc
domain        SignUpUseCase (decide el orden) · AuthRepository · ProfileRepository
data          *RepositoryImpl -> SupabaseAuthDataSource · SupabaseProfileDataSource
```

- El `Bloc` hace una sola llamada al caso de uso.
- `SignUpUseCase` pone el orden: primero la cuenta, luego el perfil con el `id` de Auth.
- Solo los data sources usan el SDK de Supabase.

## Puesta en marcha

1. **Genera las carpetas de plataforma** (una sola vez, no toca `lib/`):

   ```
   flutter create . --project-name registro_clean
   ```

   Esto crea `android/`, `ios/`, etc. y un `test/widget_test.dart` de ejemplo que debes **borrar**
   (el test de este proyecto es `test/sign_up_use_case_test.dart`).

2. **Instala dependencias:** `flutter pub get`

3. **Crea la tabla** ejecutando `supabase/profiles.sql` en el SQL Editor de Supabase.

4. **Desactiva la confirmación de correo** (para el laboratorio): Supabase -> Authentication ->
   Providers -> Email -> apaga *Confirm email*. Si queda activa, `signUp` no inicia sesión y la política
   RLS rechaza el insert del perfil.

5. **Ejecuta** con tus claves (Supabase -> Project Settings -> API):

   ```
   flutter run --dart-define=SUPABASE_URL=https://TU-PROYECTO.supabase.co --dart-define=SUPABASE_ANON_KEY=TU_ANON_KEY
   ```

6. **Pruebas:** `flutter test`

## Casos a probar

- Registro normal: aparece el usuario en Auth y la fila en `profiles`.
- Mismo correo dos veces: el formulario vuelve con el mensaje y no se crea perfil.
- Contraseñas distintas: la vista se detiene y el Bloc no se entera.
