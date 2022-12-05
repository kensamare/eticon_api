<img src="https://user-images.githubusercontent.com/36012868/130392291-52b82b9b-fd52-424b-ba5a-b7630e9cf343.png" data-canonical-src="https://user-images.githubusercontent.com/36012868/130392291-52b82b9b-fd52-424b-ba5a-b7630e9cf343.png" height="200" width=400/>

[![Russian](https://img.shields.io/badge/Language-Russian-blue?style=plastic)](https://github.com/kensamare/eticon_api/blob/master/doc/README_RU.md)

# ETICON API

Library for working with http requests.

## Pay attention to important changes since version 2.0.0!
The library for working with the network has been changed. Instead of http, Dio is now used.

If you want to use the new version in older projects, either update all requests, or replace the Api when using requests with OldApi.
OldApi needs to be used exclusively for the requests themselves (get, post, patch, put).

However, some changes cannot be avoided, for example, abandoning the baseUrl in the initialization and replacing it with a list of urls. This was done to be able to interact with different services, while not my url.

The named parameter method has been removed from requests. Now you can pass both the method and the full url, respectively, rawGet, rawPost, rawPut, rawPatch have been removed.

It is also worth paying attention to the type of the returned data type, now the request can return either Map<String, dynamic> or the Response class.


## Content
- [Initialization](#initialization)
- [Methods](#methods)
- [Response type](#response-type)
- [Headers](#headers)
- [Authorization](#authorization)
- [Refresh token](#refresh-token)
- [Sending MultiPart-Formdata](#send-multipart-formdata)
- [Test Mode](#test-mode)
- [Link to server datastore](#link-to-server-datastore)

## Initialization

First you need to initialize:

```dart
void main() async {
   await Api.init(urls: ['https://example.com/']);
   runApp(MyApp());
}
```

For the same type of behavior on the same error code, you can use onAllError. For example, when receiving a 401 code, send the user to the authorization screen.

```dart
void main() async {
   await Api.init(urls: ['https://example.com/'],
   onAllError: (err) {
         if (err.code == 401) Get.offAll(() => AuthScreenProvider());}
   );
   runApp(MyApp());
}
```

## Methods

| | | | |
|-|-|-|-|
|__Fields__|__RequestType__|__Value__|
| isAuth | All | If set to ***true***, the request will be authorized |
| method | All | Accepts a string that is appended to ***baseURL*** |
| body | POST, PUT, PATCH | Accepts a request body in ***Map*** |
| query | GET, DELETE | Accepts parameters in ***Map*** |
| testmode| All | If set to ***true***, show detailed information about the request |

### GET

```dart
future<void> getRequest() async {
     try{
       Map<String, dynamic> response = await Api.get('product', query: {"id": 5});
     } on APIException catch(error){
       print('ERROR CODE: ${error.code}');
     }
   }
```

### POST

```dart
future<void> postRequest() async {
     try{
       Map<String, dynamic> response = await Api.post('product', body: {"id": 5});
     } on APIException catch(error){
       print('ERROR CODE: ${error.code}');
     }
   }
```

### DELETE

```dart
future<void> deleteRequest() async {
     try{
       Map<String, dynamic> response = await Api.delete(method: 'product', query: {"id": 5}, isAuth: true);
     } on APIException catch(error){
       print('ERROR CODE: ${error.code}');
     }
   }
```

### PUT

```dart
future<void> putRequest() async {
     try{
       Map<String, dynamic> response = await Api.put('product', body: {"id": 5}, isAuth: true);
     } on APIException catch(error){
       print('ERROR CODE: ${error.code}');
     }
   }
```
### PATCH

```dart
Future<void> patchRequest() async {
     try{
       Map<String, dynamic> response = await Api.patch('product', body: {"id": 5}, isAuth: true);
     } on APIException catch(error){
       print('ERROR CODE: ${error.code}');
     }
   }
```

About [CancelToken](https://pub.dev/packages/dio#cancellation), onSendProgress and onReciveProgress can be read on the page [Dio](https://pub.dev/packages/dio#cancellation)

## Response type

For all requests, you can set the response type (ResponseType), unlike Dio, another type has been added that does not return a full-fledged class, but returns only Map<String, dynamic>, for this you need to use ResponseType.map_data (the default value in all requests) . In other cases, the Response class will return, similar to Dio.

```dart
{
   /// Response body. may have been transformed, please refer to [ResponseType].
   T? data;
   /// Response headers.
   header headers;
   /// The corresponding request info.
   options request;
   /// Http status code.
   int? statusCode;
   String? statusMessage;
   /// Whether redirect
   bool? isRedirect;
   /// redirect info
   List<RedirectInfo> redirects ;
   /// Returns the final real request uri (maybe redirect).
   Uri realUri;
   /// Custom field that you can retrieve it later in `then`.
   Map<String, dynamic> extra;
}
```

## Headers

To declare global headers, you must use the method:

```dart
   Api.setHeaders({"Content-type": 'application/json'});
```

> If no headers are set, the default header is ***Content-type*** : ***application/json***

Note!!! that the ***Authorization** header is added automatically on an authorized request.

Headers can also be set and for a separate request I use the headers parameter, if the header key was declared globally, then it will be overwritten from the specified parameter.

## Authorization

For authorized requests, you must set the value of the token. The set value will be written to the device memory.
When using Api.init(), the token will be automatically unloaded from the device's memory.

```dart
   api.setToken('{your_token}');
```

Get a token:

```dart
   api.token;
```

Clear token:
```dart
   api.clearToken;
```

You can also check if the token is empty or not empty:

```dart
   Api.tokenIsEmpty;//return true or false
   api.tokenIsNotEmpty;//return true or false
```

If you are not using the ***Bearer*** type in the token, disable it:

```dart
void main() async {
   await Api.init(urls: ['https://example.com/'], bearerToken: false);
   runApp(MyApp());
}
```

## Refresh token
by analogy with the authorization token, you can use the refresh token:
```dart
   Api.setRefreshToken('{your_token}');
```

Get a token:

```dart
   api.refreshToken;
```

Clear token:
```dart
   api.clearRefreshToken;
```

You can also check if the token is empty or not empty:

```dart
   Api.refreshTokenIsEmpty;//return true or false
   Api.refreshTokenIsNotEmpty;//return true or false
```

Set token expiration time in seconds:
```dart
   API.setExpire(3600);
```

Checking if the authorization token has expired:
```dart
   api.isTokenExpire;
```

Get the expiration date of the authorization token:
```dart
   api.expireDate;
```

## Send MultiPart-Formdata

You can also submit FormData which will post data to `multipart/form-data` and support file uploads.

```dart
var formData = FormData.fromMap({
   'name': 'wendux',
   'age': 25,
   'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
});
response = await Api.post('/info', data: formData);
```

### Upload multiple files

There are two ways to add multiple files to `FormData`, the only difference is that the upload keys are different for array types。

```dart
FormData.fromMap({
   'files': [
     MultipartFile.fromFileSync('./example/upload.txt', filename: 'upload.txt'),
     MultipartFile.fromFileSync('./example/upload.txt', filename: 'upload.txt'),
   ]
});
```

The upload key eventually becomes "files[]". This is because many back-end services add a middle bracket to the key when they receive an array of files. **If you don't need "[]"**, you should create FormData like this (don't use `FormData.fromMap`):

```dart
var formData = FormData();
formData.files.addAll([
   MapEntry('files',
     MultipartFile.fromFileSync('./example/upload.txt',filename: 'upload.txt'),
   ),
   MapEntry('files',
     MultipartFile.fromFileSync('./example/upload.txt',filename: 'upload.txt'),
   ),
]);
```

## Test Mode

Test mode is a handy application development tool that shows complete request information (parameters, full URL, response body, etc.). In addition, this function disables all error handlers. The test mode can be set as global for all requests in the project:

```dart
void main() async {
   await Api.init(urls: ['https://example.com/'], globalTestMode: true);
   runApp(MyApp());
}

```
And on a separate request:

```dart
future<void> getRequest() async {
     try{
       Map<String, dynamic> response = await Api.get(method: 'product', isAuth: true, testMode: true);
     } on APIException catch(error){
       print('ERROR CODE: ${error.code}');
     }
   }

```

To disable test mode in the entire project, you can use ***disableAllTestMode***:

```dart
void main() async {
   await Api.init(
     urls: ['https://example.com/'],
     globalTestMode: true, // Will be ignored
     disableAllTestMode: true
   );
   runApp(MyApp());
}
```
## Link to server datastore

It is often necessary to receive various data from the server storage, for example, images, but the base link and the storage link sometimes do not match, or you have to manually enter the url each time.

To set a reference to the storage, it must be specified in the initialization:

```dart
void main() async {
   await Api.init(urls: ['https://example.com/'], storageUrl: 'https://example.com/storage/');
   runApp(MyApp());
}
```
Usage example:

```dart
Image.network(Api.dataFromStorage('image.png'));
```

## UTF-8 decryption

There is built-in support for decoding in response to utf-8

```dart
void main() async {
   await Api.init(
     urls: ['https://example.com/'],
     ebableUtf8Decoding: true
   );
   runApp(MyApp());
}
```
