import 'dart:io';
import 'package:check_around_me/core/utils/color_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderWrapper extends StatefulWidget {
  final bool? isLoading;
  final Widget? view;

  const LoaderWrapper({Key? key, this.isLoading, this.view}) : super(key: key);

  @override
  _LoaderWrapperState createState() => _LoaderWrapperState();
}

class _LoaderWrapperState extends State<LoaderWrapper> {

  void _closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    _closeKeyboard();
    return Stack(
      children: [
        widget.view!,
        if (widget.isLoading ?? false)
          Scaffold(
            backgroundColor: Colors.transparent,
            body: IgnorePointer(
              ignoring: true,
              child: Container(
                color: const Color.fromRGBO(0, 17, 64, 0.76),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Platform.isIOS
                            ?  CupertinoActivityIndicator(radius: 20,color: "7F12C8".toColor(),)
                            : CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              "7F12C8".toColor(),
                          ),
                        ),
                      ),
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
