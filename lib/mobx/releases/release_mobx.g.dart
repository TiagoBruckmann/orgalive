// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ReleaseMobx on _ReleaseMobx, Store {
  final _$userUidAtom = Atom(name: '_ReleaseMobx.userUid');

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

  final _$isLoadingAtom = Atom(name: '_ReleaseMobx.isLoading');

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

  final _$filterReleasesAsyncAction =
      AsyncAction('_ReleaseMobx.filterReleases');

  @override
  Future filterReleases(DateTime dateFilter, dynamic context) {
    return _$filterReleasesAsyncAction
        .run(() => super.filterReleases(dateFilter, context));
  }

  final _$_ReleaseMobxActionController = ActionController(name: '_ReleaseMobx');

  @override
  void setUserUid(String value) {
    final _$actionInfo = _$_ReleaseMobxActionController.startAction(
        name: '_ReleaseMobx.setUserUid');
    try {
      return super.setUserUid(value);
    } finally {
      _$_ReleaseMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updLoading(bool value) {
    final _$actionInfo = _$_ReleaseMobxActionController.startAction(
        name: '_ReleaseMobx.updLoading');
    try {
      return super.updLoading(value);
    } finally {
      _$_ReleaseMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNew(ModelRelease modelRelease) {
    final _$actionInfo =
        _$_ReleaseMobxActionController.startAction(name: '_ReleaseMobx.setNew');
    try {
      return super.setNew(modelRelease);
    } finally {
      _$_ReleaseMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo =
        _$_ReleaseMobxActionController.startAction(name: '_ReleaseMobx.clear');
    try {
      return super.clear();
    } finally {
      _$_ReleaseMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userUid: ${userUid},
isLoading: ${isLoading}
    ''';
  }
}
