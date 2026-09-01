import 'package:dio/dio.dart';

import '../async/loadable.dart';
import '../config/env.dart';

/// Maps the active app locale to the `Accept-Language` header (docs/04 §4).
typedef LanguageTagProvider = String Function();

/// Supplies the current access token, or null when signed out.
typedef AccessTokenProvider = String? Function();

/// Builds the shared Dio instance. Error responses are converted to [AppError]
/// via the docs/04 §4.1 envelope in a single interceptor, so repositories only
/// ever deal in [AppError] — never raw [DioException].
Dio buildDio({
  AccessTokenProvider? accessToken,
  LanguageTagProvider? languageTag,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = accessToken?.call();
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        options.headers['Accept-Language'] = languageTag?.call() ?? 'uz-Latn';
        handler.next(options);
      },
      onError: (e, handler) {
        // Re-wrap with an AppError so callers get a stable, localized-mappable code.
        handler.reject(
          DioException(
            requestOptions: e.requestOptions,
            response: e.response,
            type: e.type,
            error: mapDioError(e),
          ),
        );
      },
    ),
  );

  return dio;
}

/// Convert any thrown object from a dio call into an [AppError].
AppError mapDioError(Object error) {
  if (error is AppError) return error;
  if (error is! DioException) return AppError.unknown;

  switch (error.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return AppError.offline;
    default:
      break;
  }

  final data = error.response?.data;
  if (data is Map && data['error'] is Map) {
    final env = (data['error'] as Map).cast<String, dynamic>();
    final code = env['code'] as String?;
    if (code != null) {
      return AppError(
        code: code,
        serverMessage: env['message'] as String?,
        field: env['field'] as String?,
        retryAfter: (env['retryAfter'] as num?)?.toInt(),
      );
    }
  }
  return AppError.unknown;
}
