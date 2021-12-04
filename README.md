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
    <li>firebase_crashlytics</li>
    <li>font_awesome_flutter</li>
    <li>firebase_analytics</li>
    <li>cloud_firestore</li>
    <li>cupertino_icons</li>
    <li>google_nav_bar</li>
    <li>firebase_core</li>
    <li>firebase_auth</li>
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

Cores utilizadas no icone e na splash screen:

- Vermelho padrão do app ![#E42924](https://via.placeholder.com/15/E42924/000000?text=+) `#E42924`
- Cinza padrão app ![#546e7a](https://via.placeholder.com/15/546e7a/000000?text=+) `#546e7a`

Cores utilizadas no app:

- Azul campos de texto: ![#E8F0FE](https://via.placeholder.com/15/E8F0FE/000000?text=+) `#E8F0FE`
- Branco fumaça: ![#F5F5F5](https://via.placeholder.com/15/F5F5F5/000000?text=+) `#F5F5F5`


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
keytool -genkey -v -keystore c:\Users\tiago\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

Senha: TcholaOrgaliveDev2021
Nome: Tiago Bruckmann
organização: Orgalive
Nome da empresa: Orgalive
Cidade: Concórdia
UF: Santa Catarina
Código do pais: SC
```
