import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'model.dart';

typedef LabelledValueChanged<T, U> = void Function(T label, U value);
bool loaded = false;
SettingModel _settingModel;
AutovalidateMode _autoValidateMode = AutovalidateMode.onUserInteraction;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final GlobalKey<FormState> _themeKey = GlobalKey<FormState>();


final FocusNode _nameNode = FocusNode();
final FocusNode _descriptionNode = FocusNode();

class settingPage extends StatefulWidget{

  @override
  _settingPageState createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {

  @override
  Widget build(context){
    var orientation = MediaQuery.of(context).orientation;
    bool _showMaterialonIOS = true;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<ExampleFormState> _formWidgetKey =
    GlobalKey<ExampleFormState>();
    void showSnackBar(String label, dynamic value) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(label + ' = ' + value.toString()),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "설정",
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        leading:
        IconButton(
          icon: Icon(
            Icons.autorenew,
          ),
          color: Colors.black54,
          onPressed: () async {
            setState(() => loaded = false);
            _settingModel = SettingModel();
            await setState(() => loaded = true);
            //_formKey.currentState.reset();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
            ),
            color: Colors.black54,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ExampleForm(orientation, _showMaterialonIOS, _scaffoldKey,
          key: _formWidgetKey, onValueChanged: showSnackBar),
    );
  }
}

class ExampleForm extends StatefulWidget {
  const ExampleForm(
      this.orientation,
      this.showMaterialonIOS,
      this.scaffoldKey, {
        this.onValueChanged,
        Key key,
      }) : super(key: key);

  final Orientation orientation;
  final bool showMaterialonIOS;
  final GlobalKey<ScaffoldState> scaffoldKey;

  final LabelledValueChanged<String, dynamic> onValueChanged;

  @override
  ExampleFormState createState() => ExampleFormState();
}

class ExampleFormState extends State<ExampleForm> {

  @override
  void initState() {
    super.initState();

    initModel();
  }

  void initModel() async {
    _settingModel = SettingModel();

    setState(() => loaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      return Form(
        key: _formKey,
        child: (widget.orientation == Orientation.portrait)
            ? _buildPortraitLayout()
            : _buildLandscapeLayout(),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Future savePressed() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print("저장되었습니다.");
    } else {
      print("실패함");
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
    }
  }

  void canclePressed() {

  }

  void resetPressed() {
    setState(() => loaded = false);

    initModel();

    _formKey.currentState.reset();
  }
  CardSettings _buildPortraitLayout() {
    return CardSettings.sectioned(
      showMaterialonIOS: widget.showMaterialonIOS,
      labelWidth: 150,
      contentAlign: TextAlign.right,
      cardless: false,
      children: <CardSettingsSection>[
        CardSettingsSection(
          children: <CardSettingsWidget>[
            _buildCardSettingsListPicker_Theme(),
            //_buildCardSettingsVersion(),
            //_buildCardSettingsUpdate(),
            //_buildCardSettingsLogout(),
            _buildCardSettingsButton_Logout(),
          ],
        ),
        CardSettingsSection(
          children: <CardSettingsWidget>[
          ],
        ),
      ],
    );
  }

  CardSettings _buildLandscapeLayout() {
    return CardSettings.sectioned(
      showMaterialonIOS: widget.showMaterialonIOS,
      labelPadding: 12.0,
      children: <CardSettingsSection>[
        CardSettingsSection(
          children: <CardSettingsWidget>[
            //_buildCardSettingsListPicker_Type(),
            CardFieldLayout(
              <CardSettingsWidget>[
                //_buildCardSettingsNumberPicker_Age(labelAlign: TextAlign.right),
              ],
              flexValues: [2, 1],
            ),
            _buildCardSettingsListPicker_Theme(),
            //_buildCardSettingsVersion(),
            //_buildCardSettingsUpdate(),
            //_buildCardSettingsLogout(),
          ],
        ),
        CardSettingsSection(
          children: <CardSettingsWidget>[
            CardFieldLayout(<CardSettingsWidget>[
              //_buildCardSettingsButton_Save(),
              //_buildCardSettingsButton_Reset(),
            ]),
          ],
        ),
      ],
    );
  }

  CardSettingsButton _buildCardSettingsButton_Logout() {
    return CardSettingsButton(
      label: "로그아웃",
      backgroundColor: Colors.white,
      //backgroundColor: Color(0xffd7f2d3),
      //backgroundColor: Colors.green,
      onPressed: (){
        //FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(
          context,
          '/login',
        );
      },
    );
  }
  CardSettingsListPicker _buildCardSettingsListPicker_Theme() {
    return CardSettingsListPicker(
      key: _themeKey,
      label: '테마',
      initialValue: _settingModel.theme,
      autovalidateMode: _autoValidateMode,
      options: allThemes,
      values: allThemesValues,
      validator: (String value) {
        if (value == null || value.isEmpty) return '선택해주세요.';
        return null;
      },
      onSaved: (value) => _settingModel.theme = value,
      onChanged: (value) {
        setState(() {
          _settingModel.theme = value;
        });
      },
    );
  }

}