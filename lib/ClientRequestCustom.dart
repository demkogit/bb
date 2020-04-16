import 'dart:convert';
import 'dart:io';

class ClientRequestCustom extends HttpClientRequest{
  @override
  Encoding encoding;

  @override
  void add(List<int> data) {
    // TODO: implement add
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    // TODO: implement addError
  }

  @override
  Future addStream(Stream<List<int>> stream) {
    // TODO: implement addStream
    throw UnimplementedError();
  }

  @override
  Future<HttpClientResponse> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  // TODO: implement connectionInfo
  HttpConnectionInfo get connectionInfo => throw UnimplementedError();

  @override
  // TODO: implement cookies
  List<Cookie> get cookies => throw UnimplementedError();

  @override
  // TODO: implement done
  Future<HttpClientResponse> get done => throw UnimplementedError();

  @override
  Future flush() {
    // TODO: implement flush
    throw UnimplementedError();
  }

  @override
  // TODO: implement headers
  HttpHeaders get headers => throw UnimplementedError();

  @override
  // TODO: implement method
  String get method => throw UnimplementedError();

  @override
  // TODO: implement uri
  Uri get uri => throw UnimplementedError();

  @override
  void write(Object obj) {
    // TODO: implement write
  }

  @override
  void writeAll(Iterable objects, [String separator = ""]) {
    // TODO: implement writeAll
  }

  @override
  void writeCharCode(int charCode) {
    // TODO: implement writeCharCode
  }

  @override
  void writeln([Object obj = ""]) {
    // TODO: implement writeln
  }
  
}