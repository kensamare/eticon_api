<img src="https://user-images.githubusercontent.com/36012868/130392291-52b82b9b-fd52-424b-ba5a-b7630e9cf343.png" data-canonical-src="https://user-images.githubusercontent.com/36012868/130392291-52b82b9b-fd52-424b-ba5a-b7630e9cf343.png" height="200" width=400/>

[![English](https://img.shields.io/badge/Language-English-blue?style=plastic)](https://github.com/kensamare/eticon_api#readme)

# ETICON API

Библиотека для работы с http-запросами.

## Обратите внимание на важные изменения с версии 2.0.0!
Изменена бибилотека для работы с сетью. Вместо http теперь используется Dio.

Если же вы хотите использовать новую версию в старых проектах, либо обновляйте все запросы, либо замените Api при использовании запросов на OldApi.
OldApi необходимо применить исключительно для самих запросов (get, post, patch, put).

Однако некоторых изменений избежать не получится, например отказ от baseUrl в инициализации и замены его на список url. Сделано это для возможности взаимодействия с разными сервисами, при этом не меня url.

Из запросов убран именнованный параметр method. Теперь можно передать как метод так и полный url, соотвественно были удалены rawGet, rawPost, rawPut, rawPatсh.

Также стоит обратить внимание на тип возвращаемый тип данных, теперь запрос может вернуть либо Map<String, dynamic>, либо класс Response.


## Содержание
- [Инициализация](#инициализация)
- [Методы](#методы)
- [Тип ответа](#тип-ответа)
- [Заголовки](#заголовки)
- [Авторизация](#авторизация)
- [Рефреш токен](#рефреш-токен)
- [Отправка MultiPart-Formdata](#отправка-multipart-formdata)
- [Test Mode](#test-mode)
- [Ссылка на хранилище данных сервера](#ссылка-на-хранилище-данных-сервера)

## Инициализация

Для начала необходимо провести инициализацию:

```dart
void main() async {
  await Api.init(urls: ['https://example.com/']);
  runApp(MyApp());
}
```

Для однотипного поведения на один и тот же код ошибки можно использовать onAllError. Например при получения кода 401 отправлять пользователя на экран авторизации.

```dart
void main() async {
  await Api.init(urls: ['https://example.com/'],
  onAllError: (err) {
        if (err.code == 401) Get.offAll(() => AuthScreenProvider());}
  );
  runApp(MyApp());
}
```

## Методы

| | | | |
|-|-|-|-|
|__Поля__|__Тип запроса__|__Значение__|
| isAuth | Все | При значении ***true*** запрос будет авторизированным |
| method | Все | Принимает строку, которая добавляется к ***baseURL*** |
| body | POST, PUT, PATCH | Принимает тело запроса в ***Map*** |
| query | GET, DELETE | Принимает параметры в ***Map*** |
| testMode| Все | При значении ***true*** показывает подробную информацию о запросе |

### GET

```dart
Future<void> getRequest() async {
    try{
      Map<String, dynamic> response = await Api.get('product', query: {"id": 5});
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
```

### POST

```dart
Future<void> postRequest() async {
    try{
      Map<String, dynamic> response = await Api.post('product', body: {"id": 5});
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

О [CancelToken](https://pub.dev/packages/dio#cancellation), onSendProgress и onReciveProgress можно прочитать на странице [Dio](https://pub.dev/packages/dio#cancellation)

## Тип ответа

Для всех запросов можно установить тип ответа(ResponseType) в отличии от Dio добавлен еще один тип, который не возвращает полноценный класс, а возвращает только Map<String, dynamic>, для этого необходимо использовать ResponseType.map_data(значение по умолчанию во всех запросах). В остальных же случаях вернется класс Response аналогичны Dio.

```dart
{
  /// Response body. may have been transformed, please refer to [ResponseType].
  T? data;
  /// Response headers.
  Headers headers;
  /// The corresponding request info.
  Options request;
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

## Заголовки

Для объявления глобальных заголовков необходимо использовать метод:

```dart
  Api.setHeaders({"Content-type": 'application/json'});
```

> Если заголовки не установлены, то по умолчанию используется заголовок ***Content-type*** : ***application/json***

Обратите внимание!!! что заголовок ***Authorization** добавляется автоматически при авторизированном запросе.

Заголовки также можно задавать и для отдельного запроса использую параметр headers, если ключ заголовка был объявлен глобально, то он перезапишется из заданного параметра. 

## Авторизация

Для авторизированных запросов необходимо установить значение токена. Установленное значение будет записано в память устройства.
При использование Api.init(), токен автоматически выгрузится из памяти устройства.

```dart
  Api.setToken('{your_token}');
```

Получить токен:

```dart
  Api.token;
```

Очистить токен:
```dart
  Api.clearToken;
```

Также можно проверить токен на пустоту или не пустоту:

```dart
  Api.tokenIsEmpty;//return true or false
  Api.tokenIsNotEmpty;//return true or false
```

Если вы не используете в токене тип ***Bearer***, то отключите его:

```dart
void main() async {
  await Api.init(baseUrl: 'https://example.com/', bearerToken: false);
  runApp(MyApp());
}
```

## Рефреш токен
по аналогии с токеном авторизации можно использовать рефреш токен:
```dart
  Api.setRefreshToken('{your_token}');
```

Получить токен:

```dart
  Api.refreshToken;
```

Очистить токен:
```dart
  Api.clearRefreshToken;
```

Также можно проверить токен на пустоту или не пустоту:

```dart
  Api.refreshTokenIsEmpty;//return true or false
  Api.refreshTokenIsNotEmpty;//return true or false
```

Установить время истекания токена в секундах:
```dart
  Api.setExpire(3600);
```

Проверка, что токен авторизации истек:
```dart
  Api.isTokenExpire;
```

Получить дату истекания токена авторизации:
```dart
  Api.expireDate;
```

## Отправка MultiPart-Formdata

Вы также можете отправить FormData, который будет отправлять данные в `multipart/form-data` и поддерживает загрузку файлов.

```dart
var formData = FormData.fromMap({
  'name': 'wendux',
  'age': 25,
  'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
});
response = await Api.post('/info', data: formData);
```

### Загрузка нескольких файлов

Есть два способа добавить несколько файлов в `FormData`, единственная разница в том, что ключи загрузки различны для типов массивов。

```dart
FormData.fromMap({
  'files': [
    MultipartFile.fromFileSync('./example/upload.txt', filename: 'upload.txt'),
    MultipartFile.fromFileSync('./example/upload.txt', filename: 'upload.txt'),
  ]
});
```

Ключ загрузки в конечном итоге становится «files[]». Это связано с тем, что многие серверные службы добавляют к ключу среднюю скобку, когда получают массив файлов. **Если вам не нужен «[]»**, вам следует создать FormData следующим образом (не используйте `FormData.fromMap`):

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

Режим тестирования - это удобный инструмент для разработки приложения, который показывает полную информацию о запросе (параметры, полный URL-адрес, тело ответа и т. д.). Кроме того, эта функция отключает все обработчики ошибок. Тестовый режим можно установить как глобально для всех запросов в проекте:

```dart
void main() async {
  await Api.init(baseUrl: 'https://example.com/', globalTestMode: true);
  runApp(MyApp());
}

```
И по отдельному запросу:

```dart
Future<void> getRequest() async {
    try{
      Map<String, dynamic> response = await Api.get(method: 'product', isAuth: true, testMode: true);
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }

```

Чтобы отключить тестовый режиме во всем проекте, вы можете использовать ***disableAllTestMode***:

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
## Ссылка на хранилище данных сервера

Часто необходимо получать различные данные с хранилища сервера, например изображения, однако базовая ссылка и ссылка на хранилище иногда не совпадают или приходится каждый раз прописывать url вручную. 

Чтобы задать ссылку на хранилище ее необходимо указать в инициализации:

```dart
void main() async {
  await Api.init(baseUrl: 'https://example.com/', storageUrl: 'https://example.com/storage/');
  runApp(MyApp());
}
```
Пример использования:

```dart
Image.network(Api.dataFromStorage('image.png'));
```

## Расшифровка UTF-8

Существует встроенная поддержка декодирования в ответ на utf-8

```dart
void main() async {
  await Api.init(
    baseUrl: 'https://example.com/', 
    ebableUtf8Decoding: true,
  );
  runApp(MyApp());
}
```
