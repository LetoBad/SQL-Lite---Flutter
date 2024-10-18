
class Pessoa{
  int? id;
  String nome;
  String cpf;
  String creditCard;

  Pessoa({
    this.id,
    required this.nome,
    required this.cpf,
    required this.creditCard,
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'creditCard': creditCard,
    };
  }

  factory Pessoa.fromMap(Map<String, dynamic> map){
    return Pessoa(nome: map['nome'], 
    id: map['id'],
    cpf: map['cpf'], 
    creditCard: map['creditcard'],);
  }
}