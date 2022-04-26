// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UsersMobx on _UsersMobx, Store {
  late final _$timeOfDayAtom =
      Atom(name: '_UsersMobx.timeOfDay', context: context);

  @override
  String get timeOfDay {
    _$timeOfDayAtom.reportRead();
    return super.timeOfDay;
  }

  @override
  set timeOfDay(String value) {
    _$timeOfDayAtom.reportWrite(value, super.timeOfDay, () {
      super.timeOfDay = value;
    });
  }

  late final _$userAtom = Atom(name: '_UsersMobx.user', context: context);

  @override
  String get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(String value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$photoAtom = Atom(name: '_UsersMobx.photo', context: context);

  @override
  String get photo {
    _$photoAtom.reportRead();
    return super.photo;
  }

  @override
  set photo(String value) {
    _$photoAtom.reportWrite(value, super.photo, () {
      super.photo = value;
    });
  }

  late final _$userUidAtom = Atom(name: '_UsersMobx.userUid', context: context);

  @override
  String get userUid {
    _$userUidAtom.reportRead();
    return super.userUid;
  }

  @override
  set userUid(String value) {
    _$userUidAtom.reportWrite(value, super.userUid, () {
      super.userUid = value;
    });
  }

  late final _$getInfoAsyncAction =
      AsyncAction('_UsersMobx.getInfo', context: context);

  @override
  Future getInfo() {
    return _$getInfoAsyncAction.run(() => super.getInfo());
  }

  @override
  String toString() {
    return '''
timeOfDay: ${timeOfDay},
user: ${user},
photo: ${photo},
userUid: ${userUid}
    ''';
  }
}
