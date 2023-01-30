# CapsLockNoDelay
Removes annoying delay when pressing the caps lock on Mac OS.

Confirmed working on MacOS Ventura 13.0

# Install

### Manual

Download from [releases](https://github.com/gkpln3/CapsLockNoDelay/releases) or compile from source.

Copy CapsLockNoDelay.app to `/Applications` folder.

### Homebrew

To install it using Homebrew, open the Terminal app and type:
```bash
brew install --cask capslocknodelay
```

### Usage

Go to `System Preferences` -> `General` -> `Login Items`, add `CapsLockNoDelay.app` to the list.

<img width="600" alt="Login Items" src="https://user-images.githubusercontent.com/8081679/207524899-e5b60ff3-cec2-416d-8563-a85d00cd5101.png">


Go to `System Preferences` -> `Security & Privacy` -> `Privacy` -> `Accessability` -> Check `CapsLockNoDelay.app` -> `Input Monitoring` -> Check `CapsLockNoDelay.app` (if present).

<img width="600" alt="Accessibility settings" src="https://user-images.githubusercontent.com/8081679/118651850-a13a8b00-b7ee-11eb-94cc-8fa999fc49a9.png">

You won't see any settings / GUI, the app is running in the background (you can see it in Activity Monitor).
