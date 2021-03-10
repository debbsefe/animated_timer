import 'package:flutter/material.dart';

class CustomTimer extends StatefulWidget {
  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer>
    with TickerProviderStateMixin {
  static const Color red = Color(0xFFff6e6e);
  static const Color darkgray = Color(0xFF354051);
  AnimationController _controller;
  AnimationController _sizecontroller;

  Animation<double> _timerAnimation;
  Animation<double> _sizeAnimation;

  double animVal = 20;
  double sizeVal = 60;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );

    _sizecontroller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _timerAnimation = Tween<double>(begin: 0, end: 20).animate(_controller)
      ..addListener(() {
        setState(() {
          animVal = _timerAnimation.value;
        });
      });

    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 60, end: 80),
        weight: 70,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 80, end: 60),
        weight: 70,
      ),
    ]).animate(_sizecontroller)
      ..addListener(() {
        setState(() {
          sizeVal = _sizeAnimation.value;
          print(_sizeAnimation.value);
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _sizecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          backgroundColor: darkgray,
          body: Stack(
            children: [
              AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, _) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: _controller.value * height,
                        color: red,
                      ),
                    );
                  }),
              Center(
                child: Container(
                  child: Column(
                    children: [
                      Spacer(flex: 2),
                      Expanded(
                        flex: 2,
                        child: Text(
                          (animVal ?? 20).toStringAsFixed(0),
                          style: TextStyle(fontSize: 64, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            _sizecontroller.forward();

                            _controller.reverse(from: 1.0).whenComplete(() {
                              setState(() {
                                animVal = 20;
                              });
                            });
                          },
                          child: AnimatedBuilder(
                              animation: _sizecontroller,
                              builder: (context, _) {
                                return Container(
                                  width: _sizeAnimation.value,
                                  height: _sizeAnimation.value,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: red),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
