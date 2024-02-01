import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final DateTime transactionAt;
  final String transactionType;
  final String reference;
  final Currency currency;
  final double amount;
  final String senderId;
  final String receiverId;
  final String description;

  const Transaction({
    required this.id,
    required this.transactionAt,
    required this.transactionType,
    required this.reference,
    required this.currency,
    required this.amount,
    required this.senderId,
    required this.receiverId,
    required this.description
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
        id: map['id'] ?? '',
        transactionAt: map['transactionAt'] ?? '',
        transactionType: map['transactionType'] ?? '',
        reference: map['reference'] ?? '',
        currency: Currency.fromMap(map['currency']),
        amount: map['amount'] ?? '',
        senderId: map['senderId'] ?? '',
        receiverId: map['receiverId'] ?? '',
        description: map['description'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionAt': transactionAt,
      'transactionType': transactionType,
      'reference': reference,
      'currency': currency.toMap(),
      'amount': amount,
      'senderId': senderId,
      'receiverId': receiverId,
      'description': description
    };
  }

  @override
  List<Object?> get props => [id];

}

class Currency extends Equatable {
  final String name;
  final String symbol;
  final String isoCode;

  const Currency({required this.name, required this.symbol, required this.isoCode});

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
        name: map['name'] ?? '',
        symbol: map['symbol'] ?? '',
        isoCode: map['isoCode'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol': symbol,
      'isoCode': isoCode
    };
  }

  @override
  List<Object?> get props => [isoCode];
}