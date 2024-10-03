
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String loadingMessage;

  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    required this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // The content of the page
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Center(
                child: Container(
                  width: 250,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.green,strokeWidth:2,)),
                        SizedBox(width: 20),
                        Text(
                          loadingMessage,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
