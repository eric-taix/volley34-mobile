import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:v34/commons/loading.dart';

class MarkdownPage extends StatelessWidget {
  final String title;
  final String markdownAsset;
  final Widget? child;

  MarkdownPage(this.title, this.markdownAsset, {this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(markdownAsset),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: FutureBuilder(
                      future: PackageInfo.fromPlatform(),
                      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                        if (snapshot.hasData) {
                          String appName = snapshot.data?.appName ?? "?";
                          String version = snapshot.data?.version ?? "?";
                          String buildNumber = snapshot.data?.buildNumber ?? "?";
                          return RichText(
                            text: TextSpan(
                              text: "$appName ",
                              style: Theme.of(context).textTheme.headline4,
                              children: [
                                TextSpan(
                                    text: "  - version $version.$buildNumber",
                                    style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Version 0.0.0");
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: Markdown(
                      styleSheet: MarkdownStyleSheet(
                          h1: Theme.of(context).textTheme.headline5!.copyWith(height: 4),
                          h2: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(height: 3, fontSize: 18, fontWeight: FontWeight.bold)),
                      data: snapshot.data!,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return Center(child: Loading());
          }
        },
      ),
    );
  }
}

class Builder extends MarkdownElementBuilder {}
