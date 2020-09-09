import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'constants.dart';


class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingState();
  }
}

class SettingState extends State<Settings> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("请输入uid： "),
                Expanded(
                  flex: 1,
                  child: CupertinoTextField(
                    placeholder: "请输入uid",
                    keyboardType: TextInputType.phone,
                    onChanged: (uid) {
                      Constants.localUid = uid;
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("请输入sid： "),
                Expanded(
                  flex: 1,
                  child: CupertinoTextField(
                    placeholder: "请输入sid",
                    keyboardType: TextInputType.phone,
                    onChanged: (sid) {
                      Constants.sid = sid;
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('是否手动拉流'),
                Checkbox(
                  value: Constants.pullRemoteStream,
                  onChanged: (bool value) {
                    Constants.pullRemoteStream = value;
                    setState(() {

                    });
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('拉流是否重复操作'),
                Checkbox(
                  value: Constants.isPullRepeat,
                  onChanged: (bool value) {
                    Constants.isPullRepeat = value;
                    setState(() {

                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
  }
}
