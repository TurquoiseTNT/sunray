# Sunray for Jellyfin

Sunray Mobile - The Better (Unoffical) Jellyfin Client for Mobile Devices and supports Apple Carplay and Android Auto.
There will also be Sunray TV once Sunray is working.

## Project Structure

```
sunray/
├── lib/
│   ├── main.dart                            # Entry point - navigates to neccessary screen
│   ├── screens/
│   │   ├── home_screen.dart                 # Standard Home Screen
│   │   ├── login_screen.dart                # User Selection
│   │   └── server_setup_screen.dart         # Server Selection
│   ├── players/
│   │   ├── video.dart                       # Video (Movies & TV) Player
│   │   ├── audio.dart                       # Audio (Music) Player
│   │   ├── photos.dart                      # Photos and Video (Home Media) Player
│   │   ├── books.dart                       # E-book (Books) Reader
│   │   └── live.dart                        # Live TV (Tuner) Player
│   ├── services/
│   │   └── jellyfin_service.dart            # Jellyfin Connection Lib (CUSTOM MADE)
│   └── utils/
│       └── shared_preferences_helper.dart   # SharedPrefrences Translation Lib (CUSTOM MADE)
├── pubspec.yaml                             # Flutter Config
└── README.md                                # Documentation / App Spec
```

## Sunray Structure

### Sunray
Main Mobile App - Built in Flutter. Able to Talk to Auto & Carplay Apps.
#### Sunray Car (Bundled into Sunray Mobile)
Android Auto and Carplay Apps Built under Seperate Frameworks (Jetpack Compose & SwiftUI) but talk to Sunray Mobile app.
#### Sunray Desktop
Not Ideal and mostly used during development but since flutter has support, i'll release desktop builds (at least windows and linux)

### Sunray TV
A Flutter TV App for both Android TV and Apple TV platforms.
#### Sunray Web TV
A Web Compile of the TV App for LG WebOS and Samsung Tizen (Web Package)

## FAQ

Q: Wheres XXXX Platform?
A: If it's a TV platform then it depends if it supports web apps (reason why sunray isnt on roku). If it's mobile, Download the APK and install manually. Unless its cheap to put it on a certain store, it aint happening.

Q: When on Apple App Store?
A: Can you afford £100/year for an app that is free? (especially cos im only 13)

## Donations

Plz donate apple expensive nowadays (100/year)
(donations not yet setup)

## Releases

##### 0.1 (All Beta Versions) - Sunray Lizzard
##### 0.9 (Pre Release) - Sunray Chincilla
##### 1.0 (First Release) - Sunray Avocet

Betas, Pre-releases, etc: random pets
Releases get named after british birds: https://www.rspb.org.uk/birds-and-wildlife/a-z?page=3