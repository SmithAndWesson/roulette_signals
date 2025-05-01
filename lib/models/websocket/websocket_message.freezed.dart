// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebSocketMessage _$WebSocketMessageFromJson(Map<String, dynamic> json) {
  return _WebSocketMessage.fromJson(json);
}

/// @nodoc
mixin _$WebSocketMessage {
  String get type => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;

  /// Serializes this WebSocketMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WebSocketMessageCopyWith<WebSocketMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebSocketMessageCopyWith<$Res> {
  factory $WebSocketMessageCopyWith(
          WebSocketMessage value, $Res Function(WebSocketMessage) then) =
      _$WebSocketMessageCopyWithImpl<$Res, WebSocketMessage>;
  @useResult
  $Res call({String type, Map<String, dynamic> data});
}

/// @nodoc
class _$WebSocketMessageCopyWithImpl<$Res, $Val extends WebSocketMessage>
    implements $WebSocketMessageCopyWith<$Res> {
  _$WebSocketMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebSocketMessageImplCopyWith<$Res>
    implements $WebSocketMessageCopyWith<$Res> {
  factory _$$WebSocketMessageImplCopyWith(_$WebSocketMessageImpl value,
          $Res Function(_$WebSocketMessageImpl) then) =
      __$$WebSocketMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, Map<String, dynamic> data});
}

/// @nodoc
class __$$WebSocketMessageImplCopyWithImpl<$Res>
    extends _$WebSocketMessageCopyWithImpl<$Res, _$WebSocketMessageImpl>
    implements _$$WebSocketMessageImplCopyWith<$Res> {
  __$$WebSocketMessageImplCopyWithImpl(_$WebSocketMessageImpl _value,
      $Res Function(_$WebSocketMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? data = null,
  }) {
    return _then(_$WebSocketMessageImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebSocketMessageImpl extends _WebSocketMessage {
  const _$WebSocketMessageImpl(
      {required this.type, required final Map<String, dynamic> data})
      : _data = data,
        super._();

  factory _$WebSocketMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebSocketMessageImplFromJson(json);

  @override
  final String type;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebSocketMessageImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, const DeepCollectionEquality().hash(_data));

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WebSocketMessageImplCopyWith<_$WebSocketMessageImpl> get copyWith =>
      __$$WebSocketMessageImplCopyWithImpl<_$WebSocketMessageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebSocketMessageImplToJson(
      this,
    );
  }
}

abstract class _WebSocketMessage extends WebSocketMessage {
  const factory _WebSocketMessage(
      {required final String type,
      required final Map<String, dynamic> data}) = _$WebSocketMessageImpl;
  const _WebSocketMessage._() : super._();

  factory _WebSocketMessage.fromJson(Map<String, dynamic> json) =
      _$WebSocketMessageImpl.fromJson;

  @override
  String get type;
  @override
  Map<String, dynamic> get data;

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WebSocketMessageImplCopyWith<_$WebSocketMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
