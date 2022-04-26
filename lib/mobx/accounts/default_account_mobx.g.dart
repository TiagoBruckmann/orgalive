// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_account_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DefaultAccountMobx on _DefaultAccountMobx, Store {
  late final _$isLoadingAtom =
      Atom(name: '_DefaultAccountMobx.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$accountIdAtom =
      Atom(name: '_DefaultAccountMobx.accountId', context: context);

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

  late final _$accountAtom =
      Atom(name: '_DefaultAccountMobx.account', context: context);

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

  late final _$valueAtom =
      Atom(name: '_DefaultAccountMobx.value', context: context);

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

  late final _$valueVisibleAtom =
      Atom(name: '_DefaultAccountMobx.valueVisible', context: context);

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

  late final _$_DefaultAccountMobxActionController =
      ActionController(name: '_DefaultAccountMobx', context: context);

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
  void updLoading(bool value) {
    final _$actionInfo = _$_DefaultAccountMobxActionController.startAction(
        name: '_DefaultAccountMobx.updLoading');
    try {
      return super.updLoading(value);
    } finally {
      _$_DefaultAccountMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateVale(
      String newValue, String document, dynamic _db, dynamic context) {
    final _$actionInfo = _$_DefaultAccountMobxActionController.startAction(
        name: '_DefaultAccountMobx.updateVale');
    try {
      return super.updateVale(newValue, document, _db, context);
    } finally {
      _$_DefaultAccountMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNew(ModelAccounts modelAccounts) {
    final _$actionInfo = _$_DefaultAccountMobxActionController.startAction(
        name: '_DefaultAccountMobx.setNew');
    try {
      return super.setNew(modelAccounts);
    } finally {
      _$_DefaultAccountMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_DefaultAccountMobxActionController.startAction(
        name: '_DefaultAccountMobx.clear');
    try {
      return super.clear();
    } finally {
      _$_DefaultAccountMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
accountId: ${accountId},
account: ${account},
value: ${value},
valueVisible: ${valueVisible}
    ''';
  }
}
