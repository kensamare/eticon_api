<img src="https://user-images.githubusercontent.com/36012868/130392291-52b82b9b-fd52-424b-ba5a-b7630e9cf343.png" data-canonical-src="https://user-images.githubusercontent.com/36012868/130392291-52b82b9b-fd52-424b-ba5a-b7630e9cf343.png" height="200" width=400/>

[![English](https://img.shields.io/badge/Language-English-blue?style=plastic)](https://github.com/kensamare/eticon_api#readme)

# ETICON API

Библиотека для работы с http-запросами.

## Использование

### Инициализация

Для начала необходимо провести инициализацию:

```dart
void main(){
  Api.init(baseUrl: 'https://example.com/');
  runApp(MyApp());
}
```

### Методы

| | | | |
|-|-|-|-|
|__Поля__|__Тип запроса__|__Значение__|
| isAuth | Все | При значении ***true*** запрос будет авторизированным|

#### GET

```dart
Future<void> getRequest() async {
    try{
      Map<String, dynamic> response = await Api.get(method: 'product',);
    } on APIException catch(error){
      print('ERROR CODE: ${error.code}');
    }
  }
```

### Заголовки

Для объявления заголовков необходимо использовать метод:

```dart
  Api.setHeaders({"Content-type": 'application/json'});
```

> Если заголовки не установлены, то по умолчанию используется заголовок ***Content-type*** : ***application/json***

Обратите внимание!!! что заголовок ***Authorization** добавляется автоматически при авторизированном запросе.
