# whatsThis
## Quench your curiosity by scanning an object with your camera, and find out what it is.

[GO TO Devpost](https://devpost.com/software/whatsthis)


### Inspiration

People started to enjoy outdoor activities and gatherings recently as more people are getting vaccinated. As much as we are getting used to the online, non-face-to-face environment, this painfully long period of various restrictions have triggered pandemic fatigue on countless people.

This is a time to relieve the stress; we get to enjoy the nature that's around us, like trees, flowers, animals, etc. The increasing frequency of exposure to the outdoor environments means the increase of curiosity of things we have not yet explored. Of course, we may have seen them online, but they do not appear 100% the same as on the internet.

We wanted to make a better outdoors experience, so we came up with the simple, yet powerful idea - object recognition app. With WhatsThis app, you can find out what the object you are looking at is, even if it's the very first time seeing the object, by simply turning on your camera. This way, you can skip all the tedious steps of going onto the internet, giving the description of its appearance, and searching all the results.


### What it does

WhatsThis is an iOS application that identifies objects with an image classification technique, featuring ResNet-50 convolutional neural network.

While you are scanning with your camera, this app captures objects that are within the camera view, and returns its analysis on what those objects are at the bottom of the screen, along with the accuracy of its classifications. This operation is done on a real-time basis, so whenever you turn your camera i.e. the camera viewport changes, the classifications returned at the bottom will change accordingly.

You also have an option to take an instant picture or to select an image from the gallery. The core functionality is the same where the app returns the classification of an object, this time with the static image instead of a real-time camera view.


### How we built it

As this is an iOS application, the development was done under Xcode environment, using Swift as a primary language. The app was built using Model-View-Controller design pattern, with the use of CoreML and Vision for ResNet-50 image classification integration.


### Challenges we ran into

We were new to the iOS development and Swift language itself, so learning a new language and platform came to us as a great challenge.

Xcode not only required updates on the app itself, but it also required the newest macOS update in order for Xcode to be compatible - this update took a very long time, which has significantly delayed our development procedure. The testing environment was quite limited as well, as some of our members did not have any iOS or macOS devices at all.


### Accomplishments that we're proud of

We have decided to challenge ourselves by trying a different type of development that we have not yet done previously. Both iOS and macOS are commonly used platforms, so we thought it would be worthwhile to try developing on those platforms.

As explained in "Challenges we ran into" section, picking up a new language was indeed very difficult, but at the same time it was very accomplishing, in a sense that we have built a fully functioning app after all the hardships.

ResNet-50 integration was also an accomplishment that we are proud of, since machine learning is a very widely known field, yet very difficult to grasp on.


### What we learned

Although we are not experts on machine learning, this project has definitely enlightened us on how to utilize machine learning libraries. Additionally, as much as it was a challenge, we have learned a lot about iOS development using Xcode and Swift language itself.


### What's next for whatsThis

1. Show classification analysis on multiple objects within the camera view


### Built With
- Swift
- Resnet50
- Xcode
