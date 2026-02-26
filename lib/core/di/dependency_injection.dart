import 'package:get_it/get_it.dart';
import 'package:store_app/core/networking/api_services.dart';
import 'package:store_app/core/networking/dio_factory.dart';
import 'package:store_app/features/cart/data/repo/cart_dataset.dart';
import 'package:store_app/features/cart/data/repo/local_cart_repo.dart';
import 'package:store_app/features/cart/logic/local_cart_cubit.dart';
import 'package:store_app/features/comments/data/repo/commentt_repo.dart';
import 'package:store_app/features/comments/data/repo/review_db.dart';
import 'package:store_app/features/home/data/repo/product_repo.dart';
import 'package:store_app/features/home/logic/cubit.dart';
import 'package:store_app/features/login/data/repos/login_repo.dart';
import 'package:store_app/features/login/logic/cubit.dart';
import 'package:store_app/features/todo/data/repo/todo_database.dart';
import 'package:store_app/features/todo/data/repo/todo_repo.dart';
import 'package:store_app/features/todo/logic/todo_cubit.dart';

final getit = GetIt.instance;

Future<void> setUpGetIt() async {
  // ── Dio & ApiServices ─────────────────────────────────────
  final dio = await DioFactory.getDio();
  getit.registerLazySingleton(() => ApiServices(dio));

  // ── Login ─────────────────────────────────────────────────
  getit.registerLazySingleton<LoginRepo>(() => LoginRepo(getit()));
  getit.registerFactory<LoginCubit>(() => LoginCubit(getit()));

  // ── Products ──────────────────────────────────────────────
  getit.registerLazySingleton<ProductRepo>(() => ProductRepo(getit()));
  getit.registerFactory<ProductCubit>(() => ProductCubit(getit()));

  // ── Cart ──────────────────────────────────────────────────
  getit.registerLazySingleton<CartDatabase>(() => CartDatabase.instance);
  getit.registerLazySingleton<LocalCartRepo>(
      () => LocalCartRepo(getit<CartDatabase>()));
  getit.registerLazySingleton<LocalCartCubit>(
      () => LocalCartCubit(getit<LocalCartRepo>()));

  // ── Todo ──────────────────────────────────────────────────
  getit.registerSingleton<TodoDatabase>(TodoDatabase.instance);
  getit.registerSingleton<TodoRepository>(
      TodoRepositoryImpl(getit<TodoDatabase>()));
  getit.registerFactory<TodoCubit>(() => TodoCubit(getit<TodoRepository>()));

  // ── Reviews ✅ ────────────────────────────────────────────
  getit.registerSingleton<ReviewDatabase>(ReviewDatabase.instance);
  getit.registerSingleton<ReviewRepository>(
      ReviewRepositoryImpl(getit<ReviewDatabase>()));
}