// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebSocketEvent _$WebSocketEventFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'connected':
      return _Connected.fromJson(json);
    case 'disconnected':
      return _Disconnected.fromJson(json);
    case 'error':
      return _Error.fromJson(json);
    case 'recentNumbers':
      return _RecentNumbers.fromJson(json);
    case 'newNumber':
      return _NewNumber.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'WebSocketEvent',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$WebSocketEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
    required TResult Function(List<RouletteNumber> numbers) recentNumbers,
    required TResult Function(RouletteNumber number) newNumber,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connected,
    TResult? Function()? disconnected,
    TResult? Function(String message)? error,
    TResult? Function(List<RouletteNumber> numbers)? recentNumbers,
    TResult? Function(RouletteNumber number)? newNumber,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    TResult Function(List<RouletteNumber> numbers)? recentNumbers,
    TResult Function(RouletteNumber number)? newNumber,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connected value) connected,
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Error value) error,
    required TResult Function(_RecentNumbers value) recentNumbers,
    required TResult Function(_NewNumber value) newNumber,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connected value)? connected,
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Error value)? error,
    TResult? Function(_RecentNumbers value)? recentNumbers,
    TResult? Function(_NewNumber value)? newNumber,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connected value)? connected,
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Error value)? error,
    TResult Function(_RecentNumbers value)? recentNumbers,
    TResult Function(_NewNumber value)? newNumber,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this WebSocketEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebSocketEventCopyWith<$Res> {
  factory $WebSocketEventCopyWith(
          WebSocketEvent value, $Res Function(WebSocketEvent) then) =
      _$WebSocketEventCopyWithImpl<$Res, WebSocketEvent>;
}

/// @nodoc
class _$WebSocketEventCopyWithImpl<$Res, $Val extends WebSocketEvent>
    implements $WebSocketEventCopyWith<$Res> {
  _$WebSocketEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ConnectedImplCopyWith<$Res> {
  factory _$$ConnectedImplCopyWith(
          _$ConnectedImpl value, $Res Function(_$ConnectedImpl) then) =
      __$$ConnectedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ConnectedImplCopyWithImpl<$Res>
    extends _$WebSocketEventCopyWithImpl<$Res, _$ConnectedImpl>
    implements _$$ConnectedImplCopyWith<$Res> {
  __$$ConnectedImplCopyWithImpl(
      _$ConnectedImpl _value, $Res Function(_$ConnectedImpl) _then)
      : super(_value, _then);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$ConnectedImpl implements _Connected {
  const _$ConnectedImpl({final String? $type}) : $type = $type ?? 'connected';

  factory _$ConnectedImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectedImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'WebSocketEvent.connected()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ConnectedImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
    required TResult Function(List<RouletteNumber> numbers) recentNumbers,
    required TResult Function(RouletteNumber number) newNumber,
  }) {
    return connected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connected,
    TResult? Function()? disconnected,
    TResult? Function(String message)? error,
    TResult? Function(List<RouletteNumber> numbers)? recentNumbers,
    TResult? Function(RouletteNumber number)? newNumber,
  }) {
    return connected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    TResult Function(List<RouletteNumber> numbers)? recentNumbers,
    TResult Function(RouletteNumber number)? newNumber,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connected value) connected,
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Error value) error,
    required TResult Function(_RecentNumbers value) recentNumbers,
    required TResult Function(_NewNumber value) newNumber,
  }) {
    return connected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connected value)? connected,
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Error value)? error,
    TResult? Function(_RecentNumbers value)? recentNumbers,
    TResult? Function(_NewNumber value)? newNumber,
  }) {
    return connected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connected value)? connected,
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Error value)? error,
    TResult Function(_RecentNumbers value)? recentNumbers,
    TResult Function(_NewNumber value)? newNumber,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectedImplToJson(
      this,
    );
  }
}

abstract class _Connected implements WebSocketEvent {
  const factory _Connected() = _$ConnectedImpl;

  factory _Connected.fromJson(Map<String, dynamic> json) =
      _$ConnectedImpl.fromJson;
}

