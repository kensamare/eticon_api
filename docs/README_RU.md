<img src="https://user-images.githubusercontent.com/36012868/130392291-52b82b9b-fd52-424b-ba5a-b7630e9cf343.png" data-canonical-src="https://user-images.githubusercontent.com/36012868/130392291-52b82b9b-fd52-424b-ba5a-b7630e9cf343.png" height="200" width=400/>

[![English](https://img.shields.io/badge/Language-English-blue?style=plastic)](https://github.com/kensamare/eticon_api#readme)

# ETICON API

Библиотека для работы с http-запросами.

## Инициализация

Для начала необходимо провести инициализацию:

```dart
void main(){
  Api.init(baseUrl: 'https://example.com/');
  runApp(MyApp());
}
```

## Методы

| | | | |
|-|-|-|-|
|__Поля__|__Тип запроса__|__Значение__|
| isAuth | Все | При значении ***true*** запрос будет авторизированным |
| method | Все | Принимает строку, которая добавляется к ***baseURL*** |
| body | POST, PUT | Принимает тело запроса в ***Map*** |
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

## Коды состояний HTTP

Если результат кода состояния в ответе будет не равен 200, тогда сработает **APIException**. Он содержит в себе код состояния, а также тело ответа.
В случае, если же будут проблемы с Интеренет соединенем, **APIException** вернет код 0, при отсутсвие Интернета. Код 1, при других ошибках соединения.

## Заголовки

Для объявления заголовков необходимо использовать метод:

```dart
  Api.setHeaders({"Content-type": 'application/json'});
```

> Если заголовки не установлены, то по умолчанию используется заголовок ***Content-type*** : ***application/json***

Обратите внимание!!! что заголовок ***Authorization** добавляется автоматически при авторизированном запросе.

## Авторизация

Для авторизированных запросов необходимо установить значение токена. Установленное значение будет записано в память устройства.

```dart
  await Api.setToken('{your_token}');
```

Получить токен:

```dart
  Api.token;
```

При старте приложения, вы можете выгрузить токен записанный в памяти устройства:

```dart
void main() async {
  bool tokenLoaded = await Api.loadTokenFromMemory();
  if(tokenLoaded){
    print(Api.token);
  }
  runApp(MyApp());
}
```
Если вы не используете в токене тип ***Bearer***, то отключите его:

```dart
void main() async {
  Api.init(baseUrl: 'https://example.com/', bearerToken: false);
  runApp(MyApp());
}
```

## Test Mode

Режим тестирования - это удобный инструмент для разработки приложения, который показывает полную информацию о запросе (параметры, полный URL-адрес, тело ответа и т. д.). Кроме того, эта функция отключает все обработчики ошибок. Тестовый режим можно установить как глобально для всех запросов в проекте:

```dart
void main() async {
  Api.init(baseUrl: 'https://example.com/', globalTestMode: true);
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
  Api.init(
    baseUrl: 'https://example.com/', 
    globalTestMode: true, // Will be ignored
    disableAllTestMode: true,
  );
  runApp(MyApp());
}
```

## Расшифровка UTF-8

Существует встроенная поддержка декодирования в ответ на utf-8

```dart
void main() async {
  Api.init(
    baseUrl: 'https://example.com/', 
    ebableUtf8Decoding: true,
  );
  runApp(MyApp());
}
```
