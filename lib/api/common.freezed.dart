// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'common.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return _Config.fromJson(json);
}

/// @nodoc
mixin _$Config {
  String get user => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  int get fetchSeconds => throw _privateConstructorUsedError;
  bool get showBingWallpaper => throw _privateConstructorUsedError;
  String get cyberPass => throw _privateConstructorUsedError;
  bool get demoMode => throw _privateConstructorUsedError;
  double get volumeNormal => throw _privateConstructorUsedError;
  double get volumeOpenBluetooth => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfigCopyWith<Config> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigCopyWith<$Res> {
  factory $ConfigCopyWith(Config value, $Res Function(Config) then) =
      _$ConfigCopyWithImpl<$Res, Config>;
  @useResult
  $Res call(
      {String user,
      String password,
      int fetchSeconds,
      bool showBingWallpaper,
      String cyberPass,
      bool demoMode,
      double volumeNormal,
      double volumeOpenBluetooth});
}

/// @nodoc
class _$ConfigCopyWithImpl<$Res, $Val extends Config>
    implements $ConfigCopyWith<$Res> {
  _$ConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? password = null,
    Object? fetchSeconds = null,
    Object? showBingWallpaper = null,
    Object? cyberPass = null,
    Object? demoMode = null,
    Object? volumeNormal = null,
    Object? volumeOpenBluetooth = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      fetchSeconds: null == fetchSeconds
          ? _value.fetchSeconds
          : fetchSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      showBingWallpaper: null == showBingWallpaper
          ? _value.showBingWallpaper
          : showBingWallpaper // ignore: cast_nullable_to_non_nullable
              as bool,
      cyberPass: null == cyberPass
          ? _value.cyberPass
          : cyberPass // ignore: cast_nullable_to_non_nullable
              as String,
      demoMode: null == demoMode
          ? _value.demoMode
          : demoMode // ignore: cast_nullable_to_non_nullable
              as bool,
      volumeNormal: null == volumeNormal
          ? _value.volumeNormal
          : volumeNormal // ignore: cast_nullable_to_non_nullable
              as double,
      volumeOpenBluetooth: null == volumeOpenBluetooth
          ? _value.volumeOpenBluetooth
          : volumeOpenBluetooth // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConfigImplCopyWith<$Res> implements $ConfigCopyWith<$Res> {
  factory _$$ConfigImplCopyWith(
          _$ConfigImpl value, $Res Function(_$ConfigImpl) then) =
      __$$ConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String user,
      String password,
      int fetchSeconds,
      bool showBingWallpaper,
      String cyberPass,
      bool demoMode,
      double volumeNormal,
      double volumeOpenBluetooth});
}

/// @nodoc
class __$$ConfigImplCopyWithImpl<$Res>
    extends _$ConfigCopyWithImpl<$Res, _$ConfigImpl>
    implements _$$ConfigImplCopyWith<$Res> {
  __$$ConfigImplCopyWithImpl(
      _$ConfigImpl _value, $Res Function(_$ConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? password = null,
    Object? fetchSeconds = null,
    Object? showBingWallpaper = null,
    Object? cyberPass = null,
    Object? demoMode = null,
    Object? volumeNormal = null,
    Object? volumeOpenBluetooth = null,
  }) {
    return _then(_$ConfigImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      fetchSeconds: null == fetchSeconds
          ? _value.fetchSeconds
          : fetchSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      showBingWallpaper: null == showBingWallpaper
          ? _value.showBingWallpaper
          : showBingWallpaper // ignore: cast_nullable_to_non_nullable
              as bool,
      cyberPass: null == cyberPass
          ? _value.cyberPass
          : cyberPass // ignore: cast_nullable_to_non_nullable
              as String,
      demoMode: null == demoMode
          ? _value.demoMode
          : demoMode // ignore: cast_nullable_to_non_nullable
              as bool,
      volumeNormal: null == volumeNormal
          ? _value.volumeNormal
          : volumeNormal // ignore: cast_nullable_to_non_nullable
              as double,
      volumeOpenBluetooth: null == volumeOpenBluetooth
          ? _value.volumeOpenBluetooth
          : volumeOpenBluetooth // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfigImpl with DiagnosticableTreeMixin implements _Config {
  _$ConfigImpl(
      {this.user = "",
      this.password = "",
      this.fetchSeconds = 60,
      this.showBingWallpaper = false,
      this.cyberPass = "",
      this.demoMode = true,
      this.volumeNormal = 0.1,
      this.volumeOpenBluetooth = 0.5});

  factory _$ConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfigImplFromJson(json);

  @override
  @JsonKey()
  final String user;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final int fetchSeconds;
  @override
  @JsonKey()
  final bool showBingWallpaper;
  @override
  @JsonKey()
  final String cyberPass;
  @override
  @JsonKey()
  final bool demoMode;
  @override
  @JsonKey()
  final double volumeNormal;
  @override
  @JsonKey()
  final double volumeOpenBluetooth;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Config(user: $user, password: $password, fetchSeconds: $fetchSeconds, showBingWallpaper: $showBingWallpaper, cyberPass: $cyberPass, demoMode: $demoMode, volumeNormal: $volumeNormal, volumeOpenBluetooth: $volumeOpenBluetooth)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Config'))
      ..add(DiagnosticsProperty('user', user))
      ..add(DiagnosticsProperty('password', password))
      ..add(DiagnosticsProperty('fetchSeconds', fetchSeconds))
      ..add(DiagnosticsProperty('showBingWallpaper', showBingWallpaper))
      ..add(DiagnosticsProperty('cyberPass', cyberPass))
      ..add(DiagnosticsProperty('demoMode', demoMode))
      ..add(DiagnosticsProperty('volumeNormal', volumeNormal))
      ..add(DiagnosticsProperty('volumeOpenBluetooth', volumeOpenBluetooth));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.fetchSeconds, fetchSeconds) ||
                other.fetchSeconds == fetchSeconds) &&
            (identical(other.showBingWallpaper, showBingWallpaper) ||
                other.showBingWallpaper == showBingWallpaper) &&
            (identical(other.cyberPass, cyberPass) ||
                other.cyberPass == cyberPass) &&
            (identical(other.demoMode, demoMode) ||
                other.demoMode == demoMode) &&
            (identical(other.volumeNormal, volumeNormal) ||
                other.volumeNormal == volumeNormal) &&
            (identical(other.volumeOpenBluetooth, volumeOpenBluetooth) ||
                other.volumeOpenBluetooth == volumeOpenBluetooth));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      user,
      password,
      fetchSeconds,
      showBingWallpaper,
      cyberPass,
      demoMode,
      volumeNormal,
      volumeOpenBluetooth);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigImplCopyWith<_$ConfigImpl> get copyWith =>
      __$$ConfigImplCopyWithImpl<_$ConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfigImplToJson(
      this,
    );
  }
}

abstract class _Config implements Config {
  factory _Config(
      {final String user,
      final String password,
      final int fetchSeconds,
      final bool showBingWallpaper,
      final String cyberPass,
      final bool demoMode,
      final double volumeNormal,
      final double volumeOpenBluetooth}) = _$ConfigImpl;

  factory _Config.fromJson(Map<String, dynamic> json) = _$ConfigImpl.fromJson;

  @override
  String get user;
  @override
  String get password;
  @override
  int get fetchSeconds;
  @override
  bool get showBingWallpaper;
  @override
  String get cyberPass;
  @override
  bool get demoMode;
  @override
  double get volumeNormal;
  @override
  double get volumeOpenBluetooth;
  @override
  @JsonKey(ignore: true)
  _$$ConfigImplCopyWith<_$ConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
