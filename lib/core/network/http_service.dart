import 'package:equatable/equatable.dart';

abstract interface class HttpService {
  Future<HttpResponse<T>> get<T>(String url, {Map<String, dynamic>? headers});
}

final class HttpResponse<T> extends Equatable {
  const HttpResponse(this.data, this.statusCode);

  final T data;
  final int statusCode;

  @override
  List<Object?> get props => [data, statusCode];
}
  