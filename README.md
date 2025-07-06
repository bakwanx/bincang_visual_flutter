# Bincang Visual Flutter

Bincang visual is a web app meeting platform based on Flutter and Go. it allows users to make meeting within a minute without cost, fees and no login required. Just create new meeting and ready to go!

This project is still under development.
But still, you can try for live demo [here](https://bakwanx.github.io/bincang-visual-web/)

## Prerequisite

This project requires backend and coturn service to run. So these are the links to get

- [Backend Golang](https://github.com/bakwanx/bincang-visual) for signaling
- [Coturn](https://github.com/coturn/coturn)

If you prefer to use public STUN/TURN server, you can skip Coturn and get public [STUN](https://gist.github.com/mondain/b0ec1cf5f60ae726202e) or TURN server on the Internet.

## Setup Instructions

To use this project, follow this steps:

1. **Clone the repository**: Clone this repository to your machine
2. **Clone service repository**: Clone and setup backend and coturn service
3. **Install Flutter**: Ensure you have installed Flutter SDK on your machine. If not, you can follow the instruction from [Flutter Doc](https://docs.flutter.dev/get-started/install) to set it up
4. **Setup**: .env
5. **Install Dependencies**: Navigate to the project directory and install the required dependencies
6. **Run the App:** Now, you can run the app on your connected device or emulator
