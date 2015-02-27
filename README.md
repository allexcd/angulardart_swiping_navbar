# angulardart_swiping_navbar

## Usage

- Clone it
- Open it in Dart Editor or Webstorm
- Use Pub Get to get dependencies

## Build the app using Phongeap Build

- Use Pub Build
- Create zip file with the content of build/web
- Upload zip file to Phonegap Build
- Install the app on mobile.

## Build the app using Grunt and upload it to Phonegap Build

- Open gruntfile.js. Add appID (you can find it on Phonegap Build. You need to upload the app first and after that you can use this Grunt script),
add your adobe user name and adobe login password.
- Go to clone root directory and issue: npm install. Wait untill all dependencies are downloaded into the project under /node_modules directory.
- Now type: start_grunt. Grunt tasks will be run one by one and the app will be deployed to Phonegap Build (that is if you provided the right credentials for the last task)