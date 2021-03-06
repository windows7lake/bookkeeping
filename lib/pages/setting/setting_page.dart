import 'package:bookkeeping/l10n/intl_localizations.dart';
import 'package:bookkeeping/pages/setting/locale_controller.dart';
import 'package:bookkeeping/pages/setting/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  ThemeController themeController;
  LocaleController localeController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 初始化controller
    final themeController = Provider.of<ThemeController>(context);
    if (themeController != this.themeController) {
      this.themeController = themeController;
      this.themeController.init();
    }
    final localeController = Provider.of<LocaleController>(context);
    if (localeController != this.localeController) {
      this.localeController = localeController;
      this.localeController.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(IntlLocalizations.of(context).titleSetting),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          child: renderListView(context),
        ),
      ),
    );
  }

  Widget renderListView(BuildContext context) {
    var themeColor = Theme.of(context).accentColor;
    return Column(children: <Widget>[
      SizedBox(height: 10),

      /// 字体切换
      Material(
        color: Theme.of(context).cardColor,
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(IntlLocalizations.of(context).settingFont),
              Text(
                ThemeController.fontName(
                  themeController.model.themeFontIndex,
                  context,
                ),
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
          leading: Icon(Icons.font_download, color: themeColor),
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: themeController.model.fontValueList.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                  value: index,
                  onChanged: (index) {
                    themeController.switchFont(index);
                  },
                  groupValue: themeController.model.themeFontIndex,
                  title: Text(ThemeController.fontName(index, context)),
                );
              },
            ),
          ],
        ),
      ),
      SizedBox(height: 10),

      /// 语言切换
      Material(
        color: Theme.of(context).cardColor,
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(IntlLocalizations.of(context).settingLanguage),
              Text(
                LocaleController.localeName(
                  localeController.model.localeIndex,
                  context,
                ),
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
          leading: Icon(Icons.public, color: themeColor),
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: localeController.model.localeValueList.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                  value: index,
                  onChanged: (index) {
                    localeController.switchLocale(index);
                  },
                  groupValue: localeController.model.localeIndex,
                  title: Text(LocaleController.localeName(index, context)),
                );
              },
            ),
          ],
        ),
      ),
      SizedBox(height: 10),

      /// 主题切换
      Material(
        color: Theme.of(context).cardColor,
        child: ExpansionTile(
          title: Text(IntlLocalizations.of(context).settingTheme),
          leading: Icon(Icons.color_lens, color: themeColor),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: <Widget>[
                  ...Colors.primaries.map((color) {
                    return Material(
                      color: color,
                      child: InkWell(
                        onTap: () {
                          themeController.switchTheme(color: color);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                        ),
                      ),
                    );
                  }).toList(),
                  Material(
                    child: InkWell(
                      onTap: () {
                        var brightness = Theme.of(context).brightness;
                        themeController.switchRandomTheme(
                            brightness: brightness);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: themeColor),
                        ),
                        width: 40,
                        height: 40,
                        child: Text(
                          "?",
                          style: TextStyle(fontSize: 20, color: themeColor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
