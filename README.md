# **Dog Browser App**

## **Descrição**
O **Dog Browser App** é um aplicativo Flutter desenvolvido para listar raças de cães, utilizando a [The Dog API](https://thedogapi.com) para exibir informações e imagens. O app suporta navegação entre telas, salvamento de dados localmente para acesso offline e utiliza boas práticas de desenvolvimento.

---

## **Funcionalidades**
- Exibição de raças de cães em formato de grade (cards).
- Tela de detalhes com informações adicionais sobre a raça selecionada.
- Busca por raças através de um campo de texto.
- Paginação com botões "Next" e "Previous" para navegação entre as páginas.
- Dados armazenados localmente para acesso offline.
- Integração com a **The Dog API**.

---

## **Requisitos de Ambiente**
Antes de iniciar, certifique-se de que as seguintes ferramentas estão instaladas no seu ambiente:

1. **Flutter** (versão recomendada: 3.x ou superior).
2. **Android Studio** (para gerenciar o Android SDK).
3. **Xcode** (para rodar no iOS, apenas em macOS).
4. **Git** (para clonar o repositório).

---

## **Configuração do Ambiente**

### **1. Instalar Flutter**
- Siga as instruções oficiais: [Flutter Setup](https://docs.flutter.dev/get-started/install).

### **2. Instalar Android Studio**
- Certifique-se de instalar o Android SDK e criar um dispositivo emulador para testes.
- Configure as variáveis de ambiente:
  - **ANDROID_HOME**: caminho do Android SDK.

### **3. Instalar o Xcode (macOS apenas)**
- Para compilar no iOS, instale o Xcode pela App Store.
- Aceite as licenças:
  ```bash
  sudo xcodebuild -license accept
  ```

### **4. Instalar Dependências do Projeto**
- Clone o repositório:
  ```bash
  git clone https://github.com/Lincoln-Araujo/trabalho_final_flutter
  cd trabalho_final_flutter
  ```
- Instale as dependências:
  ```bash
  flutter pub get
  ```

### **5. Configurar a API Key**
- Substitua a string `YOUR_API_KEY_HERE` no código pelo valor da sua API Key obtida na [The Dog API](https://thedogapi.com).

---

## **Execução**

### **1. Executar em Modo Debug**
- Para rodar no emulador Android:
  ```bash
  flutter run
  ```
- Para rodar no iOS (macOS apenas):
  ```bash
  flutter run -d ios
  ```

### **2. Gerar APK para Produção**
- Compile o aplicativo para produção:
  ```bash
  flutter build apk --release
  ```
- O APK estará disponível em `build/app/outputs/flutter-apk/app-release.apk`.

---

## **Estrutura do Projeto**

```
lib/
│
├── models/
│   └── dog.dart          # Modelo da raça de cachorro e imagens.
│
├── screens/
│   ├── dogs_list_screen.dart   # Tela principal (lista de raças).
│   └── dog_details_screen.dart # Tela de detalhes da raça.
│
├── services/
│   └── database_service.dart   # Serviço para banco de dados local.
│
└── main.dart               # Arquivo principal do Flutter.
```

---

## **Testes**
### Executar testes unitários:
```bash
flutter test
```

---

## **Considerações de Segurança**
1. **Proteção da API Key:** A API Key é inserida diretamente no código durante o desenvolvimento. No futuro, recomenda-se utilizar um mecanismo para protegê-la, como o uso de arquivos `.env` ou serviços de configuração remota.
2. **Ofuscação do Código:** Caso seja necessário, pode-se habilitar a ofuscação no arquivo `proguard-rules.pro`.

---

## **Compatibilidade**
- **Android**: Suporte total.
- **iOS**: Suporte total.
- **Web**: Funcionalidades limitadas (não suporta banco de dados local).

---

**Desenvolvido por:** [Gabrielle Ramos da Silva, Lincoln Ferreira de Araujo, Lorena Freitas Corrêa e Vitor Teixeira Nardy Barrioni]