/// @nodoc
abstract class _$$DisconnectedImplCopyWith<$Res> {
  factory _$$DisconnectedImplCopyWith(
          _$DisconnectedImpl value, $Res Function(_$DisconnectedImpl) then) =
      __$$DisconnectedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DisconnectedImplCopyWithImpl<$Res>
    extends _$WebSocketEventCopyWithImpl<$Res, _$DisconnectedImpl>
    implements _$$DisconnectedImplCopyWith<$Res> {
  __$$DisconnectedImplCopyWithImpl(
      _$DisconnectedImpl _value, $Res Function(_$DisconnectedImpl) _then)
      : super(_value, _then);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$DisconnectedImpl implements _Disconnected {
  const _$DisconnectedImpl({final String? $type})
      : $type = $type ?? 'disconnected';

  factory _$DisconnectedImpl.fromJson(Map<String, dynamic> json) =>
      _$$DisconnectedImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'WebSocketEvent.disconnected()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DisconnectedImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
    required TResult Function(List<RouletteNumber> numbers) recentNumbers,
    required TResult Function(RouletteNumber number) newNumber,
  }) {
    return disconnected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connected,
    TResult? Function()? disconnected,
    TResult? Function(String message)? error,
    TResult? Function(List<RouletteNumber> numbers)? recentNumbers,
    TResult? Function(RouletteNumber number)? newNumber,
  }) {
    return disconnected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    TResult Function(List<RouletteNumber> numbers)? recentNumbers,
    TResult Function(RouletteNumber number)? newNumber,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connected value) connected,
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Error value) error,
    required TResult Function(_RecentNumbers value) recentNumbers,
    required TResult Function(_NewNumber value) newNumber,
  }) {
    return disconnected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connected value)? connected,
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Error value)? error,
    TResult? Function(_RecentNumbers value)? recentNumbers,
    TResult? Function(_NewNumber value)? newNumber,
  }) {
    return disconnected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connected value)? connected,
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Error value)? error,
    TResult Function(_RecentNumbers value)? recentNumbers,
    TResult Function(_NewNumber value)? newNumber,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DisconnectedImplToJson(
      this,
    );
  }
}

abstract class _Disconnected implements WebSocketEvent {
  const factory _Disconnected() = _$DisconnectedImpl;

  factory _Disconnected.fromJson(Map<String, dynamic> json) =
      _$DisconnectedImpl.fromJson;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$WebSocketEventCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message, {final String? $type})
      : $type = $type ?? 'error';

  factory _$ErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$ErrorImplFromJson(json);

  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'WebSocketEvent.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
    required TResult Function(List<RouletteNumber> numbers) recentNumbers,
    required TResult Function(RouletteNumber number) newNumber,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connected,
    TResult? Function()? disconnected,
    TResult? Function(String message)? error,
    TResult? Function(List<RouletteNumber> numbers)? recentNumbers,
    TResult? Function(RouletteNumber number)? newNumber,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    TResult Function(List<RouletteNumber> numbers)? recentNumbers,
    TResult Function(RouletteNumber number)? newNumber,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connected value) connected,
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Error value) error,
    required TResult Function(_RecentNumbers value) recentNumbers,
    required TResult Function(_NewNumber value) newNumber,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connected value)? connected,
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Error value)? error,
    TResult? Function(_RecentNumbers value)? recentNumbers,
    TResult? Function(_NewNumber value)? newNumber,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connected value)? connected,
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Error value)? error,
    TResult Function(_RecentNumbers value)? recentNumbers,
    TResult Function(_NewNumber value)? newNumber,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ErrorImplToJson(
      this,
    );
  }
}

abstract class _Error implements WebSocketEvent {
  const factory _Error(final String message) = _$ErrorImpl;

  factory _Error.fromJson(Map<String, dynamic> json) = _$ErrorImpl.fromJson;

  String get message;

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RecentNumbersImplCopyWith<$Res> {
  factory _$$RecentNumbersImplCopyWith(
          _$RecentNumbersImpl value, $Res Function(_$RecentNumbersImpl) then) =
      __$$RecentNumbersImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<RouletteNumber> numbers});
}

