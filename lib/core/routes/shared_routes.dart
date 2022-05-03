// imports nativos
import 'package:flutter/material.dart';

// import dos modelos
import 'package:orgalive/model/model_categories.dart';

// import das telas
import 'package:orgalive/screens/dashboard/categories_essentials.dart';
import 'package:orgalive/screens/spending_limit/detail_spending.dart';
import 'package:orgalive/screens/spending_limit/new_spending.dart';
import 'package:orgalive/screens/profile/create_credit_card.dart';
import 'package:orgalive/screens/dashboard/setting_accounts.dart';
import 'package:orgalive/screens/reports/detail_reports.dart';
import 'package:orgalive/screens/dashboard/personalize.dart';
import 'package:orgalive/screens/profile/notifications.dart';
import 'package:orgalive/screens/dashboard/more_info.dart';
import 'package:orgalive/screens/login/login_options.dart';
import 'package:orgalive/screens/profile/credit_card.dart';
import 'package:orgalive/screens/profile/settings.dart';
import 'package:orgalive/screens/profile/profile.dart';
import 'package:orgalive/screens/login/email.dart';
import 'package:orgalive/screens/login/info.dart';
import 'package:orgalive/screens/home.dart';

class SharedRoutes {

  // ir para o login
  goToLoginOptions( context,  int type ) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => LoginOptions(
          type: type,
        ),
      ),
    );
  }

  // logar com email
  goToLoginMail( context, int type ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => Email(
          type: type,
        ),
      ),
    );
  }

  // ir para as informacoes
  goToInfo( context ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (builder) => const Info(),
      ),
    );
  }

  // ir para a home sem voltar
  goToHomeRemoveUntil( context ) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (builder) => const Home(
          selected: 0,
        ),
      ),
      (route) => false,
    );
  }

  // ir para as informacoes
  goToInfoRemoveUntil( context ) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (builder) => const Info(),
      ),
      (route) => false,
    );
  }

  // gerenciar as contas
  goToSettingAccounts( context ) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const SettingAccounts(),
      ),
    );
  }

  // ir para as configuracoes
  goToSettings( context, String userUid, String photo, String user ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => Settings(
          userUid: userUid,
          photo: photo,
          user: user,
        ),
      ),
    );
  }

  // ir para as notificacoes
  goToNotifications( context ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const Notifications(),
      ),
    );
  }

  // mais informações
  goToMoreInfo( context ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const MoreInfo(),
      ),
    );
  }

  // categorias
  goToCategories( context ) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const CategoriesEssentials(),
      ),
    );
  }

  // personalizar a exibição
  goToPersonalize( context ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const Personalize(),
      ),
    );
  }

  // novo limite de gasto
  goToSpendings( context ) {
    // vai para a tela SpendingLimits()
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (builder) => const Home(
          selected: 4,
        ),
      ),
    );
  }

  // novo limite
  goToNewSpending( context ) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const NewSpending(),
      ),
    );

  }

  // ir para os detalhes do limite
  goToDetailSpending( context, ModelCategories modelCategories ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => DetailSpending(
          id: modelCategories.uid,
          name: modelCategories.name,
        ),
      ),
    );
  }

  // ir para os cartoes de credito
  goToCreditCard( context ) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const CreditCard(),
      ),
    );

  }

  // cadastrar novo cartao
  goToNewCreditCard( context ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const CreateCreditCard(),
      ),
    );
  }

  // ir para as categorias
  goToEssentialsCategories( context ) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const CategoriesEssentials(),
      ),
    );

  }

  // ir para as tags
  goToTags( context ) {

  }

  // detalhes do relatorios
  goToDetailReports( context ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const DetailReports(),
      ),
    );
  }

  // ir para o perfil
  goToProfile( context, String photo, String user ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => Profile(
          photo: photo,
          name: user,
        ),
      ),
    );
  }
}