# Volley34

Application mobile pour le Volley34 

## Version béta

Pour tester la version béta, cliquez sur l'icone çi-après quand celui est vert (le build a réussi). En bas à gauche vous trouverez les différents artifacts pour Android et iOS

[![Codemagic build status](https://api.codemagic.io/apps/5e9a2bf718efc220e89ca590/5e9a2bf718efc220e89ca58f/status_badge.svg)](https://codemagic.io/apps/5e9a2bf718efc220e89ca590/5e9a2bf718efc220e89ca58f/latest_build)


## CodeMagic
  
Ce projet utilise [CodeMagic](https://codemagic.io/start/). CodeMagic est une solution cloud pour builder et déployer de façon continue des application Flutter ou mobile.  
This project uses [CodeMagic](https://codemagic.io/start/). CodeMagic is a continous integration and continous delivery platform for Flutter and mobile applications



## Contributions

Nous sommes à l'écoute de toutes vos idées, donc n'hésitez pas à créer un issue pour exprimer vos idées. 
Privilégiez des idées courtes qui se résument en quelques phrases.


## Exécution en local (développement)

Cette application utilise Google Maps Api. Cependant pour des raisons de sécurité, aucune clé n'est
stockée dans le code source (ces clés sont injectées au moment du build). Pour pouvoir lancer l'application
en mode développement, vous devez:

  - Pour Android et iOS: Créez une variable d'environnement `MAPS_API_KEY` et mettez dans cette variable la valeur de la clé.
  Cette variable d'environnement est utilisée au moment du build pour être injectée dans le fichier `Info.plist` pour iOS et dans
  `android/app/src/main/AndroidManisfest.xml` pour Android (via `android/app/build.gradle`)
  
  

