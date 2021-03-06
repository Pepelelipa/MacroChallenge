![Purple Notebook's Icon][Icon]

## Purple Notebook
An application designed to be as efficient and clean as possible for students who need to take **notes** during classes without loosing **focus**.

Inspired by all the top current note takin apps, we decided to take it to the next level. Organised, intuitive, clean and with just what you need to make the most out of your classes.

It uses our own native markdown feature to ensure top notch elements for shortcuts that we're all already used to, and also relies on an intuitive and easy-to-use system that ensures that everyone has the best experience when formatting their texts. It also offers the user the possibility to create text boxes and image boxes to customise their notes as they see fit.

**Made by students, for students.**

## Image to text
We wanted to make sure our user wouldn't have to rewrite things. Importing Apple's **Vision** framework, we are able to recognise texts in images and leave it to the user to decide whether to use it as an image or import it as a text.

## Data Persistence
We split our functionalities so that the data storage is in a separate framework which not only makes it excellent to use when dealing with future extensions and a macOS version, it also makes it simpler to whomever needs access to it.

Right now it relies on **CoreData** technology to store all your data locallly in the device, and is also being prepared to go online using **CloudKit**, to ensure **cross-device information.**

## Code Maintanability
Since it’s a big project and we decided to make the best out of it, we would've gone crazy thinking about the code maintenance of it all. That's why we also documented most of our code when necessary and created a **diagram** of everything we've done so far not to get lost which can be found always updated [here.]

### Color and Relation Guide
![Color and Relation Guide][Color and Relation Guide]
### Database Diagram
![Database Framework Diagram][Database Diagram]
### App Diagram
![App Diagram][App Diagram]

[Icon]: https://github.com/Pepelelipa/MacroChallenge/blob/dev/MacroPepelelipa/MacroPepelelipa/Assets.xcassets/AppIcon.appiconset/icon_32x32%402x.png "Icon"
[here.]: https://miro.com/app/board/o9J_kny0VDI=/ "Miro's Documentation"
[Color and Relation Guide]: https://github.com/Pepelelipa/MacroChallenge/blob/dev/Color_and_Relation_Guide.jpg "Color and Relation Diagram"
[Database Diagram]: https://github.com/Pepelelipa/MacroChallenge/blob/dev/Database_Diagram.jpg "Database Class Diagram"
[App Diagram]: https://github.com/Pepelelipa/MacroChallenge/blob/dev/Purple_Notebook_Diagram.jpg "App Diagram"
