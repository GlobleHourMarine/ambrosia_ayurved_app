import 'dart:io';

import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = '192.168.1.5', user = 'root', password = '', db = 'kcdb';
  static int port = 3306;

  //  Mysql();
}

Future<MySqlConnection> getConnection() async {
  var settings = ConnectionSettings(
    host: Mysql.host,
    user: Mysql.user,
    port: Mysql.port,
    password: Mysql.password,
    db: Mysql.db,
    timeout: Duration(seconds: 10),
  );

  return await MySqlConnection.connect(settings);
}

void main() async {
  print('Starting database connection...');
  print('Connecting to host: ${Mysql.host}, port: ${Mysql.port}');
  try {
    MySqlConnection conn = await getConnection();
    print('Connected to the database!');
    await conn.close();
    print('Connection closed.');
  } on MySqlException catch (e) {
    print('MySQL Error: $e');
  } on SocketException catch (e) {
    print('Socket Error: $e');
  } catch (e) {
    print('Error: $e');
  }
}
