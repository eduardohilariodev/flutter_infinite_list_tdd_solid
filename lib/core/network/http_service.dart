import 'package:equatable/equatable.dart';

abstract interface class HttpService {
  Future<HttpResponse> get(String url, {Map<String, dynamic>? headers});
}

final class HttpResponse extends Equatable {
  const HttpResponse(this.data, this.statusCode);

  final Map<String, dynamic> data;
  final int statusCode;

  @override
  List<Object?> get props => [data, statusCode];
}
