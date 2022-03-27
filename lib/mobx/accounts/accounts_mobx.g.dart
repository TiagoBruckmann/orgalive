// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AccountsMobx on _AccountsMobx, Store {
  final _$isLoadingAtom = Atom(name: '_AccountsMobx.isLoading');

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

  final _$_AccountsMobxActionController =
      ActionController(name: '_AccountsMobx');

  @override
  void updLoading(bool value) {
    final _$actionInfo = _$_AccountsMobxActionController.startAction(
        name: '_AccountsMobx.updLoading');
    try {
      return super.updLoading(value);
    } finally {
      _$_AccountsMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNew(ModelAccounts modelAccounts) {
    final _$actionInfo = _$_AccountsMobxActionController.startAction(
        name: '_AccountsMobx.setNew');
    try {
      return super.setNew(modelAccounts);
    } finally {
      _$_AccountsMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_AccountsMobxActionController.startAction(
        name: '_AccountsMobx.clear');
    try {
      return super.clear();
    } finally {
      _$_AccountsMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading}
    ''';
  }
}
