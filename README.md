# eticon_api

Networking package

## Usage

First, set the base url:
```dart
void main(){
  Api.setBaseUrl('https://example.com/');
  runApp(MyApp());
}
```

Next, create a function to send requests:
```dart
Future<void> getRequest() async {
    try{
      Map<String, dynamic> response = await Api.get(method: 'product',);
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
  ```

To set headers use Api.setHeaders. Please note that on an authorized request, the header "Authorization" will be automatically added. Default headers is only "Content-type": 'application/json', if you want to change them use the described method.
```dart
void main() async {
  bool tokenLoaded = await Api.loadTokenFromMemory();
  if(tokenLoaded){
    print(Api.token);
  }
  Api.setBaseUrl('https://example.com/');
  Api.setHeaders({"Content-type": 'application/json'});
  runApp(MyApp());
}
```
Available methods:
  * get
  * post
  * put
  * delete

## Authorizathion Token


For authorized requests, you need to set a token. The token will also be written to the device memory:
```dart
await Api.setToken('{your_token}');
```

Getting a written token:
```dart
Api.token;
```

At the start of the application, you can unload the recorded token into the device memory, for example, so as not to re-authorize:
```dart
void main() async {
  bool tokenLoaded = await Api.loadTokenFromMemory();
  if(tokenLoaded){
    print(Api.token);
  }
  Api.setBaseUrl('https://example.com/');
  runApp(MyApp());
}
```

To send an authorized request, you just need to set the isAuth parameter to true:
```dart
Future<void> getRequest() async {
    try{
      Map<String, dynamic> response = await Api.post(method: 'send', body:{'count': 1}, isAuth: true);
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
  ```

## Test Mode
Test mode is a handy tool for application development that shows complete information about the request (parameters, full url, response body, etc.). Also, this function disables all error handlers. 
Test mode can be set both globally for all requests in the project:
```dart
void main() async {
  bool tokenLoaded = await Api.loadTokenFromMemory();
  if(tokenLoaded){
    print(Api.token);
  }
  Api.setBaseUrl('https://example.com/');
  Api.globalTestMode(true);
  runApp(MyApp());
}
```

And for an individual request:
```dart
Future<void> getRequest() async {
    try{
      Map<String, dynamic> response = await Api.put(method: 'user/update', body:{'first_name': 'Andrew'}, isAuth: true, testMode: true);
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
```
To disable everything in the test mode in the project, you can use disableAllTestMode:
```dart
void main() async {
  bool tokenLoaded = await Api.loadTokenFromMemory();
  if(tokenLoaded){
    print(Api.token);
  }
  Api.setBaseUrl('https://example.com/');
  Api.globalTestMode(true); // Will be ignored
  Api.disableAllTestMode(true);
  runApp(MyApp());
}
```
## UTF-8 Decoding

There is built-in support for decoding in response to utf-8
```dart
void main() async {
  Api.setBaseUrl('https://example.com/');
  Api.enableUtf8Decoding(true);
  runApp(MyApp());
}



## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
