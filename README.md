# Falling Blocks
[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png"
    alt="Get it on F-Droid"
    height="80">](https://f-droid.org/packages/org.sajeg.fallingblocks/)


- <a href="https://github.com/Sajeg/falling-blocks/blob/main/README.md#overview">Overview</a>
- <a href="https://github.com/Sajeg/falling-blocks/blob/main/README.md#features">Features</a>
- <a href="https://github.com/Sajeg/falling-blocks/blob/main/README.md#screenshots">Screenshots</a>
- <a href="https://github.com/Sajeg/falling-blocks/blob/main/README.md#installation">Installation</a>
- <a href="https://github.com/Sajeg/falling-blocks/blob/main/README.md#speed-calculation">Speed calculation</a>
- <a href="https://github.com/Sajeg/falling-blocks/blob/main/README.md#issues">Issues</a>
- <a href="https://github.com/Sajeg/falling-blocks/blob/main/README.md#contact">Contact</a>

## Overview
Falling Blocks is a small mobile Game, where you are a block. There are other blocks, which are falling down, and you're not allowed to touch the blocks if your block has an other color. Made with <a href="https://github.com/godotengine/godot">Godot Engine</a>. 

## Features
- 2 different game modes
- modern Design
- Open-Source
- free
- adfree

## Screenshots
<img src="https://raw.githubusercontent.com/Sajeg/falling-blocks/main/fastlane/metadata/android/en-US/images/phoneScreenshots/1.jpg" title="screenshots_1" alt="Screenshot 1" height="240px" width="135px"><img src="https://raw.githubusercontent.com/Sajeg/falling-blocks/main/fastlane/metadata/android/en-US/images/phoneScreenshots/2.jpg" title="screenshots_2" alt="Screenshot 2" height="240px" width="135px"><img src="https://raw.githubusercontent.com/Sajeg/falling-blocks/main/fastlane/metadata/android/en-US/images/phoneScreenshots/3.jpg" title="screenshots_3" alt="Screenshot 3" height="240px" width="135px"><img src="https://raw.githubusercontent.com/Sajeg/falling-blocks/main/fastlane/metadata/android/en-US/images/phoneScreenshots/4.jpg" title="screenshots_4" alt="Screenshot 4" height="240px" width="135px"><img src="https://raw.githubusercontent.com/Sajeg/falling-blocks/main/fastlane/metadata/android/en-US/images/phoneScreenshots/5.jpg" title="screenshots_5" alt="Screenshot 5" height="240px" width="135px">

## Installation
### Android
The recommend way is to use <a href="https://f-droid.org/packages/org.sajeg.fallingblocks/">F-Droid</a>
1. Download the .apk file from <a href="https://github.com/Sajeg/falling-blocks/releases">releases</a> or from <a href="https://sajeg.itch.io/falling-blocks">itch.io</a>.
2. Click on the downloaded file. If you become a warning "For you security, your phone is not allowed to install unknown apps from this source.", go to settings and allow install unknown apps from this source.
3. Click on install and Android will automatically install this app.

### Linux
1. Download the .zip file from <a href="https://github.com/Sajeg/falling-blocks/releases">releases</a> or from <a href="https://sajeg.itch.io/falling-blocks">itch.io</a>.
2. Extrakt this file.
3. run the .86_64 file.

### Windows
1. Download the .zip file from <a href="https://github.com/Sajeg/falling-blocks/releases">releases</a> or from <a href="https://sajeg.itch.io/falling-blocks">itch.io</a>.
2. Extrakt this file.
3. run the .exe file.

## Speed calculation
This is for those interested in how the speed is calculated in relation to the score. $x$ is the score.  
This function is for $0 < x < 4000$:
$$f(x) = 0.0000000000192 * x^4 - 0.000000165 * x^3 + 0.00041083333333 * x^2 + 0.005 * x + 260$$
and this is the function for $4000 < x$:
$$g(x) = 5 * \sqrt{x - 4000} + 1340$$ 

## Issues
A Issue, that some reported, is that they can't uninstall the Game. In this case please try it with ADB. This would be the command to uninstall the game with adb: ``` adb uninstall org.sajeg.fallingblocks ```.  
I am very sorry that this happens sometimes, however I never had this Problem and therefore I don't know how I could fix this bug.

## Contact
If you have feedback or anything else you can always open an issue, write me on Discord: **Sajeg** or write me an email <a href="mailto:jfxg@posteo.de">sajeg@posteo.de</a>
