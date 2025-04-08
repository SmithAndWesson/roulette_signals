class UserCredentials {
  final String email;
  final String password;

  UserCredentials({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'user': {
          'email': email,
          'password': password,
        },
        'application': {
          'type': 'desktop',
          'id': null,
        },
      };
}

class AuthResponse {
  final String jwtToken;
  final String evoSessionId;

  AuthResponse({
    required this.jwtToken,
    required this.evoSessionId,
  });
}

class RouletteNumber {
  final int number;
  final DateTime timestamp;

  RouletteNumber({
    required this.number,
    required this.timestamp,
  });

  int get dozen {
    if (number >= 1 && number <= 12) return 1;
    if (number >= 13 && number <= 24) return 2;
    if (number >= 25 && number <= 36) return 3;
    return 0; // Для 0
  }

  int get column {
    if (number == 0) return 0;
    return (number - 1) % 3 + 1;
  }
}

class Signal {
  final String type; // 'dozen' или 'column'
  final int number; // номер дюжины/колонки
  final int missingRounds;
  final List<int> lastNumbers;

  Signal({
    required this.type,
    required this.number,
    required this.missingRounds,
    required this.lastNumbers,
  });

  String get message {
    final typeName = type == 'dozen' ? 'дюжина' : 'колонка';
    final numbers = lastNumbers.join(', ');
    return '🎰 Сигнал рулетки! $number-я $typeName не выпадала $missingRounds раз. Последние числа: $numbers';
  }
}
