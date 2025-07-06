# Bincang Visual Flutter

Bincang Visual is a web-based meeting platform built with Flutter and Go. It allows users to create meetings within seconds—no cost, no fees, and no login required. Simply create a new meeting, and you’re ready to go!

This project is still under development.
However, you can try the live demo [here](https://bakwanx.github.io/bincang-visual-web/)

## Prerequisite

This project requires a backend service and coturn server to run properly. Here are the required components:

- [Backend (Golang)](https://github.com/bakwanx/bincang-visual) for signaling
- [Coturn](https://github.com/coturn/coturn) for TURN/STUN services

If you prefer to use public STUN/TURN server, you can skip setting Coturn and instead use public servers

- [Public STUN Server](https://gist.github.com/mondain/b0ec1cf5f60ae726202e)
- or search for a public TURN server online.

## Setup Instructions

To setup and run this project, follow these steps:

1. **Clone the repository**: Clone this repository to your local machine
2. **Setup backend and Coturn services**: Clone and configure [backend repository](https://github.com/bakwanx/bincang-visual) and Coturn server as mentioned above
3. **Install Flutter**: Ensure you have installed Flutter SDK on your machine. If not, follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install)
4. **Setup**: Create .env in the project root and configure it as required
5. **Install Dependencies**: Navigate to the project directory and install the required dependencies:

```
flutter pub get
```

6. **Run the App:** Now, you can run the app on your connected device/ emulator or in the browser for web

```
flutter run
```
