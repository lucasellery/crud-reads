import 'dart:io';
import 'package:read/controllers/read_controller.dart';
import 'read.dart';

class ReadChannel extends ApplicationChannel {
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router
        .route(
          "read/[:id]",
        )
        .link(() => ReadsController());

    router
        .route(
          '/',
        )
        .linkFunction((request) =>
            Response.ok("Hello, world")..contentType = ContentType.html);

    router
        .route(
      '/client',
    )
        .linkFunction((request) async {
      final client = await File('client.html').readAsString();
      return Response.ok(client)..contentType = ContentType.html;
    });
    return router;
  }
}
