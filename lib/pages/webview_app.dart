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
            loadingProgress = 0.0;
            setState(() {});
          },
          onProgress: (progress) => setState(() {
            loadingProgress = progress.toDouble();
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
        backgroundColor: const Color(0xfff15625e),
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
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        weight: 100,
                        color: Colors.white,
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
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  _webViewController.currentUrl().toString(),
                  overflow: TextOverflow.ellipsis,
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
                    color: const Color(0xfff15625e),
                    value: loadingProgress as double,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
