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
## Test Mode



```bool tokenLoaded = await Api.loadTokenFromMemory();```

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
