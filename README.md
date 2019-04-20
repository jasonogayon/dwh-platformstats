# PROJECT PLATFORM-STATS #

A V7 Platform Tracker mobile app, powered by Flutter

___

## Development Environment Overview

1. [Install prerequisites](#install-prerequisites)
2. [Create a Platform-Stats project](#create-a-platform-stats-project)
3. [Clone project source code](#clone-project-source-code)
4. [Run project](#run-project)
___

## Install prerequisites

Please make sure that you have the following dependencies installed in your machine:

* [Git](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Flutter](https://flutter.io/get-started/install/)
* [Android Studio](https://developer.android.com/studio/)
* [Visual Studio Code](https://code.visualstudio.com/download)

Check `Flutter` installation by running the following command:

~~~~
flutter doctor -v
~~~~

Note: On Windows you may have to add the `flutter\bin` directory to your PATH in order for the `flutter` command to work globally.

## Create a Platform-Stats project

Run the following on a directory where you want the project to reside. This will create a `platformstats` directory there.

~~~~
flutter create platformstats
~~~~

## Clone project source code

Run:

~~~~
git clone git@bitbucket.org:jasonogayon/platform-stats.git
~~~~

While inside the root project directory, also run the following command to install project dependencies:

~~~~
flutter packages get
~~~~

## Clone project source code

Run project by:

~~~~
flutter run
~~~~

or by pressing `F5` on Visual Studio Code. Of course you'll need a mobile device (or an emulated mobile device) to run the project on.

---
