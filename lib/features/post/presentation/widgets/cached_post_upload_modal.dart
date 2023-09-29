import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/style/theme.dart';
import '../notifier/post_notifier.dart';

class CachedPostUploadModal extends StatefulWidget {
  final AppTheme? appTheme;
  final Size size;

  const CachedPostUploadModal({
    Key? key,
    required this.appTheme,
    required this.size,
  }) : super(key: key);

  @override
  _CachedPostUploadModalState createState() => _CachedPostUploadModalState();
}

class _CachedPostUploadModalState extends State<CachedPostUploadModal>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<double> _widthTween;
  late Animation<double> _heightTween;
  late Animation<double> _contentWidthTween;
  late Animation<double> _contentHeightTween;
  late Animation<double> _borderRadiusTween;
  late Animation<double> _paddingTween;
  late Animation<double> _opacityTween;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _widthTween = Tween<double>(
      begin: widget.size.width - 32,
      end: 36,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      });

    _heightTween = Tween<double>(
      begin: 82,
      end: 36,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      });

    _contentWidthTween = Tween<double>(
      begin: widget.size.width - 64,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      });

    _contentHeightTween = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      });

    _borderRadiusTween = Tween<double>(
      begin: 8,
      end: 35,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      });

    _paddingTween = Tween<double>(
      begin: 16,
      end: 4,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      });

    _opacityTween = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.decelerate,
    ))
      ..addListener(() {
        setState(() {});
      });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _isExpanded = false;
        _animationController!.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController?.stop();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isExpanded) {
          setState(() {
            _isExpanded = false;
          });
          _animationController!.forward();
        } else {
          setState(() {
            _isExpanded = true;
          });
          _animationController!.reverse();
        }
      },
      child: Container(
        padding: EdgeInsets.all(_paddingTween.value),
        margin: Platform.isIOS
            ? const EdgeInsets.symmetric(vertical: 32, horizontal: 16)
            : const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_borderRadiusTween.value),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        width: _widthTween.value,
        height: _heightTween.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isExpanded && _widthTween.value < 60)
              Center(
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
              ),
            Opacity(
              opacity: _opacityTween.value,
              child: Container(
                width: _contentWidthTween.value,
                height: _contentHeightTween.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_contentHeightTween.value > 40)
                      Consumer<PostNotifierImpl>(
                        builder: (ctx, state, _) {
                          return Text(
                            'Uploading cached data.... ${state.postsAmount}/${state.cachedPostsAmount}',
                            style: Theme.of(context).textTheme.titleLarge,
                          );
                        },
                      ),
                    if (_contentHeightTween.value >= 44) SizedBox(height: 16),
                    if (_contentHeightTween.value >= 44)
                      SizedBox(
                        width: _contentWidthTween.value,
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
