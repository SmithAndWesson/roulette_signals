// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roulette_number.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RouletteNumber _$RouletteNumberFromJson(Map<String, dynamic> json) {
  return _RouletteNumber.fromJson(json);
}

/// @nodoc
mixin _$RouletteNumber {
  int get value => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  bool get isEven => throw _privateConstructorUsedError;
  bool get isHigh => throw _privateConstructorUsedError;

  /// Serializes this RouletteNumber to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RouletteNumber
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouletteNumberCopyWith<RouletteNumber> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouletteNumberCopyWith<$Res> {
  factory $RouletteNumberCopyWith(
          RouletteNumber value, $Res Function(RouletteNumber) then) =
      _$RouletteNumberCopyWithImpl<$Res, RouletteNumber>;
  @useResult
  $Res call({int value, String color, bool isEven, bool isHigh});
}

/// @nodoc
class _$RouletteNumberCopyWithImpl<$Res, $Val extends RouletteNumber>
    implements $RouletteNumberCopyWith<$Res> {
  _$RouletteNumberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouletteNumber
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? color = null,
    Object? isEven = null,
    Object? isHigh = null,
  }) {
    return _then(_value.copyWith(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      isEven: null == isEven
          ? _value.isEven
          : isEven // ignore: cast_nullable_to_non_nullable
              as bool,
      isHigh: null == isHigh
          ? _value.isHigh
          : isHigh // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouletteNumberImplCopyWith<$Res>
    implements $RouletteNumberCopyWith<$Res> {
  factory _$$RouletteNumberImplCopyWith(_$RouletteNumberImpl value,
          $Res Function(_$RouletteNumberImpl) then) =
      __$$RouletteNumberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int value, String color, bool isEven, bool isHigh});
}

/// @nodoc
class __$$RouletteNumberImplCopyWithImpl<$Res>
    extends _$RouletteNumberCopyWithImpl<$Res, _$RouletteNumberImpl>
    implements _$$RouletteNumberImplCopyWith<$Res> {
  __$$RouletteNumberImplCopyWithImpl(
      _$RouletteNumberImpl _value, $Res Function(_$RouletteNumberImpl) _then)
      : super(_value, _then);

  /// Create a copy of RouletteNumber
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? color = null,
    Object? isEven = null,
    Object? isHigh = null,
  }) {
    return _then(_$RouletteNumberImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      isEven: null == isEven
          ? _value.isEven
          : isEven // ignore: cast_nullable_to_non_nullable
              as bool,
      isHigh: null == isHigh
          ? _value.isHigh
          : isHigh // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RouletteNumberImpl implements _RouletteNumber {
  const _$RouletteNumberImpl(
      {required this.value,
      required this.color,
      required this.isEven,
      required this.isHigh});

  factory _$RouletteNumberImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouletteNumberImplFromJson(json);

  @override
  final int value;
  @override
  final String color;
  @override
  final bool isEven;
  @override
  final bool isHigh;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouletteNumberImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isEven, isEven) || other.isEven == isEven) &&
            (identical(other.isHigh, isHigh) || other.isHigh == isHigh));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value, color, isEven, isHigh);

  /// Create a copy of RouletteNumber
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouletteNumberImplCopyWith<_$RouletteNumberImpl> get copyWith =>
      __$$RouletteNumberImplCopyWithImpl<_$RouletteNumberImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouletteNumberImplToJson(
      this,
    );
  }
}

abstract class _RouletteNumber implements RouletteNumber {
  const factory _RouletteNumber(
      {required final int value,
      required final String color,
      required final bool isEven,
      required final bool isHigh}) = _$RouletteNumberImpl;

  factory _RouletteNumber.fromJson(Map<String, dynamic> json) =
      _$RouletteNumberImpl.fromJson;

  @override
  int get value;
  @override
  String get color;
  @override
  bool get isEven;
  @override
  bool get isHigh;

  /// Create a copy of RouletteNumber
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouletteNumberImplCopyWith<_$RouletteNumberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
