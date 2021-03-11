import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class CustomTimer extends StatefulWidget {
  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer>
    with TickerProviderStateMixin {
  static const Color red = Color(0xFFff6e6e);
  static const Color darkgray = Color(0xFF354051);
  AnimationController _controller;

  Animation<double> _timerAnimation;
  Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    final _provider =
        Provider.of<CurrentNumberNotifier>(context, listen: false);

    ///create controller in the initstate
    _controller = AnimationController(
      duration: Duration(seconds: (10)),
      vsync: this,
    );

    ///create default timer animation in the initstate, timer interval runs from 0.0 to 0.95
    _timerAnimation = Tween<double>(begin: 0, end: 10).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 0.95, curve: Curves.linear)));

    ///create default size Animation for the container in the initstate, timer interval runs from 0.95 to 1.0, so that the need for multiple controllers is eliminated
    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 60, end: 90),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 90, end: 60),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.95, 1.0, curve: Curves.linear)));

    ///addListener that updated animation value as it changes
    _controller.addListener(() {
      _provider.setNotifier(
          animeVal: _timerAnimation.value, number: _provider.selectedNumber);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          backgroundColor: darkgray,
          body: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, _) {
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        ///height changes when controller value is less than 0.95 so that the red container animation can be visible
                        height: _controller.value >= 0.95
                            ? 0
                            : _controller.value * height,
                        color: red,
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Column(
                          children: [
                            Spacer(flex: 2),
                            Expanded(
                              flex: 2,
                              child: NumberScroll(),
                            ),
                            Expanded(
                                flex: 1,
                                child: InkResponse(
                                  highlightShape: BoxShape.circle,
                                  radius: 100,
                                  onTap: () {
                                    final _provider =
                                        Provider.of<CurrentNumberNotifier>(
                                            context,
                                            listen: false);

                                    ///update controller duration and timer animation dynamically, duration is divided by two so the animation time is faster
                                    _controller.duration = Duration(
                                        seconds: _provider.selectedNumber ~/ 2);
                                    _timerAnimation = Tween<double>(
                                            begin: 0,
                                            end: (_provider.selectedNumber)
                                                .toDouble())
                                        .animate(CurvedAnimation(
                                            parent: _controller,
                                            curve: Interval(0.0, 0.95,
                                                curve: Curves.linear)));
                                    _controller
                                        .reverse(from: 1.0)
                                        .whenComplete(() {
                                      ///when animation is complete reset the state of the timer by setting the animation value to initial selected number
                                      _provider.setNotifier(
                                          animeVal: _provider.selectedNumber,
                                          number: _provider.selectedNumber);
                                    });
                                  },
                                  child: Container(
                                    width: _sizeAnimation.value,
                                    height: _sizeAnimation.value,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, color: red),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}

class NumberScroll extends StatefulWidget {
  @override
  _NumberScrollState createState() => _NumberScrollState();
}

class _NumberScrollState extends State<NumberScroll> {
  // ignore: unused_field
  int _currentPage = 1;
  final PageController _pageController =
      PageController(initialPage: 1, viewportFraction: 0.5);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    final _provider =
        Provider.of<CurrentNumberNotifier>(context, listen: false);

    ///onpagechange set the selectednumber notifier to numberSwitchcase value
    _provider.setNotifier(number: numberSwitchCase(index));
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        onPageChanged: _onPageChanged,
        controller: _pageController,
        itemCount: slideList.length,
        itemBuilder: (ctx, i) => SlideItem(i),
      ),
    );
  }
}

class Slide {
  final double number;

  Slide({@required this.number});
}

final slideList = [
  Slide(
    number: 10.0,
  ),
  Slide(
    number: 20.0,
  ),
  Slide(
    number: 30.0,
  ),
  Slide(
    number: 40.0,
  ),
  Slide(
    number: 50.0,
  ),
  Slide(
    number: 60.0,
  ),
];

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    final _provider =
        Provider.of<CurrentNumberNotifier>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(3.5),
      child: Column(
        children: <Widget>[
          Text(
            slideList[index].number != _provider.selectedNumber
                ? slideList[index].number.toStringAsFixed(0)
                : (_provider.animVal ?? slideList[index].number)
                    .toStringAsFixed(0),
            style: TextStyle(
                fontSize: slideList[index].number != _provider.selectedNumber
                    ? 64
                    : 96,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}

double numberSwitchCase(int index) {
  switch (index) {
    case 0:
      return 10.0;
    case 1:
      return 20.0;
    case 2:
      return 30.0;
    case 3:
      return 40.0;
    case 4:
      return 50.0;
    case 5:
      return 60.0;
      break;
    default:
      return 20.0;
  }
}
