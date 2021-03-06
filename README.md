<img src="https://user-images.githubusercontent.com/36012868/130392291-52b82b9b-fd52-424b-ba5a-b7630e9cf343.png" data-canonical-src="https://user-images.githubusercontent.com/36012868/130392291-52b82b9b-fd52-424b-ba5a-b7630e9cf343.png" height="200" width=400/>

[![English](https://img.shields.io/badge/Language-Russian-blue?style=plastic)](https://github.com/kensamare/eticon_api/blob/master/doc/README_RU.md)

# ETICON API
Package for working with http requests.

## Initialization

First you need to initialize:

```dart
void main() async {
  await Api.init(baseUrl: 'https://example.com/');
  runApp(MyApp());
}
```

## Methods

| | | | |
|-|-|-|-|
|__Parameters__|__Request type__|__Value__|
| isAuth | ALL | If the value is ***true***, the request will be authorized |
| method | ALL | Accepts a string appended to ***baseURL*** |
| body | POST, PUT | Accepts request body in ***Map*** |
| query | GET, DELETE | Accepts query in ***Map*** |
| testMode| ALL | if ***true*** shows detailed information about the request |

### GET

```dart
Future<void> getRequest() async {
    try{
      Map<String, dynamic> response = await Api.get(method: 'product', query: {"id": 5});
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
```

### POST

```dart
Future<void> postRequest() async {
    try{
      Map<String, dynamic> response = await Api.post(method: 'product', body: {"id": 5});
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
```

### DELETE

```dart
Future<void> deleteRequest() async {
    try{
      Map<String, dynamic> response = await Api.delete(method: 'product', query: {"id": 5}, isAuth: true);
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
```

### PUT

```dart
Future<void> putRequest() async {
    try{
      Map<String, dynamic> response = await Api.put(method: 'product', body: {"id": 5}, isAuth: true);
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
```

## Raw Methods

All raw methods take the url to be requested. In case of GET and DELETE without parameters.
They are specified separately as in the methods described above.

```dart
Future<void> request() async {
    try{
      Map<String, dynamic> response = await Api.rawGet(url: 'https://example.com/profile', query: {"id": 5}, headers: {"Content-type": 'application/json'});
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
```

```dart
Future<void> request() async {
    try{
      Map<String, dynamic> response = await Api.rawPost(url: 'https://example.com/profile', body: {"id": 5}, headers: {"Content-type": 'application/json'});
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
```

```dart
Future<void> request() async {
  try{
    Map<String, dynamic> response = await Api.rawDelete(url: 'https://example.com/profile', query: {"id": 5}, headers: {"Content-type": 'application/json'});
  } on APIException catch(error){
    print('ERROR CODE: ${error.code}');
  }
}
```

```dart
Future<void> request() async {
  try{
    Map<String, dynamic> response = await Api.rawPut(url: 'https://example.com/profile', body: {"id": 5}, headers: {"Content-type": 'application/json'});
  } on APIException catch(error){
    print('ERROR CODE: ${error.code}');
  }
}
```

## HTTP status codes

If the result of the status code in the response is not 200, then **APIException** will be thrown. It contains the status code as well as the response body.
In case there are problems with the Internet connection, **APIException** will return code 0.

## Headers

To declare headers, you must use the method:
```dart
  Api.setHeaders({"Content-type": 'application/json'});
```

> If no headers are set then the default is ***Content-type***: ***application / json***

Note!!! that the ***Authorization*** header is added automatically on an authorized request.

## Authorization

For authorized requests, you need to set the token value. The set value will be written to the device memory.
When using Api.init (), the token will be automatically unloaded from the device memory. But you can disable loadTokenFromMemory:

```dart
void main() async {
  await Api.init(baseUrl: 'https://example.com/', loadTokenFromMemory: false);
  runApp(MyApp());
}
```

```dart
  Api.setToken('{your_token}');
```

Get a token:

```dart
  Api.token;
```

You can also check the token for emptiness or non-emptiness:

```dart
  Api.tokenIsEmpty;//return true or false
  Api.tokenIsNotEmpty;//return true or false
```

If you do not use the ***Bearer*** type in the token, then disable it:

```dart
void main() async {
  await Api.init(baseUrl: 'https://example.com/', bearerToken: false);
  runApp(MyApp());
}
```

## Test Mode

Test Mode is a handy tool for developing an application that shows complete information about the request (parameters, full URL, response body, etc.). In addition, this feature disables all error handlers. Test mode can be set globally for all requests in the project:

```dart
void main() async {
  await Api.init(baseUrl: 'https://example.com/', globalTestMode: true);
  runApp(MyApp());
}

```
And on a separate request:

```dart
Future<void> getRequest() async {
    try{
      Map<String, dynamic> response = await Api.get(method: 'product', isAuth: true, testMode: true);
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }

```

To disable test mode in the whole project, you can use ***disableAllTestMode***:

```dart
void main() async {
  await Api.init(
    baseUrl: 'https://example.com/', 
    globalTestMode: true, // Will be ignored
    disableAllTestMode: true,
  );
  runApp(MyApp());
}
```

## Server storage url
It is often necessary to get various data from the server storage, for example, images. However, the base url and the url to the storage sometimes don't match or you have to write the url manually each time.

To set a storage url, it must be specified in the initialization:

```dart
void main() async {
  await Api.init(baseUrl: 'https://example.com/', storageUrl: 'https://example.com/storage/');
  runApp(MyApp());
}
```

Usage example:

```dart
Image.network(Api.dataFromStorage('image.png'));
```

## Decoding UTF-8

There is built-in support for decoding in response to utf-8

```dart
void main() async {
  await Api.init(
    baseUrl: 'https://example.com/', 
    ebableUtf8Decoding: true,
  );
  runApp(MyApp());
}
```

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
