<img src="https://user-images.githubusercontent.com/36012868/130392291-52b82b9b-fd52-424b-ba5a-b7630e9cf343.png" data-canonical-src="https://user-images.githubusercontent.com/36012868/130392291-52b82b9b-fd52-424b-ba5a-b7630e9cf343.png" height="200" width=400/>

[![English](https://img.shields.io/badge/Language-English-blue?style=plastic)](https://github.com/kensamare/eticon_api#readme)

# ETICON API

Библиотека для работы с http-запросами.

## Инициализация

Для начала необходимо провести инициализацию:

```dart
void main() async {
  await Api.init(baseUrl: 'https://example.com/');
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
### PATCH

```dart
Future<void> patchRequest() async {
    try{
      Map<String, dynamic> response = await Api.patch(method: 'product', body: {"id": 5}, isAuth: true);
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
```

## "Cырые" методы

Все сырые методы принимают url, по которому делается запрос. В случае GET и DELETE без параметров.
Они указываются отдельно как и в методах описанных выше.

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

```dart
Future<void> request() async {
  try{
    Map<String, dynamic> response = await Api.rawPatch(url: 'https://example.com/profile', body: {"id": 5}, headers: {"Content-type": 'application/json'});
  } on APIException catch(error){
    print('ERROR CODE: ${error.code}');
  }
}
```

## Коды состояний HTTP

Если результат кода состояния в ответе будет не равен 200, тогда сработает **APIException**. Он содержит в себе код состояния, а также тело ответа.
В случае, если же будут проблемы с Интеренет соединенем, **APIException** вернет код 0.

## Заголовки

Для объявления заголовков необходимо использовать метод:

```dart
  Api.setHeaders({"Content-type": 'application/json'});
```

> Если заголовки не установлены, то по умолчанию используется заголовок ***Content-type*** : ***application/json***

Обратите внимание!!! что заголовок ***Authorization** добавляется автоматически при авторизированном запросе.

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
  Api.clearToken();
```

Также можно проверить токен на пустоту или не пустоту:

```dart
  Api.tokenIsEmpty;//return true or false
  Api.tokenIsNotEmpty;//return true or false
```

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
  Api.clearRefreshToken();
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
