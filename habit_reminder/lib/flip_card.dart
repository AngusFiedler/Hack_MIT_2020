library flip_card;

import 'dart:math';
import 'package:flutter/material.dart';

enum FlipDirection {
  VERTICAL,
  HORIZONTAL,
}

typedef FlipCallBack = void Function(int index, bool completed);
typedef OnHoldCallback = void Function(int index);

class AnimationCard extends StatelessWidget {
  AnimationCard({this.child, this.animation, this.direction});

  final Widget child;
  final Animation<double> animation;
  final FlipDirection direction;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        var transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        if (direction == FlipDirection.VERTICAL) {
          transform.rotateX(animation.value);
        } else {
          transform.rotateY(animation.value);
        }
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}

typedef void BoolCallback(bool isFront);

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;

  /// The amount of milliseconds a turn animation will take.
  final int speed;
  final FlipDirection direction;
  final VoidCallback onFlip;
  final BoolCallback onFlipDone;

  final FlipCallBack onTap;
  final OnHoldCallback onHold;

  final int cardIndex;

  final bool onFront;

  final bool flipOnTouch;

  const FlipCard(
      {Key key,
      @required this.front,
      @required this.back,
      @required this.cardIndex,
      this.speed = 500,
      this.onFlip,
      this.onFlipDone,
      this.onFront,
      this.onTap,
      this.onHold,
      this.direction = FlipDirection.HORIZONTAL,
      this.flipOnTouch = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FlipCardState();
  }
}

class FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _frontRotation;
  Animation<double> _backRotation;

  bool isFront = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: widget.speed), vsync: this);
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (widget.onFlipDone != null) widget.onFlipDone(isFront);
      }
    });
    // If the flip card is supposed to be on the completed side, ie back then flip the card
    if (!widget.onFront) {
      controller.forward();
      setState(() {
        isFront = !isFront;
      });
    }
  }

  void toggleCard() {
    if (widget.onFlip != null) {
      widget.onFlip();
    }
    if (isFront) {
      widget.onTap(widget.cardIndex,false);
      controller.forward();
    } else {
      widget.onTap(widget.cardIndex,true);
      controller.reverse();
    }

    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        _buildContent(front: true),
        _buildContent(front: false),
      ],
    );

    // if we need to flip the card on taps, wrap the content
    if (widget.flipOnTouch) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: toggleCard,
        onLongPress: () {widget.onHold(widget.cardIndex);},
        child: child,
      );
    }
    return child;
  }

  Widget _buildContent({@required bool front}) {
    // pointer events that would reach the backside of the card should be
    // ignored
    return IgnorePointer(
      // absorb the front card when the background is active (!isFront),
      // absorb the background when the front is active
      ignoring: front ? !isFront : isFront,
      child: AnimationCard(
        animation: front ? _frontRotation : _backRotation,
        child: front ? widget.front : widget.back,
        direction: widget.direction,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
