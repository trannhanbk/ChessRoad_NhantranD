import 'package:chessroad_app/common/color-constants.dart';
import 'package:chessroad_app/common/config.dart';
import 'package:chessroad_app/common/toast.dart';
import 'package:chessroad_app/services/audios.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _version = 'Ver 1.00';

  @override
  void initState() {
    super.initState();
    loadVersionInfo();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle headerStyle =
        TextStyle(color: ColorConstants.Secondary, fontSize: 20.0);
    final TextStyle itemStyle = TextStyle(color: ColorConstants.Primary);

    return Scaffold(
      backgroundColor: ColorConstants.LightBackground,
      appBar: AppBar(
          title: Text(
        // '设置',
        'CÀI ĐẶT',
      )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 16),
            Text(
              // "声音",
              'Âm thanh',
              style: headerStyle,
            ),
            Card(
              color: ColorConstants.BoardBackground,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    activeColor: ColorConstants.Primary,
                    value: Config.bgmEnabled,
                    title: Text(
                      // "背景音乐",
                      'Nhạc nền',
                      style: itemStyle,
                    ),
                    onChanged: switchMusic,
                  ),
                  _buildDivider(),
                  SwitchListTile(
                    activeColor: ColorConstants.Primary,
                    value: Config.toneEnabled,
                    title: Text(
                      // "提示音效",
                      'Âm thanh bàn phím',
                      style: itemStyle,
                    ),
                    onChanged: switchTone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              // "关于",
              'Thông tin',
              style: headerStyle,
            ),
            Card(
              color: ColorConstants.BoardBackground,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      // "关于「棋路」",
                      'Giới thiệu về phiên bản ứng dụng',
                      style: itemStyle,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(_version ?? ''),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: ColorConstants.Secondary,
                        ),
                      ],
                    ),
                    onTap: showAbout,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60.0),
          ],
        ),
      ),
    );
  }

  Future<void> loadVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'Version ${packageInfo.version}-${packageInfo.buildNumber}';
    });
  }

  switchMusic(bool value) async {
    setState(() {
      Config.bgmEnabled = value;
    });

    if (Config.bgmEnabled) {
      Audios.loopBgm('bg_music.mp3');
    } else {
      Audios.stopBgm();
    }
    Config.save();
  }

  switchTone(bool value) {
    setState(() {
      Config.toneEnabled = value;
    });
    Config.save();
  }

  showAbout() {
    //
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
            // '关于「棋路」',
            'Giới thiệu về ứng dụng',
            style: TextStyle(
              color: ColorConstants.Primary,
            )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5),
            Text(
              // '特别感谢贺照云老师提供的教程与素材！',
              'Cảm ơn các bạn đã sửu dụng trò chơi. Ứng dụng được phát triển bởi Trần Đình Nhân.',
              style: TextStyle(fontFamily: ''),
            ),
            SizedBox(height: 15),
            Text(
              // '版本',
              'Phiên bản',
              style: TextStyle(fontFamily: ''),
            ),
            Text('$_version', style: TextStyle(fontFamily: '')),
            SizedBox(height: 15),
            Text(
              // '个人博客',
              'Blog cá nhân',
              style: TextStyle(fontFamily: ''),
            ),
            GestureDetector(
              onTap: () async {
                var url = 'https://nhantran.fun';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  Clipboard.setData(ClipboardData(text: url));
                  Toast.toast(context,
                      // message: '网址已复制！',
                      message: 'Đã sao chép URL! ');
                }
              },
              child: Text(
                "https://nhantran.fun",
                style: TextStyle(fontFamily: '', color: Colors.blue),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(child: Text(
              // '好的',
              'Cảm ơn bạn!'), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 1.0,
      color: ColorConstants.LightLine,
    );
  }
}
