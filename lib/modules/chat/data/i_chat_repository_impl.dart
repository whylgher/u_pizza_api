import 'package:cuidapet_api/entities/chat.dart';
import 'package:cuidapet_api/exceptions/database_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

import './i_chat_repository.dart';
import '../../../application/database/i_database_connection.dart';
import '../../../application/logger/i_logger.dart';
import '../../../entities/device_token.dart';
import '../../../entities/supplier.dart';

@LazySingleton(as: IChatRepository)
class IChatRepositoryImpl implements IChatRepository {
  final IDatabaseConnection connection;
  final ILogger log;

  IChatRepositoryImpl({
    required this.connection,
    required this.log,
  });

  @override
  Future<int> startChat(int scheduleId) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
          INSERT INTO chats(agendamento_id, status, data_criacao)
          VALUES (?, ?, ?)
        ''', [
        scheduleId,
        'A',
        DateTime.now().toIso8601String(),
      ]);

      return result.insertId!;
    } on MySqlException catch (e, s) {
      log.error('Eroo ao iniciar chat', e, s);

      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<Chat?> findChatById(int chatId) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final query = '''
          SELECT 
            c.id, c.data_criacao , c.status ,
            a.nome  AS agendamento_nome, a.nome_pet  AS agendamento_nome_pet,
            a.fornecedor_id, f.nome AS fornec_nome, f.logo , a.usuario_id ,
            u.android_token AS user_android_token, u.ios_token AS user_ios_token,
            uf.android_token AS fornec_android_toke, uf.ios_token AS fornec_ios_token
          FROM chats AS c
          INNER JOIN agendamento a ON a.id = c.agendamento_id
          INNER JOIN fornecedor f ON f.id = a.fornecedor_id
          -- Dados do usuário Cliente do petshop
          INNER JOIN usuario u ON u.id = a.usuario_id
          -- Dados do usuario fornecedor (PETSHOP)
          INNER JOIN usuario uf ON uf.fornecedor_id = f.id
          WHERE c.id = 1;
        ''';

      final result = await conn.query(query, [chatId]);

      if (result.isNotEmpty) {
        final resultMysql = result.first;
        return Chat(
          id: resultMysql['id'],
          status: resultMysql['status'],
          name: resultMysql['agendamento_nome'],
          petName: resultMysql['agendamento_nome_pet'],
          supplier: Supplier(
            id: resultMysql['fornecedor_id'],
            name: resultMysql['fornec_nome'],
          ),
          user: resultMysql['usuario_id'],
          userDeviceToken: DeviceToken(
            android: (resultMysql['user_android_token'] as Blob?).toString(),
            ios: (resultMysql['user_ios_token'] as Blob?).toString(),
          ),
          supplierDeviceToken: DeviceToken(
            android:
                (resultMysql['fornec_user_android_token'] as Blob?).toString(),
            ios: (resultMysql['fornec_user_ios_token'] as Blob?).toString(),
          ),
        );
      } else {
        throw Response.internalServerError();
      }
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar dados do chat', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}




//  MySqlConnection? conn;

//     try {
//       conn = await connection.openConnection();
//     } on MySqlException catch (e, s) {
//       log.error('message', e, s);
//       throw DatabaseException();
//     } finally {
//       await conn?.close();
//     }
//   }
