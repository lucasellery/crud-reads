import 'package:read/models/read_model.dart';

import 'harness/app.dart';

void main() {
  final harness = Harness()..install();

  setUp(() async {
    final readQuery = Query<Read>(harness.application.channel.context)
      ..values.title = 'Harry Potter e o cálice de fogo'
      ..values.author = 'JK Rowling'
      ..values.year = 2004;
    await readQuery.insert();
  });

  test('GET /reads returns a 200 OK', () async {
    final response = await harness.agent.get('/read');
    expectResponse(response, 200,
        body: everyElement(partial({
          'id': greaterThan(0),
          'title': isString,
          'author': isString,
          'year': isInteger,
          'detail': isString,
        })));
  });

  test('GET /reads/:id returns a single read', () async {
    final response = await harness.agent.get('/read/1');
    expectResponse(response, 200, body: {
      'id': 1,
      'title': 'Harry Potter e o cálice de fogo',
      'author': 'JK Rowling',
      'year': 2004,
      'detail': "Harry Potter e o cálice de fogo by JK Rowling in year 2004",
    });
  });

  // TODO: POST /read creats a new read
  test('POST /read creats a new read', () async {
    final response = await harness.agent.post('/read', body: {
      "title": "Até que nada mais importe",
      "author": "Luciano Subirá",
      "year": 2018
    });
    expectResponse(response, 200, body: {
      "id": 2,
      "title": "Até que nada mais importe",
      "author": "Luciano Subirá",
      "year": 2018,
      "detail": "Até que nada mais importe by Luciano Subirá in year 2018",
    });
  });

  // TODO: PUT /read/:id updates a read
  // test('PUT /read/:id updates a read', () async {
  //   final response = await harness.agent.put('/read/1', body: {
  //     'title': 'Harry Potter e o cálice de fogo (UPDATED)',
  //     'author': 'JK Rowling',
  //     'year': 2004,
  //   });
  //   expectResponse(response, 200, body: {
  //     'id': 1,
  //     'title': 'Harry Potter e o cálice de fogo (UPDATED)',
  //     'author': 'JK Rowling',
  //     'year': 2004,
  //     'detail': "Harry Potter e o cálice de fogo by JK Rowling in year 2004",
  //   });
  // });

  // test('DELETE read/:id deletes a read', () async {
  //   final response = await harness.agent.delete('/read/1');
  //   expectResponse(response, 200, body: 'Deleted 1 file');
  // });
  // TOdo: DELETE read/:id deletes a read
}
