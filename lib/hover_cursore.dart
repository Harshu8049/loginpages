import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DragCircle extends StatefulWidget {
  const DragCircle({super.key});

  @override
  State<DragCircle> createState() => _DragCircleState();
}

class _DragCircleState extends State<DragCircle>
    with SingleTickerProviderStateMixin {
  bool dragStart = false;
  bool dragStartpointer = false;
  late AnimationController _controller;
  final List<Offset> _trailBlack = [];
  final List<Offset> _trailGreen = [];
  final List<Offset> _trailYellow = [];
  Offset _pointer = const Offset(120, 350);
  final Color _blackColor = Colors.blue;
  final Color _greenColor = Colors.green;
  final Color _yellowColor = Colors.yellow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        _updateTrail();
        setState(() {});
      });
    _controller.repeat();
  }

  static const int maxTrailLength = 1;
  void _updateTrail() {
    if (_trailBlack.length >= maxTrailLength) {
      _trailBlack.removeAt(0);
    }
    if (_trailGreen.length >= maxTrailLength) {
      _trailGreen.removeAt(0);
    }
    if (_trailYellow.length >= maxTrailLength) {
      _trailYellow.removeAt(0);
    }
    _trailBlack.add(_pointer - const Offset(-23, -26));
    _trailGreen.add(_pointer - const Offset(-43, -36));
    _trailYellow.add(_pointer - const Offset(-63, -51));
  }

  void _updatePointer(Offset offset) {
    setState(() {
      _pointer = offset;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(1),
        height: Get.height - 20,
        width: Get.width - 20,
        child: Stack(children: [
          GestureDetector(
            onPanEnd: (details) async {
              await Future.delayed(const Duration(milliseconds: 800));
              _trailBlack.clear();
              _trailGreen.clear();
              _trailYellow.clear();
              setState(() {
                dragStartpointer = false;
              });
            },
            onPanStart: (details) {
              setState(() {
                _pointer = Offset(
                    details.globalPosition.dx, details.globalPosition.dy);

                dragStartpointer = true;
              });
            },
            onPanUpdate: (details) {
              _updatePointer(details.globalPosition);
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: TrailPainter(_trailBlack, _trailGreen, _trailYellow,
                  _blackColor, _greenColor, _yellowColor),
            ),
          ),
          Positioned(
            left: _pointer.dx,
            top: _pointer.dy,
            child: GestureDetector(
              onPanEnd: (details) async {
                await Future.delayed(const Duration(milliseconds: 600));
                _trailBlack.clear();
                _trailGreen.clear();
                _trailYellow.clear();
                setState(() {
                  dragStart = false;
                });
              },
              onPanStart: (details) {
                setState(() {
                  _pointer = Offset(
                      details.globalPosition.dx, details.globalPosition.dy);

                  dragStart = true;
                });
              },
              onPanUpdate: (details) {
                _updatePointer(details.globalPosition);
              },
              child: dragStart || dragStartpointer
                  ? Container()
                  : Stack(children: [
                      AnimatedContainer(
                        curve: Curves.fastEaseInToSlowEaseOut,
                        duration: const Duration(seconds: 5),
                        padding: const EdgeInsets.all(1),
                        height: 80,
                        width: 80,
                      ),
                      Positioned(
                          top: 20,
                          left: 20,
                          bottom: 20,
                          right: 20,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.blue, width: 1.0)),
                          )),
                      Positioned(
                          top: 24,
                          left: 24,
                          bottom: 24,
                          right: 24,
                          child: AnimatedContainer(
                            curve: Curves.bounceOut,
                            duration: const Duration(seconds: 5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.green, width: 1.0)),
                          )),
                      Positioned(
                          top: 28,
                          left: 28,
                          bottom: 28,
                          right: 28,
                          child: AnimatedContainer(
                            curve: Curves.bounceOut,
                            duration: Duration(seconds: 5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.yellow, width: 1.0)),
                          ))
                    ]),
            ),
          )
        ]),
      ),
    );
  }
}

class TrailPainter extends CustomPainter {
  final List<Offset> trailBlack;
  final List<Offset> trailGreen;
  final List<Offset> trailYellow;
  final Color blackColor;
  final Color greenColor;
  final Color yellowColor;

  TrailPainter(this.trailBlack, this.trailGreen, this.trailYellow,
      this.blackColor, this.greenColor, this.yellowColor);

  @override
  void paint(Canvas canvas, Size size) {
    _paintTrail(canvas, trailBlack, blackColor);
    _paintTrail(canvas, trailGreen, greenColor);
    _paintTrail(canvas, trailYellow, yellowColor);
  }

  void _paintTrail(Canvas canvas, List<Offset> trail, Color color) {
    if (trail.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(trail[0].dx, trail[0].dy);

    for (int i = 1; i < trail.length - 1; i++) {
      Offset currentPoint = trail[i];
      Offset nextPoint = trail[i + 1];
      Offset midPoint = Offset(
        (currentPoint.dx + nextPoint.dx) / 2,
        (currentPoint.dy + nextPoint.dy) / 2,
      );
      path.quadraticBezierTo(
          currentPoint.dx, currentPoint.dy, midPoint.dx, midPoint.dy);
      paint.strokeWidth = 0.4 * (trail.length - i);
      canvas.drawPath(path, paint);
      path.moveTo(midPoint.dx, midPoint.dy);
    }

    // Draw the last segment
    path.lineTo(trail.last.dx, trail.last.dy);
    paint.strokeWidth = 0.4 * (trail.length);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
