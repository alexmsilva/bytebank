class Contact {
  final String name;
  final int accountNumber;

  Contact(this.name, this.accountNumber);

  Contact.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        accountNumber = json['accountNumber'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'accountNumber': accountNumber,
      };

  @override
  String toString() {
    return 'Contact {name: $name, accountNumber: $accountNumber}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          accountNumber == other.accountNumber;

  @override
  int get hashCode => name.hashCode ^ accountNumber.hashCode;
}
