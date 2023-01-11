// // coverage:ignore-file
// // GENERATED CODE - DO NOT MODIFY BY HAND
// // ignore_for_file: type=lint
// // ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

// part of 'network_response.dart';

// // **************************************************************************
// // FreezedGenerator
// // **************************************************************************

// T _$identity<T>(T value) => value;

// final _privateConstructorUsedError = UnsupportedError(
//     'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

// /// @nodoc
// mixin _$NetworkResponse {
//   @optionalTypeArgs
//   TResult when<TResult extends Object?>({
//     required TResult Function(Map<String, dynamic> data) success,
//     required TResult Function(String message) error,
//     required TResult Function(String message) loading,
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult? whenOrNull<TResult extends Object?>({
//     TResult Function(Map<String, dynamic> data)? success,
//     TResult Function(String message)? error,
//     TResult Function(String message)? loading,
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult maybeWhen<TResult extends Object?>({
//     TResult Function(Map<String, dynamic> data)? success,
//     TResult Function(String message)? error,
//     TResult Function(String message)? loading,
//     required TResult orElse(),
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult map<TResult extends Object?>({
//     required TResult Function(Ok value) success,
//     required TResult Function(ERROR value) error,
//     required TResult Function(LOADING value) loading,
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult? mapOrNull<TResult extends Object?>({
//     TResult Function(Ok value)? success,
//     TResult Function(ERROR value)? error,
//     TResult Function(LOADING value)? loading,
//   }) =>
//       throw _privateConstructorUsedError;
//   @optionalTypeArgs
//   TResult maybeMap<TResult extends Object?>({
//     TResult Function(Ok value)? success,
//     TResult Function(ERROR value)? error,
//     TResult Function(LOADING value)? loading,
//     required TResult orElse(),
//   }) =>
//       throw _privateConstructorUsedError;
// }

// /// @nodoc
// abstract class $NetworkResponseCopyWith<$Res> {
//   factory $NetworkResponseCopyWith(
//           NetworkResponse value, $Res Function(NetworkResponse) then) =
//       _$NetworkResponseCopyWithImpl<$Res>;
// }

// /// @nodoc
// class _$NetworkResponseCopyWithImpl<$Res>
//     implements $NetworkResponseCopyWith<$Res> {
//   _$NetworkResponseCopyWithImpl(this._value, this._then);

//   final NetworkResponse _value;
//   // ignore: unused_field
//   final $Res Function(NetworkResponse) _then;
// }

// /// @nodoc
// abstract class _$$OkCopyWith<$Res> {
//   factory _$$OkCopyWith(_$Ok value, $Res Function(_$Ok) then) =
//       __$$OkCopyWithImpl<$Res>;
//   $Res call({Map<String, dynamic> data});
// }

// /// @nodoc
// class __$$OkCopyWithImpl<$Res> extends _$NetworkResponseCopyWithImpl<$Res>
//     implements _$$OkCopyWith<$Res> {
//   __$$OkCopyWithImpl(_$Ok _value, $Res Function(_$Ok) _then)
//       : super(_value, (v) => _then(v as _$Ok));

//   @override
//   _$Ok get _value => super._value as _$Ok;

//   @override
//   $Res call({
//     Object? data = freezed,
//   }) {
//     return _then(_$Ok(
//       data == freezed
//           ? _value._data
//           : data // ignore: cast_nullable_to_non_nullable
//               as Map<String, dynamic>,
//     ));
//   }
// }

// /// @nodoc

// class _$Ok implements Ok {
//   const _$Ok(final Map<String, dynamic> data) : _data = data;

//   final Map<String, dynamic> _data;
//   @override
//   Map<String, dynamic> get data {
//     // ignore: implicit_dynamic_type
//     return EqualUnmodifiableMapView(_data);
//   }

//   @override
//   String toString() {
//     return 'NetworkResponse.success(data: $data)';
//   }

//   @override
//   bool operator ==(dynamic other) {
//     return identical(this, other) ||
//         (other.runtimeType == runtimeType &&
//             other is _$Ok &&
//             const DeepCollectionEquality().equals(other._data, _data));
//   }

//   @override
//   int get hashCode =>
//       Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

//   @JsonKey(ignore: true)
//   @override
//   _$$OkCopyWith<_$Ok> get copyWith =>
//       __$$OkCopyWithImpl<_$Ok>(this, _$identity);

//   @override
//   @optionalTypeArgs
//   TResult when<TResult extends Object?>({
//     required TResult Function(Map<String, dynamic> data) success,
//     required TResult Function(String message) error,
//     required TResult Function(String message) loading,
//   }) {
//     return success(data);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? whenOrNull<TResult extends Object?>({
//     TResult Function(Map<String, dynamic> data)? success,
//     TResult Function(String message)? error,
//     TResult Function(String message)? loading,
//   }) {
//     return success?.call(data);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeWhen<TResult extends Object?>({
//     TResult Function(Map<String, dynamic> data)? success,
//     TResult Function(String message)? error,
//     TResult Function(String message)? loading,
//     required TResult orElse(),
//   }) {
//     if (success != null) {
//       return success(data);
//     }
//     return orElse();
//   }

//   @override
//   @optionalTypeArgs
//   TResult map<TResult extends Object?>({
//     required TResult Function(Ok value) success,
//     required TResult Function(ERROR value) error,
//     required TResult Function(LOADING value) loading,
//   }) {
//     return success(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? mapOrNull<TResult extends Object?>({
//     TResult Function(Ok value)? success,
//     TResult Function(ERROR value)? error,
//     TResult Function(LOADING value)? loading,
//   }) {
//     return success?.call(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeMap<TResult extends Object?>({
//     TResult Function(Ok value)? success,
//     TResult Function(ERROR value)? error,
//     TResult Function(LOADING value)? loading,
//     required TResult orElse(),
//   }) {
//     if (success != null) {
//       return success(this);
//     }
//     return orElse();
//   }
// }

// abstract class Ok implements NetworkResponse {
//   const factory Ok(final Map<String, dynamic> data) = _$Ok;

//   Map<String, dynamic> get data => throw _privateConstructorUsedError;
//   @JsonKey(ignore: true)
//   _$$OkCopyWith<_$Ok> get copyWith => throw _privateConstructorUsedError;
// }

// /// @nodoc
// abstract class _$$ERRORCopyWith<$Res> {
//   factory _$$ERRORCopyWith(_$ERROR value, $Res Function(_$ERROR) then) =
//       __$$ERRORCopyWithImpl<$Res>;
//   $Res call({String message});
// }

// /// @nodoc
// class __$$ERRORCopyWithImpl<$Res> extends _$NetworkResponseCopyWithImpl<$Res>
//     implements _$$ERRORCopyWith<$Res> {
//   __$$ERRORCopyWithImpl(_$ERROR _value, $Res Function(_$ERROR) _then)
//       : super(_value, (v) => _then(v as _$ERROR));

//   @override
//   _$ERROR get _value => super._value as _$ERROR;

//   @override
//   $Res call({
//     Object? message = freezed,
//   }) {
//     return _then(_$ERROR(
//       message == freezed
//           ? _value.message
//           : message // ignore: cast_nullable_to_non_nullable
//               as String,
//     ));
//   }
// }

// /// @nodoc

// class _$ERROR implements ERROR {
//   const _$ERROR(this.message);

//   @override
//   final String message;

//   @override
//   String toString() {
//     return 'NetworkResponse.error(message: $message)';
//   }

//   @override
//   bool operator ==(dynamic other) {
//     return identical(this, other) ||
//         (other.runtimeType == runtimeType &&
//             other is _$ERROR &&
//             const DeepCollectionEquality().equals(other.message, message));
//   }

//   @override
//   int get hashCode =>
//       Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

//   @JsonKey(ignore: true)
//   @override
//   _$$ERRORCopyWith<_$ERROR> get copyWith =>
//       __$$ERRORCopyWithImpl<_$ERROR>(this, _$identity);

//   @override
//   @optionalTypeArgs
//   TResult when<TResult extends Object?>({
//     required TResult Function(Map<String, dynamic> data) success,
//     required TResult Function(String message) error,
//     required TResult Function(String message) loading,
//   }) {
//     return error(message);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? whenOrNull<TResult extends Object?>({
//     TResult Function(Map<String, dynamic> data)? success,
//     TResult Function(String message)? error,
//     TResult Function(String message)? loading,
//   }) {
//     return error?.call(message);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeWhen<TResult extends Object?>({
//     TResult Function(Map<String, dynamic> data)? success,
//     TResult Function(String message)? error,
//     TResult Function(String message)? loading,
//     required TResult orElse(),
//   }) {
//     if (error != null) {
//       return error(message);
//     }
//     return orElse();
//   }

//   @override
//   @optionalTypeArgs
//   TResult map<TResult extends Object?>({
//     required TResult Function(Ok value) success,
//     required TResult Function(ERROR value) error,
//     required TResult Function(LOADING value) loading,
//   }) {
//     return error(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? mapOrNull<TResult extends Object?>({
//     TResult Function(Ok value)? success,
//     TResult Function(ERROR value)? error,
//     TResult Function(LOADING value)? loading,
//   }) {
//     return error?.call(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeMap<TResult extends Object?>({
//     TResult Function(Ok value)? success,
//     TResult Function(ERROR value)? error,
//     TResult Function(LOADING value)? loading,
//     required TResult orElse(),
//   }) {
//     if (error != null) {
//       return error(this);
//     }
//     return orElse();
//   }
// }

// abstract class ERROR implements NetworkResponse {
//   const factory ERROR(final String message) = _$ERROR;

//   String get message => throw _privateConstructorUsedError;
//   @JsonKey(ignore: true)
//   _$$ERRORCopyWith<_$ERROR> get copyWith => throw _privateConstructorUsedError;
// }

// /// @nodoc
// abstract class _$$LOADINGCopyWith<$Res> {
//   factory _$$LOADINGCopyWith(_$LOADING value, $Res Function(_$LOADING) then) =
//       __$$LOADINGCopyWithImpl<$Res>;
//   $Res call({String message});
// }

// /// @nodoc
// class __$$LOADINGCopyWithImpl<$Res> extends _$NetworkResponseCopyWithImpl<$Res>
//     implements _$$LOADINGCopyWith<$Res> {
//   __$$LOADINGCopyWithImpl(_$LOADING _value, $Res Function(_$LOADING) _then)
//       : super(_value, (v) => _then(v as _$LOADING));

//   @override
//   _$LOADING get _value => super._value as _$LOADING;

//   @override
//   $Res call({
//     Object? message = freezed,
//   }) {
//     return _then(_$LOADING(
//       message == freezed
//           ? _value.message
//           : message // ignore: cast_nullable_to_non_nullable
//               as String,
//     ));
//   }
// }

// /// @nodoc

// class _$LOADING implements LOADING {
//   const _$LOADING(this.message);

//   @override
//   final String message;

//   @override
//   String toString() {
//     return 'NetworkResponse.loading(message: $message)';
//   }

//   @override
//   bool operator ==(dynamic other) {
//     return identical(this, other) ||
//         (other.runtimeType == runtimeType &&
//             other is _$LOADING &&
//             const DeepCollectionEquality().equals(other.message, message));
//   }

//   @override
//   int get hashCode =>
//       Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

//   @JsonKey(ignore: true)
//   @override
//   _$$LOADINGCopyWith<_$LOADING> get copyWith =>
//       __$$LOADINGCopyWithImpl<_$LOADING>(this, _$identity);

//   @override
//   @optionalTypeArgs
//   TResult when<TResult extends Object?>({
//     required TResult Function(Map<String, dynamic> data) success,
//     required TResult Function(String message) error,
//     required TResult Function(String message) loading,
//   }) {
//     return loading(message);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? whenOrNull<TResult extends Object?>({
//     TResult Function(Map<String, dynamic> data)? success,
//     TResult Function(String message)? error,
//     TResult Function(String message)? loading,
//   }) {
//     return loading?.call(message);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeWhen<TResult extends Object?>({
//     TResult Function(Map<String, dynamic> data)? success,
//     TResult Function(String message)? error,
//     TResult Function(String message)? loading,
//     required TResult orElse(),
//   }) {
//     if (loading != null) {
//       return loading(message);
//     }
//     return orElse();
//   }

//   @override
//   @optionalTypeArgs
//   TResult map<TResult extends Object?>({
//     required TResult Function(Ok value) success,
//     required TResult Function(ERROR value) error,
//     required TResult Function(LOADING value) loading,
//   }) {
//     return loading(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult? mapOrNull<TResult extends Object?>({
//     TResult Function(Ok value)? success,
//     TResult Function(ERROR value)? error,
//     TResult Function(LOADING value)? loading,
//   }) {
//     return loading?.call(this);
//   }

//   @override
//   @optionalTypeArgs
//   TResult maybeMap<TResult extends Object?>({
//     TResult Function(Ok value)? success,
//     TResult Function(ERROR value)? error,
//     TResult Function(LOADING value)? loading,
//     required TResult orElse(),
//   }) {
//     if (loading != null) {
//       return loading(this);
//     }
//     return orElse();
//   }
// }

// abstract class LOADING implements NetworkResponse {
//   const factory LOADING(final String message) = _$LOADING;

//   String get message => throw _privateConstructorUsedError;
//   @JsonKey(ignore: true)
//   _$$LOADINGCopyWith<_$LOADING> get copyWith =>
//       throw _privateConstructorUsedError;
// }
