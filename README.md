# CapsLockNoDelay
Removes annoying delay when pressing the caps lock on Mac OS.

Confirmed working on MacOS Sequoia 15.6

## Built-in Alternative
Turns out there is a built-in alternative for deactivating the CapsLockDelay.
Thanks @decodism for pointing that out!
```bash
hidutil property --set '{"CapsLockDelayOverride":0}'
```
Just run this, no other steps are needed.

If that doesn't work, continue with the regular installation.

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

1. Go to `System Preferences` -> `General` -> `Login Items`, add `CapsLockNoDelay.app` to the list.

<img width="600" alt="Login Items" src="https://user-images.githubusercontent.com/8081679/207524899-e5b60ff3-cec2-416d-8563-a85d00cd5101.png">



2. Go to `System Preferences` -> `Privacy & Security` -> `Accessibility` , add `CapsLockNoDelay.app` to the list (if not already present), check `CapsLockNoDelay.app`.

<img width="600" alt="Accessibility settings NEW" img src="./Screenshot.png">

In older versions of MacOS, go to `System Preferences` -> `Security & Privacy` -> `Privacy` -> `Accessibility` -> Check `CapsLockNoDelay.app` -> `Input Monitoring` -> check `CapsLockNoDelay.app` (if present).

<img width="600" alt="Accessibility settings" src="https://user-images.githubusercontent.com/8081679/118651850-a13a8b00-b7ee-11eb-94cc-8fa999fc49a9.png">

You will not see any settings / GUI, the app is running in the background (you can see it in Activity Monitor).
