// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_account_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DefaultAccountMobx on _DefaultAccountMobx, Store {
  final _$accountIdAtom = Atom(name: '_DefaultAccountMobx.accountId');

  @override
  String get accountId {
    _$accountIdAtom.reportRead();
    return super.accountId;
  }

  @override
  set accountId(String value) {
    _$accountIdAtom.reportWrite(value, super.accountId, () {
      super.accountId = value;
    });
  }

  final _$accountAtom = Atom(name: '_DefaultAccountMobx.account');

  @override
  String get account {
    _$accountAtom.reportRead();
    return super.account;
  }

  @override
  set account(String value) {
    _$accountAtom.reportWrite(value, super.account, () {
      super.account = value;
    });
  }

  final _$valueAtom = Atom(name: '_DefaultAccountMobx.value');

  @override
  String get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(String value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$valueVisibleAtom = Atom(name: '_DefaultAccountMobx.valueVisible');

  @override
  bool get valueVisible {
    _$valueVisibleAtom.reportRead();
    return super.valueVisible;
  }

  @override
  set valueVisible(bool value) {
    _$valueVisibleAtom.reportWrite(value, super.valueVisible, () {
      super.valueVisible = value;
    });
  }

  final _$_DefaultAccountMobxActionController =
      ActionController(name: '_DefaultAccountMobx');

  @override
  void setData(dynamic data) {
    final _$actionInfo = _$_DefaultAccountMobxActionController.startAction(
        name: '_DefaultAccountMobx.setData');
    try {
      return super.setData(data);
    } finally {
      _$_DefaultAccountMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updVisible() {
    final _$actionInfo = _$_DefaultAccountMobxActionController.startAction(
        name: '_DefaultAccountMobx.updVisible');
    try {
      return super.updVisible();
    } finally {
      _$_DefaultAccountMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
accountId: ${accountId},
account: ${account},
value: ${value},
valueVisible: ${valueVisible}
    ''';
  }
}
