import 'package:read/read.dart';
import 'package:read/models/read_model.dart';

List reads = [];

class ReadsController extends ResourceController {
  ReadsController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> getAllReads() async {
    final readQuery = Query<Read>(context);
    return Response.ok(await readQuery.fetch());
  }

  @Operation.get('id')
  Future<Response> getRead(@Bind.path('id') int id) async {
    final readQuery = Query<Read>(context)
      ..where((read) => read.id).equalTo(id);
    final read = await readQuery.fetchOne();

    if (read == null) {
      return Response.notFound(body: 'The item was not found');
    }

    return Response.ok(read);
  }

  @Operation.post()
  Future<Response> creatNewRead(@Bind.body() Read body) async {
    final readQuery = Query<Read>(context)..values = body;
    final insertRead = await readQuery.insert();

    return Response.ok(insertRead);
  }

  @Operation.put('id')
  Future<Response> updatedRead(
    @Bind.path('id') int id,
    @Bind.body() Read body,
  ) async {
    final readQuery = Query<Read>(context)
      ..values = body
      ..where((read) => read.id).equalTo(id);

    final updateQuery = await readQuery.updateOne();
    if (updateQuery == null) {
      return Response.notFound(body: 'Item was not found');
    }
    return Response.ok('Updated read');
  }

  @Operation.delete('id')
  Future<Response> deletedRead(@Bind.path('id') int id) async {
    final readQuery = Query<Read>(context)
      ..where((read) => read.id).equalTo(id);

    final deletedCount = await readQuery.delete();

    if (deletedCount == 0) {
      return Response.notFound(body: 'Item was not found');
    }
    return Response.ok('Deleted $deletedCount items');
  }
}
