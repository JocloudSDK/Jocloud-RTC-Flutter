import 'package:flutter/material.dart';
import 'flutterthunder.dart';
import 'base_model.dart';

class ThunderRenderWidget extends StatefulWidget {
  final String uid;
  //是否是预览
  final bool preview;
  //是否是本地视频画布，通常主播开播会使用到该字段
  final bool local;
  //视频渲染模式
  final VideoRenderMode mode;

  //setLocalVideoCanvas or setRemoteVideoCanvas 后回调
  final Function(String uid, bool local, VideoRenderMode mode) onCanvasDidSet;

  //setLocalVideoCanvas or setRemoteVideoCanvas 后回调
  final Function(VideoRenderMode mode) onScaleModeDidChanged;

  //销毁回调
  final Function(String uid, int viewId, bool local) onDispose;

  ThunderRenderWidget(this.uid,
      {this.mode = VideoRenderMode.FILL,
      this.local = false,
      this.preview = false,
      this.onCanvasDidSet,
      this.onScaleModeDidChanged,
      this.onDispose,
      Key key})
      : assert(uid != null),
        assert(mode != null),
        assert(local != null),
        assert(preview != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ThunderRenderWidgetState();
  }
}

class _ThunderRenderWidgetState extends State<ThunderRenderWidget> {
  Widget _nativeView;
  int _viewId;

  @override
  void initState() {
    super.initState();
    print("ThunderRenderWidget initState ${widget.uid}, ${widget.local}");
    _nativeView = FlutterThunder.createNativeView((viewId) {
      print("ThunderRenderWidget createNativeView ${widget.uid}, ${widget.local}");
      _viewId = viewId;
      _bindView();
    });
  }

  void _bindView() {
    print("ThunderRenderWidget setLocalVideoCanvas ${widget.uid}, ${widget.local}");
    if (widget.local) {
      FlutterThunder.setLocalVideoCanvas(widget.uid, _viewId, widget.mode);
      if (widget.preview) {
        FlutterThunder.startVideoPreview();
      }
    } else {
      FlutterThunder.setRemoteVideoCanvas(
          widget.uid, _viewId, widget.mode, null);
    }
    if (widget.onCanvasDidSet != null) {
      widget.onCanvasDidSet(widget.uid, widget.local, widget.mode);
    }
  }

  void _changeRenderMode() {
    if (widget.local) {
      FlutterThunder.setLocalCanvasScaleMode(widget.mode);
    } else {
      FlutterThunder.setRemoteCanvasScaleMode(
          widget.uid.toString(), widget.mode);
    }
    if (widget.onScaleModeDidChanged != null) {
      widget.onScaleModeDidChanged(widget.mode);
    }
  }

  @override
  void dispose() {
    //将原生view删除
    FlutterThunder.removeNativeView(_viewId);
    if (widget.preview) {
      FlutterThunder.stopVideoPreview();
    }
    if (widget.onDispose != null) {
      widget.onDispose(widget.uid, _viewId, widget.local);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(ThunderRenderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.uid != oldWidget.uid || widget.local != oldWidget.local) &&
        _viewId != null) {
      _bindView();
      return;
    }

    if (widget.mode != oldWidget.mode) {
      _changeRenderMode();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("ThunderRenderWidget build ${widget.uid}, ${widget.local}");
    return _nativeView;
  }
}
