abstract class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T>{
  final T data;

  const Success(this.data);
}

class Failure<T> extends ApiResult<T>{
  final String message;
  final int? code;

  const Failure(this.message, {this.code});
}