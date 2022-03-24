# orgalive

Orgalive - Seu aplicativo de gestão e organização financeira

```
# Versionamento
#
# ┌────── Marcos
# │ ┌─────── Épicos
# │ │ ┌──────── Funcionalidade nova (reseta ao finalizar um marco/Épico)
# │ │ │
# 1.1.1
```

---

##### Pacotes utilizados

<ul>
    <li>flutter_native_splash</li>
    <li>firebase_performance</li>
    <li>font_awesome_flutter</li>
    <li>firebase_crashlytics</li>
    <li>flutter_masked_text2</li>
    <li>firebase_analytics</li>
    <li>calendar_timeline</li>
    <li>connectivity_plus</li>
    <li>firebase_storage</li>
    <li>cloud_firestore</li>
    <li>cupertino_icons</li>
    <li>google_sign_in</li>
    <li>awesome_select</li>
    <li>google_nav_bar</li>
    <li>flutter_lints</li>
    <li>firebase_core</li>
    <li>firebase_auth</li>
    <li>find_dropdown</li>
    <li>image_picker</li>
    <li>flutter_mobx</li>
    <li>mobx_codegen</li>
    <li>build_runner</li>
    <li>provider</li>
    <li>graphic</li>
    <li>mobx</li>
    <li>intl</li>
</ul>

### :star: Gerar APK release da loja android

```sh
flutter build appbundle
```

### :star2: Gerar APK release com ofuscação de codigo
##### Deixa mais leve o app pois gera para cada versão de dispositivo

```sh
flutter build apk --split-per-abi
```

Cores padrão:

- greyBackground ![#242323](https://via.placeholder.com/15/242323/000000?text=+) `#242323`
- yellowDefault ![#FFDB23](https://via.placeholder.com/15/FFDB23/000000?text=+) `#FFDB23`
- greenDefault ![#00A859](https://via.placeholder.com/15/00A859/000000?text=+) `#00A859`
- greyDefault ![#363435](https://via.placeholder.com/15/363435/000000?text=+) `#363435`
- blueDefault ![#137ccd](https://via.placeholder.com/15/137ccd/000000?text=+) `#137ccd`
- redDefault ![#E42924](https://via.placeholder.com/15/E42924/000000?text=+) `#E42924`

Cinza:

- matterhorn ![#4F4F4F](https://via.placeholder.com/15/4F4F4F/000000?text=+) `#4F4F4F`
- bossanova ![#494649](https://via.placeholder.com/15/494649/000000?text=+) `#494649`
- darkGray ![#AAAAAA](https://via.placeholder.com/15/AAAAAA/000000?text=+) `#AAAAAA`
- silver ![#BDBDBD](https://via.placeholder.com/15/BDBDBD/000000?text=+) `#BDBDBD`

Branco:

- whiteSmoke ![#F5F5F5](https://via.placeholder.com/15/F5F5F5/000000?text=+) `#F5F5F5`
- gainsboro ![#E0E0E0](https://via.placeholder.com/15/E0E0E0/000000?text=+) `#E0E0E0`
- solitude ![#e8f0fe](https://via.placeholder.com/15/e8f0fe/000000?text=+) `#e8f0fe`

rosa:

- fuchsia ![#d242d2](https://via.placeholder.com/15/d242d2/000000?text=+) `#d242d2`


### :gear: Configurações do projeto
alterar o arquivo build.gradle a nivel app
caminho: android > app > build.gradle

alterar a versão minima do android para a 18 por que o plugin flutter_secure_storage não é compativel com versões anteriores que essa

### :gear: Ubuntu Setup

precisei rodar no vs-Code
Para fazer a instalação do plugin flutter siga os seguintes comandos em versões superiores a 16.* do Linux

```sh
// instala o flutter e ja deixa ele em variaveis globais
sudo snap install flutter --classic

// saber o diretorio de instalação SDK
flutter sdk-path

// verificar se o flutter esta saudavel
flutter doctor

// para rodar no VS Code instalar as extensões
Dart, Flutter
```

### :gear: MacOS Setup

```sh
// Baixar e instalar a versão estavel Flutter_MacOs

// extrair o arquivo
unzip ~/Downloads/flutter_macos_1.22.6-stable.zip

// adicionar o flutter ao path apenas da sessão atual terminal
// acesse a pasta do flutter descompactada e use o comando PWD para saber o caminho completo da pasta
export PATH="$PATH:`pwd`/flutter/bin"

// rode flutter doctor para saber a saude do flutter
flutter doctor
```

### :gear: Criar chave do app

```sh
keytool -genkey -v -keystore D:\AndroidStudioProjects\orgalive\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

Senha: sua_senha
Nome: Tiago Bruckmann
organização: Orgalive
Nome da empresa: Orgalive
Cidade: Concórdia
UF: Santa Catarina
Código do pais: SC
```
