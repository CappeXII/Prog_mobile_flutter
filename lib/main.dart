import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_sit/database.dart';
import 'package:just_sit/viewmodels.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.brown,
      ),
      home: const MyHomePage(title: 'JustSit'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    bool _login = true;
    TextEditingController usernameLoginController = TextEditingController();
    TextEditingController passwordLoginController = TextEditingController();
    TextEditingController usernameInsertController = TextEditingController();
    TextEditingController passwordInsertController = TextEditingController();
    TextEditingController nomeInsertController = TextEditingController();
    TextEditingController cognomeInsertController = TextEditingController();
    TextEditingController emailInsertController = TextEditingController();
    TextEditingController telefonoInsertController = TextEditingController();
    TextEditingController passwordConfermaInsertController = TextEditingController();
    SnackBar erroreLogin = const SnackBar(content: Text('Errore nel login'));
    SnackBar errorePassword = const SnackBar(content: Text('Password mismatch'));
    GestoreUtente controller = GestoreUtente();





  @override
  Widget build(BuildContext context) {
    if(_login){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(onPressed: (){setState((){_login=true;});}, child: const Text('LOGIN')),
                ElevatedButton(onPressed: (){setState((){_login=false;});}, child: const Text('ISCRIVITI')),
              ],
            ),
             Text(
              'Username',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextField(
              controller: usernameLoginController,
              decoration: const InputDecoration(
                hintText: 'Username'
              ),
            ),
            Text(
              'Password',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextField(
              controller: passwordLoginController,
              decoration: const InputDecoration(
                hintText: 'Password'
              ),
            ),
            ElevatedButton(onPressed: () async {
              var controllore = GestoreUtente();
              if( await controllore.login(usernameLoginController.text, passwordLoginController.text)){
                  Navigator.of(context).push(MaterialPageRoute(builder:(context)=> HomePage(user: usernameLoginController.text)));
              }
              else{
                  ScaffoldMessenger.of(context).showSnackBar(erroreLogin);
              }
            }, child:const Text('LOGIN'))
          ],
        ),
      ),
    );}
    else{
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(onPressed: (){setState((){_login=true;});}, child: const Text('LOGIN')),
                  ElevatedButton(onPressed: (){setState((){_login=false;});}, child: const Text('ISCRIVITI')),
                ],
              ),
              TextField(controller:usernameInsertController , decoration: const InputDecoration(hintText: 'Username'),),
              TextField(controller:nomeInsertController , decoration: const InputDecoration(hintText: 'Nome'),),
              TextField(controller:cognomeInsertController , decoration: const InputDecoration(hintText: 'Cognome'),),
              TextField(controller:emailInsertController , decoration: const InputDecoration(hintText: 'Email'),),
              TextField(controller:telefonoInsertController , decoration: const InputDecoration(hintText: 'Telefono'),),
              TextField(controller:passwordInsertController , decoration: const InputDecoration(hintText: 'Password'),),
              TextField(controller:passwordConfermaInsertController, decoration: const InputDecoration(hintText: 'Conferma password'),),
              ElevatedButton(onPressed: () async{
                if(passwordConfermaInsertController.text != passwordInsertController.text){
                  ScaffoldMessenger.of(context).showSnackBar(errorePassword);
                }else {
                  await controller.insert(Utenti(
                      username: usernameInsertController.text,
                      password: passwordInsertController.text,
                      nome: nomeInsertController.text,
                      cognome: cognomeInsertController.text,
                      email: emailInsertController.text,
                      telefono: telefonoInsertController.text));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          HomePage(user: usernameLoginController.text)));
                  }
                }, child: const Text('REGISTRATI')),
            ],
          ),
        ),
      );}


  }
  }

  class HomePage extends StatefulWidget{
    const HomePage({Key? key, required this.user}) : super(key: key);
    final String user;

    @override
    State<HomePage> createState() => _HomePageState();

  }

  class _HomePageState extends State<HomePage>{
    TextEditingController dateCtl = TextEditingController();
    TextEditingController orarioInizioCtl = TextEditingController();
    TextEditingController orarioFineCtl = TextEditingController();
    TextEditingController cittaCtl = TextEditingController();
    TextEditingController personeCtl = TextEditingController();
    TextEditingController tipologiaCtl = TextEditingController();
    DateTime? date;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(onPressed: (){},child: const Icon(Icons.more_vert),),
        title:const Text('JustSit'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              TextFormField(
                readOnly: true,
                controller: dateCtl,
                onTap: ()async {
                  date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(const Duration(days: 2)), lastDate: DateTime.now().add(const Duration(days: 2)));
                  if(date == null){
                    date == DateTime.now();
                  }else{
                    dateCtl.text = (date!).millisecondsSinceEpoch.toString() ;
                  }
                }
              ),
              Row(
                children: [
                  const Text('Dalle'),
                  TextFormField(
                    readOnly: true,
                    controller: orarioInizioCtl,
                    onTap:() async {
                      TimeOfDay? orarioInizio = await showTimePicker(context: context,
                          initialTime: const TimeOfDay(hour: 18, minute: 0));
                      if(orarioInizio != null){
                        orarioInizioCtl.text = DateTime(0, 0, 0, orarioInizio.hour, orarioInizio.minute).millisecondsSinceEpoch.toString();
                      }
                    }


                   ),
                  const Text('Alle'),
                  TextFormField(
                      readOnly: true,
                      controller: orarioFineCtl,
                      onTap:() async {
                        TimeOfDay? orarioFine = await showTimePicker(context: context,
                            initialTime: const TimeOfDay(hour: 22, minute: 0));
                        if(orarioFine != null){
                          orarioFineCtl.text = DateTime(0, 0, 0, orarioFine.hour, orarioFine.minute).millisecondsSinceEpoch.toString();
                        }
                      }


                  ),
                ],
              ),
              TextField(controller: cittaCtl, decoration: const InputDecoration(hintText: 'Città'),),
              TextField(controller: tipologiaCtl, decoration: const InputDecoration(hintText: 'Tipologia'),),
              TextField(controller: personeCtl, decoration: const InputDecoration(hintText: 'Numero persone'), keyboardType: TextInputType.number),
              ElevatedButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => RicercaPage(user: widget.user, data: dateCtl.text, orarioInizio:orarioInizioCtl.text, orarioFine:orarioFineCtl.text, npersone:personeCtl.text, citta:cittaCtl.text, tipologia: tipologiaCtl.text)));}, child: const Text('CERCA')),
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Modifica Profilo'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModificaPage(user: widget.user)));
              },
            ),
            ListTile(
              title : const Text('Gestici Prenotazioni'),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrenotazioniPage(user: widget.user)));
              }
            ),
            ListTile(
              title : const Text('Logout'),
              onTap:(){
                Navigator.pop(context);
              }
            )
          ],
        )
      ),
    );
  }

  }

  class ModificaPage extends StatefulWidget{
  const ModificaPage({Key? key, required this.user}): super(key: key);
  final String user;
  @override
  State<StatefulWidget> createState() => _ModificaPageState();
  }

  class _ModificaPageState extends State<ModificaPage>{
  var controller = GestoreUtente();
  TextEditingController passwordUpdateController = TextEditingController();
  TextEditingController passwordConfermaUpdateController = TextEditingController();
  TextEditingController nomeUpdateController = TextEditingController();
  TextEditingController cognomeUpdateController = TextEditingController();
  TextEditingController telefonoUpdateController = TextEditingController();
  TextEditingController emailUpdateController = TextEditingController();
  SnackBar errorePassword = const SnackBar(content: Text('Password mismatch'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('JustSit'),
        leading: ElevatedButton(child: const Icon(Icons.arrow_back), onPressed: (){
          Navigator.pop(context);}),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(controller:nomeUpdateController , decoration: const InputDecoration(hintText: 'Nome'),),
            TextField(controller:cognomeUpdateController , decoration: const InputDecoration(hintText: 'Cognome'),),
            TextField(controller:emailUpdateController , decoration: const InputDecoration(hintText: 'Email'),),
            TextField(controller:telefonoUpdateController , decoration: const InputDecoration(hintText: 'Telefono'),),
            TextField(controller:passwordUpdateController , decoration: const InputDecoration(hintText: 'Password'),),
            TextField(controller:passwordConfermaUpdateController, decoration: const InputDecoration(hintText: 'Conferma password'),),
            ElevatedButton(onPressed: () async{
              if(passwordConfermaUpdateController.text != passwordUpdateController.text){
                ScaffoldMessenger.of(context).showSnackBar(errorePassword);
              }else {
                await controller.updateUtente(Utenti(
                    username: widget.user,
                    password: passwordUpdateController.text,
                    nome: nomeUpdateController.text,
                    cognome: cognomeUpdateController.text,
                    email: emailUpdateController.text,
                    telefono: telefonoUpdateController.text));
                Navigator.pop(context);
              }
            }, child: const Text('Modifica')),
            ElevatedButton(onPressed: () async{
              await controller.deleteUtente(Utenti(
                  username: widget.user,
                  password: passwordUpdateController.text,
                  nome: nomeUpdateController.text,
                  cognome: cognomeUpdateController.text,
                  email: emailUpdateController.text,
                  telefono: telefonoUpdateController.text));
              SystemNavigator.pop();
            }, child: const Text('ELIMINA'))
          ],
        ),
      ),
    );}

  }
  class PrenotazioniPage extends StatefulWidget{
  const PrenotazioniPage({Key? key, required this.user}): super(key: key);
  final String user;

  @override
  State<StatefulWidget> createState() => _PrenotazioniPageState();

  }

  class _PrenotazioniPageState extends State<PrenotazioniPage>{
  var controller = GestoreUtente();
  var prenotazioniController = GestorePrenotazione();
  var ristoranteController = GestoreRistorante();
  String _type="confermate";


  Future<List<Widget>> main(String type) async{
    var utente = await controller.readUtente(widget.user);
    String nome = '${utente.cognome} ${utente.nome}';
    var output = <Widget>[];
    var  lista = <Prenotazioni>[];
    switch(type){
      case 'confermate': lista = await prenotazioniController.getPrenotazioniConfermate(widget.user);     break;
      case 'non_confermate': lista = await prenotazioniController.getPrenotazioniNonConfermate(widget.user); break;
      case 'passate': lista = await prenotazioniController.getPrenotazioniPassate(widget.user); break;


    }
    for(Prenotazioni prenotazione in lista){
      var turno = await ristoranteController.readTurno(prenotazione.turno!, prenotazione.ristorante!);
      String orarioInizio = TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(turno.orario_inizio)).toString();
      String orarioFine = TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(turno.orario_fine)).toString();
      var scaffold = Container(
          child: Column(
            children:  [
              Row(
                children: [
                Text(nome),
                Text(prenotazione.data.toString())
                ],

              ),
              Row(
                children: [
                Column(
                  children: [
                  Text('Tavolo {$prenotazione.tavolo}'),
                  Text('{$orarioInizio} - {$orarioFine}'),
                   ],
               ),
                  ElevatedButton(onPressed: () async { prenotazioniController.deletePrenotazione(prenotazione); Navigator.pop(context);}, child: const Icon(Icons.delete))

                ],
              )
              ]
      )
      );
      output.add(scaffold);

    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(future: main(_type), builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot){
      if(snapshot.connectionState==ConnectionState.done) {
        return Scaffold(
          appBar: AppBar(
            leading: ElevatedButton(child:const Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);},),
            title:const Text('JustSit'),
          ),
            body:Column(
              children: snapshot.data!,
            ),
            bottomNavigationBar: BottomNavigationBar(
            items: const<BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.check), label:"Confermate"),
              BottomNavigationBarItem(icon: Icon(Icons.alarm), label:"Non Confermate"),
              BottomNavigationBarItem(icon: Icon(Icons.hourglass_bottom), label:"Passate")
            ],
              onTap: (value){
              switch(value){
                case 0: setState((){_type='confermate';}); break;
                case 1: setState((){_type='non confermate';}); break;
                case 2: setState((){_type='passate';}); break;

              }
              },
        ),
        );
      } else {
        return const Text("Wait");
      }
    });
  }

  }

  class RicercaPage extends StatefulWidget{
  const RicercaPage({Key? key, required this.user, required this.data, required this.orarioInizio, required this.orarioFine, required this.npersone, required this.citta, required this.tipologia}): super(key: key);
  final String user;
  final String data;
  final String orarioInizio;
  final String orarioFine;
  final String tipologia;
  final String npersone;
  final String citta;
  @override
  State<StatefulWidget> createState() => _RicercaPageState();
  }

  class _RicercaPageState extends State<RicercaPage>{
  var controllore = GestoreRicerca();
  var ristoranteController = GestoreRistorante();

  Future<List<Widget>> main() async{
    List<Widget> output = <Widget>[];
    var data = int.parse(widget.data);
    var orarioInizio = int.parse(widget.orarioInizio);
    var orarioFine = int.parse(widget.orarioFine);
    var persone = int.parse(widget.npersone);
    var list = await controllore.filteredSearch(DateTime.fromMillisecondsSinceEpoch(orarioInizio), DateTime.fromMillisecondsSinceEpoch(orarioFine), DateTime.fromMillisecondsSinceEpoch(data), persone, widget.citta, widget.tipologia);
    for(Ristoranti ristorante in list){
      var indirizzo = ristorante.cap??'';
      indirizzo+=ristorante.citta;
      indirizzo+=ristorante.indirizzo;
      indirizzo+=ristorante.civico??'';
      var content = Container(
        child: Row(
          children: [
            Column(
              children: [
                Text(ristorante.nome),
                Text(indirizzo),
              ],
            ),
            ElevatedButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=> RistorantePage(user:widget.user, ristorante:ristorante.id_ristorante!, data:data, orarioInizio: orarioInizio, orarioFine:orarioFine, npersone:persone, citta: widget.citta, tipologia:widget.tipologia)));}, child: Icon(Icons.add))
          ],
        )
      );
      output.add(content);
    }
    return output;

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(future: main(), builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot){
      if(snapshot.connectionState == ConnectionState.done) {
        return Scaffold(
          appBar: AppBar(
            leading: ElevatedButton(
              child: Icon(Icons.arrow_back), onPressed: () {
              Navigator.pop(context);
            },),
            title: Text('JustSit'),
          ),
          body: Column(
            children: snapshot.data!,
          ),
        );
      }
      else{
        return Text('Wait');
      }
    });
  }

  }

  class RistorantePage extends StatefulWidget{
  const RistorantePage({Key? key, required this.user, required this.ristorante, required this.data, required this.orarioInizio, required this.orarioFine, required this.npersone, required this.citta, required this.tipologia}) : super(key: key);
  final String user;
  final int ristorante;
  final int data;
  final int orarioInizio;
  final int orarioFine;
  final int npersone;
  final String citta;
  final String tipologia;

  @override
  State<StatefulWidget> createState() => _RistorantePageState();
  }

  class _RistorantePageState extends State<RistorantePage>{
  var controllore = GestoreRistorante();
  var controlloreRicerca = GestoreRicerca();
  var controllorePrenotazione = GestorePrenotazione();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(future: main(), builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot){
      if(snapshot.connectionState == ConnectionState.done){
        return Scaffold(
          appBar: AppBar(
            leading: ElevatedButton(child:Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);}),
            title: Text('JustSit'),
          ),
          body: Column(
              children: snapshot.data!,
              )
          );
      }
      else
        return Text("Wait");
    });
  }
    Future<List<Widget>>main() async{
        var turni = await controllore.readTurni(widget.ristorante);
        var listTurni = <Widget>[];
        for(Turni turno in turni){
          var tavoli = await controlloreRicerca.tavoliFilteredSearch(DateTime.fromMillisecondsSinceEpoch(widget.orarioInizio), DateTime.fromMillisecondsSinceEpoch(widget.orarioFine), DateTime.fromMillisecondsSinceEpoch(widget.data),widget.npersone, widget.citta, widget.tipologia, widget.ristorante, turno.turno!);
          List<Widget> tavoliWidget = <Widget>[];
          tavoliWidget.add(Text('Turno ${turno.turno}'));
          for(Tavoli tavolo in tavoli){
            var tavoliContainer = Row(
              children: [
                Column(
                  children: [
                    Text('Tavolo ${tavolo.tavolo}'),
                    Text('Numero posti: ${tavolo.n_persone}')
                  ],
                ),
                ElevatedButton(onPressed: (){
                  controllorePrenotazione.insertPrenotazione(Prenotazioni(cliente: widget.user, tavolo: tavolo.tavolo, turno:turno.turno, ristorante: turno.ristorante, confermato:false, data:widget.data));
                  Navigator.pop(context);
                }, child: Icon(Icons.add))
              ],
            );
            tavoliWidget.add(tavoliContainer);
          }
          listTurni.add(Column(children: tavoliWidget));

        }
        var output =<Widget>[];
        var ristorante = await controllore.readRistorante(widget.ristorante);
        var indirizzo = ristorante.cap??'';
        indirizzo+=ristorante.citta;
        indirizzo+=ristorante.indirizzo;
        indirizzo+=ristorante.civico??'';
        output.add(Column(children: [
          Text(ristorante.nome),
          Text(ristorante.tipologia??''),
          Text(indirizzo),
          Text(ristorante.email??''),
          Text(ristorante.telefono??''),
        ],));
        output.add(Column(children: listTurni));
        return output;
    }
  }

