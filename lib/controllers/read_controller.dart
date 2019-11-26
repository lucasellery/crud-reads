import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

import 'package:read/read.dart';

List reads = [
  {
    'title': 'Sou nós',
    'author': 'Douglas Gonçalves',
    'year': '2019',
  },
  {
    'title:': 'Quem é Jesus',
    'author': 'Alessandro Vilas Boas',
    'year': '2019',
  },
  {
    'title': 'Confissões',
    'author': 'Agostinho de Hipona',
    'year': '398',
  },
];

class ReadsController extends ResourceController {
  @Operation.get()
  Future<Response> getAllReads() async {
    return Response.ok(reads);
  }

  @Operation.get('id')
  Future<Response> getRead(@Bind.path('id') int id) async {
    if (id < 0 || id > reads.length - 1) {
      return Response.notFound(body: 'The item was not found');
    }

    return Response.ok(reads[id]);
  }

  @Operation.post()
  Future<Response> creatNewRead() async {
    final Map<String, dynamic> body = request.body.as();
    reads.add(body); // mudanca aqui
    return Response.ok(body);
  }

  @Operation.put('id')
  Future<Response> updatedRead(@Bind.path('id') int id) async {
    if (id < 0 || id > reads.length - 1) {
      return Response.notFound(body: 'Item was not found');
    }

    final Map<String, dynamic> body = request.body.as();
    reads[id] = body;

    return Response.ok('Updated read');
  }

  @Operation.delete('id')
  Future<Response> deletedRead(@Bind.path('id') int id) async {
    if (id < 0 || id > reads.length - 1) {
      return Response.notFound(body: 'Item was not found');
    }
    reads.removeAt(id);
    return Response.ok('Deleted read');
  }
}
