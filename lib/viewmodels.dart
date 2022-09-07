import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

class GestoreUtente {
  Future<int> insert(Utenti utente) async{
    Database db = await DatabaseHelper.instance.database;
    return db.insert('utenti', utente.toMap());
  }
  Future<bool> login(String username, String password) async{
    Database db = await DatabaseHelper.instance.database;
    var utenti = await db.query('utenti');
    List<Utenti> utenteList = utenti.isNotEmpty
        ? utenti.map((c) => Utenti.fromMap(c)).toList()
        : [];
    for(Utenti utente in utenteList){
      if(username == utente.username && password == utente.password) {
        return true;
      }
    }
    return false;
  }
  Future<Utenti> readUtente(String username) async {
    Database db = await DatabaseHelper.instance.database;
    var utente = await db.rawQuery('SELECT * FROM utenti WHERE username=?', [username]);
    List<Utenti> listUtenti = utente.isNotEmpty ? utente.map((c)=>Utenti.fromMap(c)).toList() : [];
    return listUtenti.first;
  }
  Future<int> updateUtente(Utenti utente) async {
    Database db = await DatabaseHelper.instance.database;
    var update = await db.update('utenti', utente.toMap(), where: 'username=?', whereArgs: [utente.username]);
    return update;
  }
  Future<int> deleteUtente(Utenti utente) async{
    Database db = await DatabaseHelper.instance.database;
    var delete = await db.delete('utenti', where:'username=?', whereArgs: [utente.username]);
    return delete;
  }



}

class GestoreRistorante{
  Future<int> insertRistorante(Ristoranti ristorante) async{
    Database db =  await DatabaseHelper.instance.database;
    var insert = await db.insert('ristoranti', ristorante.toMap());
    return insert;
  }

  Future<int> insertTurno(Turni turno) async{
    Database db =  await DatabaseHelper.instance.database;
    var insert = await db.insert('turni', turno.toMap());
    return insert;
  }
  Future<int> insertTavolo(Tavoli tavolo) async {
    Database db = await DatabaseHelper.instance.database;
    var insert = await db.insert('tavoli', tavolo.toMap());
    return insert;
  }
  Future<Ristoranti> readRistorante(int id) async{
    Database db =  await DatabaseHelper.instance.database;
    var query = await db.query('tavoli', where: 'id_ristorante=?', whereArgs: [id]);
    List<Ristoranti> listRistoranti = query.isNotEmpty ? query.map((c)=>Ristoranti.fromMap(c)).toList() : [];
    return listRistoranti.first;
  }
  Future<List<Turni>> readTurni(int id) async{
    Database db =  await DatabaseHelper.instance.database;
    var query = await db.query('turni', where: 'ristorante=?', whereArgs: [id]);
    List<Turni> listTurni = query.isNotEmpty ? query.map((c)=>Turni.fromMap(c)).toList() : [];
    return listTurni;
  }
  Future<List<Tavoli>> readTavoli(int id) async{
    Database db =  await DatabaseHelper.instance.database;
    var query = await db.query('tavoli', where: 'ristorante=?', whereArgs: [id]);
    List<Tavoli> listTavoli = query.isNotEmpty? query.map((c) => Tavoli.fromMap(c)).toList() : [];
    return listTavoli;
  }
  Future<Turni> readTurno(int turno, int ristorante) async{
    Database db = await DatabaseHelper.instance.database;
    var query = await db.query('turni', where: 'turno=? and ristorante=?', whereArgs: [turno, ristorante]);
    Turni output = query.isNotEmpty? query.map((e) => Turni.fromMap(e)).toList().first : Turni(ristorante: 0, turno: 0, orario_inizio: DateTime.now().millisecondsSinceEpoch, orario_fine: DateTime.now().millisecondsSinceEpoch);
    return output;
  }
}

