// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _webViewController = WebViewController();
  double? loadingProgress;
  String? currentPage;
  bool backAction = false;
  bool forwardAction = false;
  initializeWebView() {
    _webViewController
      ..loadRequest(
        Uri.parse("https://github.com"),
      )
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingProgress = 0.0;
            });
          },
          onProgress: (progress) => setState(() {
            loadingProgress = progress.toDouble();
          }),
          onPageFinished: (url) => setState(() async {
            setState(() {
              currentPage = url;
              loadingProgress = null;
            });

            if (await _webViewController.canGoBack()) {
              setState(() {
                backAction = true;
              });
            } else {
              setState(() {
                backAction = false;
              });
            }

            // check forward
            if (await _webViewController.canGoForward()) {
              setState(() {
                forwardAction = true;
              });
            } else {
              setState(() {
                forwardAction = false;
              });
            }
          }),
        ),
      );
  }

  @override
  void initState() {
    initializeWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: const Color.fromARGB(255, 9, 9, 9),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (await _webViewController.canGoBack()) {
                          await _webViewController.goBack();
                        }
                        return;
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        weight: 100,
                        color: backAction ? Colors.white : Colors.transparent,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _webViewController.reload();
                      },
                      child: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (await _webViewController.canGoForward()) {
                          await _webViewController.goForward();
                        }
                        return;
                      },
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color:
                            forwardAction ? Colors.white : Colors.transparent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  currentPage != null ? currentPage.toString() : "",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: PopScope(
        canPop: false,
        child: Stack(
          children: [
            WebViewWidget(controller: _webViewController),
            loadingProgress != null
                ? LinearProgressIndicator(
                    color: Colors.white,
                    value: loadingProgress as double,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
