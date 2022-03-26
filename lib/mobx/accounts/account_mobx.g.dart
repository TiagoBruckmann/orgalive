// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AccountMobx on _AccountMobx, Store {
  final _$userUidAtom = Atom(name: '_AccountMobx.userUid');

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

  final _$screenActiveAtom = Atom(name: '_AccountMobx.screenActive');

  @override
  int get screenActive {
    _$screenActiveAtom.reportRead();
    return super.screenActive;
  }

  @override
  set screenActive(int value) {
    _$screenActiveAtom.reportWrite(value, super.screenActive, () {
      super.screenActive = value;
    });
  }

  final _$categoryAtom = Atom(name: '_AccountMobx.category');

  @override
  String get category {
    _$categoryAtom.reportRead();
    return super.category;
  }

  @override
  set category(String value) {
    _$categoryAtom.reportWrite(value, super.category, () {
      super.category = value;
    });
  }

  final _$accountIdAtom = Atom(name: '_AccountMobx.accountId');

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

  final _$oldValueAtom = Atom(name: '_AccountMobx.oldValue');

  @override
  String get oldValue {
    _$oldValueAtom.reportRead();
    return super.oldValue;
  }

  @override
  set oldValue(String value) {
    _$oldValueAtom.reportWrite(value, super.oldValue, () {
      super.oldValue = value;
    });
  }

  final _$originAccountIdAtom = Atom(name: '_AccountMobx.originAccountId');

  @override
  String get originAccountId {
    _$originAccountIdAtom.reportRead();
    return super.originAccountId;
  }

  @override
  set originAccountId(String value) {
    _$originAccountIdAtom.reportWrite(value, super.originAccountId, () {
      super.originAccountId = value;
    });
  }

  final _$originOldValueAtom = Atom(name: '_AccountMobx.originOldValue');

  @override
  String get originOldValue {
    _$originOldValueAtom.reportRead();
    return super.originOldValue;
  }

  @override
  set originOldValue(String value) {
    _$originOldValueAtom.reportWrite(value, super.originOldValue, () {
      super.originOldValue = value;
    });
  }

  final _$daySelectedAtom = Atom(name: '_AccountMobx.daySelected');

  @override
  DateTime get daySelected {
    _$daySelectedAtom.reportRead();
    return super.daySelected;
  }

  @override
  set daySelected(DateTime value) {
    _$daySelectedAtom.reportWrite(value, super.daySelected, () {
      super.daySelected = value;
    });
  }

  final _$getAccountsAsyncAction = AsyncAction('_AccountMobx.getAccounts');

  @override
  Future<List<ModelAccounts>> getAccounts({String? originDocumentId}) {
    return _$getAccountsAsyncAction
        .run(() => super.getAccounts(originDocumentId: originDocumentId));
  }

  final _$getCategoriesAsyncAction = AsyncAction('_AccountMobx.getCategories');

  @override
  Future<List<ModelCategories>> getCategories() {
    return _$getCategoriesAsyncAction.run(() => super.getCategories());
  }

  final _$uploadImageAsyncAction = AsyncAction('_AccountMobx.uploadImage');

  @override
  Future<dynamic> uploadImage(List<XFile> imageFileList) {
    return _$uploadImageAsyncAction.run(() => super.uploadImage(imageFileList));
  }

  final _$saveReleaseAsyncAction = AsyncAction('_AccountMobx.saveRelease');

  @override
  Future saveRelease(List<XFile>? imageFileList, String registerValue,
      String type, String description, dynamic context) {
    return _$saveReleaseAsyncAction.run(() => super
        .saveRelease(imageFileList, registerValue, type, description, context));
  }

  final _$updateAccountAsyncAction = AsyncAction('_AccountMobx.updateAccount');

  @override
  Future updateAccount(num value, dynamic context) {
    return _$updateAccountAsyncAction
        .run(() => super.updateAccount(value, context));
  }

  final _$_AccountMobxActionController = ActionController(name: '_AccountMobx');

  @override
  dynamic setData(String userid, int screen) {
    final _$actionInfo = _$_AccountMobxActionController.startAction(
        name: '_AccountMobx.setData');
    try {
      return super.setData(userid, screen);
    } finally {
      _$_AccountMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setValue(ModelAccounts modelAccounts) {
    final _$actionInfo = _$_AccountMobxActionController.startAction(
        name: '_AccountMobx.setValue');
    try {
      return super.setValue(modelAccounts);
    } finally {
      _$_AccountMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOrigin(ModelAccounts modelAccounts) {
    final _$actionInfo = _$_AccountMobxActionController.startAction(
        name: '_AccountMobx.setOrigin');
    try {
      return super.setOrigin(modelAccounts);
    } finally {
      _$_AccountMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDateSelected(DateTime? date) {
    final _$actionInfo = _$_AccountMobxActionController.startAction(
        name: '_AccountMobx.setDateSelected');
    try {
      return super.setDateSelected(date);
    } finally {
      _$_AccountMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCategory(String value) {
    final _$actionInfo = _$_AccountMobxActionController.startAction(
        name: '_AccountMobx.setCategory');
    try {
      return super.setCategory(value);
    } finally {
      _$_AccountMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userUid: ${userUid},
screenActive: ${screenActive},
category: ${category},
accountId: ${accountId},
oldValue: ${oldValue},
originAccountId: ${originAccountId},
originOldValue: ${originOldValue},
daySelected: ${daySelected}
    ''';
  }
}