class GestoreRicerca{
  Future<List<Ristoranti>> readAllRistoranti() async{
    Database db =  await DatabaseHelper.instance.database;
    var query = await db.query('ristoranti');
    List<Ristoranti> list = query.isNotEmpty ? query.map((e) => Ristoranti.fromMap(e)).toList() : [];
    return list;
  }
  Future<List<Ristoranti>> filteredSearch(DateTime orario_inizio, DateTime orario_fine, DateTime data, int npersone, String citta, String tipologia) async{
    Database db =  await DatabaseHelper.instance.database;
    var query= await db.rawQuery("SELECT *  FROM ristoranti as r WHERE exists(select r.id_ristorante, turni.turno, tavoli.tavolo from ristoranti inner join turni on ristoranti.id_ristorante=turni.ristorante inner join tavoli on ristoranti.id_ristorante=tavoli.ristorante where turni.orario_inizio<=$orario_inizio and turni.orario_fine>=$orario_fine and tavoli.npersone>=$npersone and ristoranti.citta like $citta and ristoranti.tipologia like $tipologia except select ristorante, turno, tavolo from prenotazione where data=$data)");
    List<Ristoranti> list = query.isNotEmpty ? query.map((e) => Ristoranti.fromMap(e)).toList() : [];
    return list;
  }
  Future<List<Tavoli>> tavoliFilteredSearch(DateTime orario_inizio, DateTime orario_fine, DateTime data, int npersone, String citta, String tipologia, int ristorante, int turno ) async{
    Database db = await DatabaseHelper.instance.database;
    var query = await db.rawQuery("SELECT *  FROM tavoli as t WHERE exists(select ristoranti.id_ristorante, turni.turno, tavoli.tavolo from ristoranti inner join turni on ristoranti.id_ristorante=turni.ristorante inner join tavoli on ristoranti.id_ristorante=tavoli.ristorante where t.tavoli=tavoli.tavolo and t.ristoranti=tavoli.ristorante and turni.orarioinizio<=$orario_inizio and turni.orariofine>=$orario_fine and tavoli.npersone>=$npersone and ristoranti.citta like $citta and ristorante.tipologia like $tipologia and ristoranti.id_ristorante=$ristorante  and turni.turno=$turno except select ristorante, turno, tavolo from prenotazione where data=$data)");
    List<Tavoli> list = query.isNotEmpty? query.map((e) => Tavoli.fromMap(e)).toList() : [];
    return list;
  }
}

class GestorePrenotazione{
  Future<int> insertPrenotazione(Prenotazioni prenotazione) async{
    Database db = await DatabaseHelper.instance.database;
    var query = await db.insert('prenotazioni', prenotazione.toMap());
    return query;

  }
  Future<int> deletePrenotazione(Prenotazioni prenotazione) async{
    Database db = await DatabaseHelper.instance.database;
    var query = await db.delete('prenotazioni', where: 'cliente = ? AND ristorante=? AND turno=? AND tavolo=?',whereArgs: [prenotazione.cliente, prenotazione.ristorante, prenotazione.turno, prenotazione.tavolo]);
    return query;

  }
  Future<List<Prenotazioni>> getPrenotazioniConfermate(String username) async{
    Database db = await DatabaseHelper.instance.database;
    int now = DateTime.now().millisecondsSinceEpoch;
    var query = await db.rawQuery("SELECT * FROM prenotazioni WHERE cliente=$username AND confermato=1 AND data>=$now");
    List<Prenotazioni> list = query.isNotEmpty? query.map((e) => Prenotazioni.fromMap(e)).toList() : [];
    return list;
  }
  Future<List<Prenotazioni>> getPrenotazioniNonConfermate(String username) async{
    Database db = await DatabaseHelper.instance.database;
    int now = DateTime.now().millisecondsSinceEpoch;
    var query = await db.rawQuery("SELECT * FROM prenotazioni WHERE cliente=$username AND confermato=0 AND data>=$now");
    List<Prenotazioni> list = query.isNotEmpty? query.map((e) => Prenotazioni.fromMap(e)).toList() : [];
    return list;

  }
  Future<List<Prenotazioni>> getPrenotazioniPassate(String username) async{
    Database db = await DatabaseHelper.instance.database;
    int now = DateTime.now().millisecondsSinceEpoch;
    var query = await db.rawQuery("SELECT * FROM prenotazioni WHERE cliente=$username AND data<$now");
    List<Prenotazioni> list = query.isNotEmpty? query.map((e) => Prenotazioni.fromMap(e)).toList() : [];
    return list;

  }
}

