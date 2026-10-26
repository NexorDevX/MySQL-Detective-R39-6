# MySQL Detective R39-6

**Standalone MySQL connection diagnostic tool for SA-MP and CRMP servers.**

Developed by [NexorDevX](https://github.com/NexorDevX).

## Features

- MySQL R39-6 connection diagnostics
- Connection status reporting
- MySQL error code output
- Diagnostic logging

## Requirements

- SA-MP or compatible CRMP server
- MySQL R39-6 plugin
- Pawn compiler

## Installation

1. Download the source code.
2. Configure your MySQL connection settings.
3. Compile `mysql_detective.pwn`.
4. Install the compiled AMX file in your server's `gamemodes` directory.
5. Ensure the MySQL plugin is configured in `server.cfg`.
6. Start the server and check the logs.

## Configuration

Configure the following connection parameters in the source code:

- Host
- Username
- Password
- Database
- Port

Use the connection details provided by your hosting provider.

## Author

**NexorDevX**

GitHub: https://github.com/NexorDevX