/// @nodoc
class __$$RecentNumbersImplCopyWithImpl<$Res>
    extends _$WebSocketEventCopyWithImpl<$Res, _$RecentNumbersImpl>
    implements _$$RecentNumbersImplCopyWith<$Res> {
  __$$RecentNumbersImplCopyWithImpl(
      _$RecentNumbersImpl _value, $Res Function(_$RecentNumbersImpl) _then)
      : super(_value, _then);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? numbers = null,
  }) {
    return _then(_$RecentNumbersImpl(
      null == numbers
          ? _value._numbers
          : numbers // ignore: cast_nullable_to_non_nullable
              as List<RouletteNumber>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentNumbersImpl implements _RecentNumbers {
  const _$RecentNumbersImpl(final List<RouletteNumber> numbers,
      {final String? $type})
      : _numbers = numbers,
        $type = $type ?? 'recentNumbers';

  factory _$RecentNumbersImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentNumbersImplFromJson(json);

  final List<RouletteNumber> _numbers;
  @override
  List<RouletteNumber> get numbers {
    if (_numbers is EqualUnmodifiableListView) return _numbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_numbers);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'WebSocketEvent.recentNumbers(numbers: $numbers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentNumbersImpl &&
            const DeepCollectionEquality().equals(other._numbers, _numbers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_numbers));

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentNumbersImplCopyWith<_$RecentNumbersImpl> get copyWith =>
      __$$RecentNumbersImplCopyWithImpl<_$RecentNumbersImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
    required TResult Function(List<RouletteNumber> numbers) recentNumbers,
    required TResult Function(RouletteNumber number) newNumber,
  }) {
    return recentNumbers(numbers);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connected,
    TResult? Function()? disconnected,
    TResult? Function(String message)? error,
    TResult? Function(List<RouletteNumber> numbers)? recentNumbers,
    TResult? Function(RouletteNumber number)? newNumber,
  }) {
    return recentNumbers?.call(numbers);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    TResult Function(List<RouletteNumber> numbers)? recentNumbers,
    TResult Function(RouletteNumber number)? newNumber,
    required TResult orElse(),
  }) {
    if (recentNumbers != null) {
      return recentNumbers(numbers);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connected value) connected,
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Error value) error,
    required TResult Function(_RecentNumbers value) recentNumbers,
    required TResult Function(_NewNumber value) newNumber,
  }) {
    return recentNumbers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connected value)? connected,
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Error value)? error,
    TResult? Function(_RecentNumbers value)? recentNumbers,
    TResult? Function(_NewNumber value)? newNumber,
  }) {
    return recentNumbers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connected value)? connected,
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Error value)? error,
    TResult Function(_RecentNumbers value)? recentNumbers,
    TResult Function(_NewNumber value)? newNumber,
    required TResult orElse(),
  }) {
    if (recentNumbers != null) {
      return recentNumbers(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentNumbersImplToJson(
      this,
    );
  }
}

abstract class _RecentNumbers implements WebSocketEvent {
  const factory _RecentNumbers(final List<RouletteNumber> numbers) =
      _$RecentNumbersImpl;

  factory _RecentNumbers.fromJson(Map<String, dynamic> json) =
      _$RecentNumbersImpl.fromJson;

  List<RouletteNumber> get numbers;

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentNumbersImplCopyWith<_$RecentNumbersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NewNumberImplCopyWith<$Res> {
  factory _$$NewNumberImplCopyWith(
          _$NewNumberImpl value, $Res Function(_$NewNumberImpl) then) =
      __$$NewNumberImplCopyWithImpl<$Res>;
  @useResult
  $Res call({RouletteNumber number});

  $RouletteNumberCopyWith<$Res> get number;
}

/// @nodoc
class __$$NewNumberImplCopyWithImpl<$Res>
    extends _$WebSocketEventCopyWithImpl<$Res, _$NewNumberImpl>
    implements _$$NewNumberImplCopyWith<$Res> {
  __$$NewNumberImplCopyWithImpl(
      _$NewNumberImpl _value, $Res Function(_$NewNumberImpl) _then)
      : super(_value, _then);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
  }) {
    return _then(_$NewNumberImpl(
      null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as RouletteNumber,
    ));
  }

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RouletteNumberCopyWith<$Res> get number {
    return $RouletteNumberCopyWith<$Res>(_value.number, (value) {
      return _then(_value.copyWith(number: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$NewNumberImpl implements _NewNumber {
  const _$NewNumberImpl(this.number, {final String? $type})
      : $type = $type ?? 'newNumber';

  factory _$NewNumberImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewNumberImplFromJson(json);

  @override
  final RouletteNumber number;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'WebSocketEvent.newNumber(number: $number)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewNumberImpl &&
            (identical(other.number, number) || other.number == number));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, number);

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewNumberImplCopyWith<_$NewNumberImpl> get copyWith =>
      __$$NewNumberImplCopyWithImpl<_$NewNumberImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connected,
    required TResult Function() disconnected,
    required TResult Function(String message) error,
    required TResult Function(List<RouletteNumber> numbers) recentNumbers,
    required TResult Function(RouletteNumber number) newNumber,
  }) {
    return newNumber(number);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connected,
    TResult? Function()? disconnected,
    TResult? Function(String message)? error,
    TResult? Function(List<RouletteNumber> numbers)? recentNumbers,
    TResult? Function(RouletteNumber number)? newNumber,
  }) {
    return newNumber?.call(number);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connected,
    TResult Function()? disconnected,
    TResult Function(String message)? error,
    TResult Function(List<RouletteNumber> numbers)? recentNumbers,
    TResult Function(RouletteNumber number)? newNumber,
    required TResult orElse(),
  }) {
    if (newNumber != null) {
      return newNumber(number);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Connected value) connected,
    required TResult Function(_Disconnected value) disconnected,
    required TResult Function(_Error value) error,
    required TResult Function(_RecentNumbers value) recentNumbers,
    required TResult Function(_NewNumber value) newNumber,
  }) {
    return newNumber(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Connected value)? connected,
    TResult? Function(_Disconnected value)? disconnected,
    TResult? Function(_Error value)? error,
    TResult? Function(_RecentNumbers value)? recentNumbers,
    TResult? Function(_NewNumber value)? newNumber,
  }) {
    return newNumber?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Connected value)? connected,
    TResult Function(_Disconnected value)? disconnected,
    TResult Function(_Error value)? error,
    TResult Function(_RecentNumbers value)? recentNumbers,
    TResult Function(_NewNumber value)? newNumber,
    required TResult orElse(),
  }) {
    if (newNumber != null) {
      return newNumber(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NewNumberImplToJson(
      this,
    );
  }
}

abstract class _NewNumber implements WebSocketEvent {
  const factory _NewNumber(final RouletteNumber number) = _$NewNumberImpl;

  factory _NewNumber.fromJson(Map<String, dynamic> json) =
      _$NewNumberImpl.fromJson;

  RouletteNumber get number;

  /// Create a copy of WebSocketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewNumberImplCopyWith<_$NewNumberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
