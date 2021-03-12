class Contact {
  final int id;
  final String name;
  final int accountNumber;

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        accountNumber = json['accountNumber'];

  Contact(this.id, this.name, this.accountNumber);

  @override
  String toString() {
    // TODO: implement toString
    return 'Contact {id: $id name: $name acc: $accountNumber}';
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'accountNumber': accountNumber,
      };
}
