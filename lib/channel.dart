import 'dart:io';
import 'package:read/controllers/read_controller.dart';
import 'read.dart';

class ReadChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = ReadConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password,
      config.database.host,
      config.database.port,
      config.database.databaseName,
    );
    /*existem 2 problema ao definir esse persistentStore
     no channel.dart:
      1. Queremos usar um banco de dados diferente quando
       estamos testando, executando localmente e em produção.
      2. Também é ruim porque teríamos que verificar nossa
       senha do banco de dados no controle de versão.
    */

    context = ManagedContext(dataModel, persistentStore);
  }

  @override
  Controller get entryPoint => Router()
    ..route(
      "read/[:id]",
    ).link(() => ReadsController(context))
    ..route('/').linkFunction((request) =>
        Response.ok('Hello, world!')..contentType = ContentType.html)

    //
    ..route(
      '/client',
    ).linkFunction((request) async {
      final client = await File('client.html').readAsString();
      return Response.ok(client)..contentType = ContentType.html;
    });
}

class ReadConfig extends Configuration {
  //ler os dados dos arquivos de configuracao
  //e nos permite declarar as propriedades esperadas que
  // estao neles
  ReadConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
