import 'dart:collection';

import 'dart:io';

void main() {
  print('write card number:');
  var cardNumber = stdin.readLineSync();
  final _cardNumber = cardNumber?.replaceAll(RegExp(r'[\D\s+]'), '').substring(0, 16);
  final maskedNumbers = _cardNumber?.split('');
  final integers = maskedNumbers?.map((e) => int.parse(e)).toList() ?? [];

  ///get chunks implemented by iterable
  final chunks = partition<String>(maskedNumbers ?? [], 4);
  //another way to get chunks
  final _chunks = <List<String>?>[];
  for (var i = 0; i < (maskedNumbers?.length ?? 0); i += 4) {
    _chunks.add(maskedNumbers?.sublist(i, i + 4));
  }
  final maskedCardNumber = chunks.map((e) => e.join('')).join(' ');
  for (var i = integers.length - 2; i >= 0; i -= 2) {
    final value = integers[i] * 2;
    if (value > 9) {
      integers[i] = value - 9;
    } else {
      integers[i] = value;
    }
  }
  final sum = integers.fold<int>(0, (previousValue, element) => previousValue + element);
  final check = sum % 10;
  if (check == 0) {
    print('card number: $maskedCardNumber is OK');
  } else {
    print('incorrect card number: $maskedCardNumber');
  }
}

Iterable<List<T>> partition<T>(Iterable<T> iterable, int size) {
  return iterable.isEmpty ? [] : Partition<T>(iterable, size);
}

class Partition<T> extends IterableBase<List<T>> {
  final Iterable<T> _iterable;
  final int size;

  Partition(this._iterable, this.size);
  @override
  Iterator<List<T>> get iterator => _Iterator(_iterable.iterator, size);
}

class _Iterator<T> implements Iterator<List<T>> {
  final Iterator<T> _iterator;

  final int size;
  List<T>? _current;

  _Iterator(this._iterator, this.size);
  @override
  List<T> get current => _current as List<T>;

  @override
  bool moveNext() {
    var newValue = <T>[];
    var count = 0;
    while (count < size && _iterator.moveNext()) {
      newValue.add(_iterator.current);
      count++;
    }
    _current = (count > 0) ? newValue : null;

    return _current != null;
  }
}
