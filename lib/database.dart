import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Utenti{
  final String? username;
  final String password;
  final String nome;
  final String cognome;
  final String? email;
  final String? telefono;

  Utenti({this.username, required this.password, required this.nome, required this.cognome, this.email, this.telefono});

  factory Utenti.fromMap(Map<String, dynamic> json)=> new Utenti(
    username: json['username'],
    password: json['password'],
    nome: json['nome'],
    cognome: json['cognome'],
    email: json['email'],
    telefono: json['telefono'],
  );
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'nome': nome,
      'cognome': cognome,
      'email': email,
      'telefono': telefono,
    };
  }
}

class Ristoranti{
  final int? id_ristorante;
  final String username;
  final String password;
  final String nome;
  final String? descrizione;
  final String? menu;
  final String? cap;
  final String citta;
  final String indirizzo;
  final String? civico;
  final String? email;
  final String? telefono;
  final String? tipologia;

  Ristoranti({this.id_ristorante, required this.username, required this.password, required this.nome, this.descrizione, this.menu, this.cap, required this.citta, required this.indirizzo, this.civico, this.email, this.telefono, this.tipologia});

  factory Ristoranti.fromMap(Map<String, dynamic> json)=> new Ristoranti(
    id_ristorante: json['id_ristorante'],
    username: json['username'],
    password: json['password'],
    nome: json['nome'],
    descrizione: json['descrizione'],
    menu: json['menu'],
    cap: json['cap'],
    citta: json['citta'],
    indirizzo: json['indirizzo'],
    civico: json['civico'],
    email: json['email'],
    telefono: json['telefono'],
    tipologia: json['tipologia'],
  );

  Map<String, dynamic> toMap(){
    return{
      'id_ristorante' : id_ristorante,
      'username' : username,
      'password' : password,
      'nome' : nome,
      'descrizione' : descrizione,
      'menu' : menu,
      'descrizione' : descrizione,
      'cap' : cap,
      'citta' : citta,
      'indirizzo' : indirizzo,
      'civico' : civico,
      'email' : email,
      'telefono' : telefono,
      'tipologia' : tipologia,
    };
  }
}

class Turni{
  final int? turno;
  final int ristorante;
  final int orario_inizio;
  final int orario_fine;

  Turni({this.turno, required this.ristorante, required this.orario_inizio, required this.orario_fine});

  factory Turni.fromMap(Map<String, dynamic> json) => new Turni(
    turno: json['turno'],
    ristorante: json['ristorante'],
    orario_inizio : json['orario_inizio'],
    orario_fine: json['orario_fine'],
  );

  Map<String, dynamic> toMap(){
    return{
      'turno' : turno,
      'ristorante' : ristorante,
      'orario_inizio' : orario_inizio,
      'orario_fine' : orario_fine,
    };
  }
}

class Tavoli{
  final int? tavolo;
  final int ristorante;
  final int n_persone;

  Tavoli({this.tavolo, required this.ristorante, required this.n_persone});

  factory Tavoli.fromMap(Map<String, dynamic> json) => new Tavoli(
    tavolo: json['tavolo'],
    ristorante: json['ristorante'],
    n_persone: json['n_persone'],
  );

  Map<String, dynamic> toMap(){
    return{
      'tavolo': tavolo,
      'ristorante': ristorante,
      'n_persone': n_persone,
    };
  }
}
class Prenotazioni{
  final String? cliente;
  final int? tavolo;
  final int? turno;
  final int? ristorante;
  final bool confermato;
  final int data;

  Prenotazioni({this.cliente, this.tavolo, this.turno, this.ristorante, required this.confermato, required this.data});

  factory Prenotazioni.fromMap(Map<String, dynamic> json) => new Prenotazioni(
    cliente: json['cliente'],
    tavolo: json['tavolo'],
    turno: json['turno'],
    ristorante: json['ristorante'],
    confermato: json['confermato'],
    data: json['data'],
  );

  Map<String, dynamic> toMap(){
    return{
      'cliente':cliente,
      'tavolo':tavolo,
      'turno':turno,
      'ristorante':ristorante,
      'confermato':confermato,
      'data':data,
    };
  }

}

class DatabaseHelper{

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'justsit.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE utenti(
      username TEXT PRIMARY KEY,
      password TEXT NOT NULL,
      nome TEXT NOT NULL,
      cognome TEXT NOT NULL,
      email TEXT,
      telefono TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE ristoranti(
      id_ristorante INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      nome TEXT NOT NULL,
      descrizione TEXT,
      menu TEXT,
      cap TEXT,
      citta TEXT,
      indirizzo TEXT,
      civico TEXT,
      email TEXT,
      telefono TEXT,
      tipologia TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE tavoli(
      tavolo INTEGER AUTOINCREMENT, 
      ristorante INTEGER,
      n_persone INTEGER NOT NULL,
      PRIMARY KEY (tavolo, ristorante)
    ''');
    await db.execute('''
      CREATE TABLE turni(
      turno INTEGER AUTOINCREMENT,
      ristorante INTEGER,
      orario_inizio INTEGER,
      orario_fine INTEGER,
      PRIMARY KEY(turno, ristorante)
      )
    ''');
    await db.execute('''
      CREATE TABLE prenotazioni(
      cliente TEXT ,
      tavolo INTEGER,
      turno INTEGER,
      ristorante INTEGER, 
      confermato INTEGER,
      data INTEGER,
      PRIMARY KEY(cliente, tavolo, turno, ristorante)
      )
    ''');
  }

}

