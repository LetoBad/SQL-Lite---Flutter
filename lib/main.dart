import 'package:flutter/material.dart';
import 'package:sqlite/PessoaDAO.dart';
import 'package:sqlite/pessoa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SQLite CRUD",
      home: Pagina1(),
    );
  }
}

class Pagina1 extends StatefulWidget {
  const Pagina1({super.key});

  @override
  State<Pagina1> createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> {
  final Pessoadao _pessoadao = Pessoadao();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _creditcardController = TextEditingController();

  List<Pessoa> _listaPessoas = [];
  Pessoa? _pessoaAtual;

  void _salvitar()async{
    if(_pessoaAtual == null){
      //insert
      await _pessoadao.insertPessoa(Pessoa(nome: _nomeController.text, cpf:_cpfController.text , creditCard: _creditcardController.text));
    }else{
      //atualizar
      _pessoaAtual!.nome = _nomeController.text;
      _pessoaAtual!.cpf = _cpfController.text;
      _pessoaAtual!.creditCard = _creditcardController.text;
      
  await _pessoadao.updatePessoa(_pessoaAtual!);

    }
    _nomeController.clear();
    _cpfController.clear();
    _creditcardController.clear();
    setState(() {
      _pessoaAtual = null;
    });
    _loadPessoas();
  }

  @override
  void initState() {
    super.initState();
    _loadPessoas();
  }

  void _editarPessoa(Pessoa pessoa){
    _pessoaAtual = pessoa;
    _nomeController.text = pessoa.nome;
    _cpfController.text = pessoa.cpf;
    _creditcardController.text = pessoa.creditCard;
  }

  void _deletePessoa(int index) async {
    await _pessoadao.DeletePessoa(
        Pessoa(id: index, nome: '', cpf: '', creditCard: ''));
    _loadPessoas();
  }

  void _loadPessoas() async {
    List<Pessoa> listaTemp = await _pessoadao.selectPessoas();
    setState(() {
      _listaPessoas = listaTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CLIENTES DO BODEGON'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
            Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _cpfController,
              decoration: const InputDecoration(labelText: 'CPF'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _creditcardController,
              decoration:const InputDecoration(labelText: 'Credit Card'),
            ),
          ),
          ElevatedButton(
            onPressed: _salvitar,
            child: Text(_pessoaAtual == null ? 'Salvar' : 'Atualizar'),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _listaPessoas.length,
                itemBuilder: (context, index) {
                  final Pessoa pessoa = _listaPessoas[index];
                  return ListTile(
                    title: Text('Nome: ${pessoa.nome} - Cpf: ${pessoa.cpf}'),
                    trailing: IconButton(
                      onPressed: () {
                        _deletePessoa(pessoa.id!);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    onTap: () {
                      _editarPessoa(pessoa);
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
