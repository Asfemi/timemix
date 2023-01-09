import 'dart:io' show Platform;

class Secret {
  static const ANDROID_CLIENT_ID = "565278034841-96emjjgi2tq9su8mkcm14deguhludcjd.apps.googleusercontent.com";
  //todo: setup ios path and add the ios client secret
  static const IOS_CLIENT_ID = "<enter your iOS client secret>";
  static String getId() => Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
}