import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum SelectFormFieldType { dropdown, dialog }

class SelectFormField extends FormField<String> {
  SelectFormField({
    Key? key,
    this.type = SelectFormFieldType.dropdown,
    this.controller,
    this.icon,
    this.changeIcon = false,
    this.labelText,
    this.hintText,
    this.dialogTitle,
    this.dialogSearchHint,
    this.dialogCancelBtn,
    this.enableSearch = false,
    this.items,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    bool autovalidate = false,
    bool maxLengthEnforced = true,
    int maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    this.onChanged,
    //GestureTapCallback onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
    double cursorWidth = 2.0,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
  })  : assert(initialValue == null || controller == null),
        assert(maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || minLines == null,
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(
          !obscureText || maxLines == 1,
          'Obscured fields cannot be multiline.',
        ),
        assert(maxLength == null || maxLength > 0),
        super(
          key: key,
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          //autovalidate: autovalidate,
          enabled: enabled,
          builder: (FormFieldState<String> field) {
            final _SelectFormFieldState state = field as _SelectFormFieldState;

            final InputDecoration effectiveDecoration = (decoration ??
                InputDecoration(
                  labelText: labelText,
                  icon: state._icon ?? icon,
                  hintText: hintText,
                  filled: true,
                  suffixIcon: Container(
                    width: 10,
                    margin: EdgeInsets.all(0),
                    child: TextButton(
                      onPressed: () {},
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ));
            effectiveDecoration.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );

            void onChangedHandler(String value) {
              if (onChanged != null) {
                onChanged(value);
              }
              field.didChange(value);
            }

            Widget buildField(SelectFormFieldType peType) {
              var lfOnTap;

              if (readOnly == false) {
                switch (peType) {
                  case SelectFormFieldType.dialog:
                    lfOnTap = state._showSelectFormFieldDialog;
                    break;
                  default:
                    lfOnTap = state._showSelectFormFieldMenu;
                }
              }

              return TextField(
                controller: state._labelController,

                focusNode: focusNode,
                decoration: effectiveDecoration.copyWith(
                  errorText: field.errorText,
                ),

                keyboardType: keyboardType,
                textInputAction: textInputAction,
                style: style,
                strutStyle: strutStyle,
                textAlign: textAlign,
                textAlignVertical: textAlignVertical,
                textDirection: textDirection,
                textCapitalization: textCapitalization,
                autofocus: autofocus,
                toolbarOptions: toolbarOptions,
                readOnly: true,
                showCursor: showCursor,
                obscureText: obscureText,
                autocorrect: autocorrect,
                smartDashesType: smartDashesType ??
                    (obscureText
                        ? SmartDashesType.disabled
                        : SmartDashesType.enabled),
                smartQuotesType: smartQuotesType ??
                    (obscureText
                        ? SmartQuotesType.disabled
                        : SmartQuotesType.enabled),
                enableSuggestions: enableSuggestions,
                //maxLengthEnforced: maxLengthEnforced,
                maxLines: maxLines,
                minLines: minLines,
                expands: expands,
                maxLength: maxLength,
                onChanged: onChangedHandler,
                onTap: readOnly ? null : lfOnTap,
                onEditingComplete: onEditingComplete,
                onSubmitted: onFieldSubmitted,
                inputFormatters: inputFormatters,
                enabled: enabled,
                cursorWidth: cursorWidth,
                cursorRadius: cursorRadius,
                cursorColor: cursorColor,
                scrollPadding: scrollPadding,
                scrollPhysics: scrollPhysics,
                keyboardAppearance: keyboardAppearance,
                enableInteractiveSelection: enableInteractiveSelection,
                buildCounter: buildCounter,
              );
            }

            switch (type) {
              case SelectFormFieldType.dialog:
                return buildField(SelectFormFieldType.dialog);
              default:
                return buildField(SelectFormFieldType.dropdown);
            }
          },
        );

  final SelectFormFieldType type;
  final TextEditingController? controller;
  final Widget? icon;
  final bool changeIcon;
  final String? labelText;
  final String? hintText;
  final String? dialogTitle;
  final String? dialogSearchHint;
  final String? dialogCancelBtn;
  final bool enableSearch;
  final ValueChanged<String>? onChanged;
  final List<Map<String, dynamic>>? items;

  @override
  _SelectFormFieldState createState() => _SelectFormFieldState();
}

class _SelectFormFieldState extends FormFieldState<String> {
  TextEditingController _labelController = TextEditingController();
  TextEditingController? _stateController;
  Widget? _icon;
  Map<String, dynamic>? _item = <String, dynamic>{};

  @override
  SelectFormField get widget => super.widget as SelectFormField;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _stateController;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _stateController = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }

    initValues();
  }

  void initValues() {
    if (_effectiveController?.text != null &&
        _effectiveController?.text != '') {
      widget.items?.forEach((Map<String, dynamic> lmItem) {
        if (lmItem['value'].toString() == _effectiveController?.text) {
          _item = lmItem;
          return;
        }
      });

      if (_item!.length > 0) {
        _labelController.text =
            _item!['label']?.toString() ?? _item!['value']!.toString();

        if (widget.changeIcon &&
            _item?['icon'] != null &&
            _item?['icon'] != '') {
          _icon = _item?['icon'];
        }
      }
    }
  }

  @override
  void didUpdateWidget(SelectFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _stateController =
            TextEditingController.fromValue(oldWidget.controller?.value);
      }

      if (widget.controller != null) {
        setValue(widget.controller?.text);

        if (oldWidget.controller == null) {
          _stateController = null;
        }
      }
    }

    if (_effectiveController?.text != null &&
        _effectiveController?.text != '') {
      _item = widget.items?.firstWhere(
        (lmItem) => lmItem['value'].toString() == _effectiveController?.text,
        orElse: () => <String, dynamic>{},
      );

      if (_item!.length > 0) {
        _labelController.text =
            _item!['label']?.toString() ?? _item!['value']!.toString();

        if (widget.changeIcon &&
            _item?['icon'] != null &&
            _item?['icon'] != '') {
          _icon = _item?['icon'];
        }
      }
    } else {
      _labelController.clear();
      _icon = widget.icon;

      initValues();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);

    super.dispose();
  }

  @override
  void reset() {
    super.reset();

    setState(() {
      _effectiveController?.text = widget.initialValue ?? '';
    });
  }

  void _handleControllerChanged() {
    if (_effectiveController?.text != value) {
      didChange(_effectiveController?.text);
    }
  }

  void onChangedHandler(String value) {
    widget.onChanged?.call(value);

    didChange(value);
  }

  Future<void> _showSelectFormFieldMenu() async {
    String? lvPicked = await showMenu<dynamic>(
      context: context,
      position: _buttonMenuPosition(context),
      initialValue: value,
      items: _renderItems(),
    );

    if (lvPicked != null && lvPicked != value) {
      _item = widget.items?.firstWhere(
        (lmItem) => lmItem['value'].toString() == lvPicked,
        orElse: () => <String, dynamic>{},
      );

      if (_item!.length > 0) {
        _labelController.text =
            _item!['label']?.toString() ?? _item!['value']!.toString();
        _effectiveController?.text = lvPicked.toString();

        if (widget.changeIcon &&
            _item?['icon'] != null &&
            _item?['icon'] != '') {
          setState(() {
            _icon = _item?['icon'];
          });
        }

        onChangedHandler(lvPicked);
      }
    }
  }

  Future<void> _showSelectFormFieldDialog() async {
    Map<String, dynamic>? lvPicked = await showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return ItemPickerDialog(
          widget.dialogTitle,
          widget.items,
          widget.enableSearch,
          widget.dialogSearchHint,
          widget.dialogCancelBtn,
        );
      },
    );

    if (lvPicked is Map<String, dynamic>) {
      _labelController.text =
          lvPicked['label']?.toString() ?? lvPicked['value']!.toString();
      _effectiveController?.text = lvPicked['value'].toString();

      if (widget.changeIcon &&
          lvPicked['icon'] != null &&
          lvPicked['icon'] != '') {
        setState(() {
          _icon = lvPicked['icon'];
        });
      }

      onChangedHandler(lvPicked['value'].toString());
    }
  }

  List<PopupMenuEntry<String>> _renderItems() {
    List<PopupMenuItem<String>> llItems = <PopupMenuItem<String>>[];

    widget.items?.forEach((lmElement) {
      PopupMenuItem<String> loItem = PopupMenuItem<String>(
        value: lmElement['value'].toString(),
        enabled: lmElement['enable'] ?? true,
        textStyle: lmElement['textStyle'] ?? lmElement['textStyle'],
        child: Row(
          children: [
            lmElement['icon'] ?? SizedBox(width: 5),
            Expanded(
              child: Text(
                lmElement['label']?.toString() ??
                    lmElement['value']!.toString(),
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ),
      );

      llItems.add(loItem);
    });

    return llItems;
  }

  RelativeRect _buttonMenuPosition(BuildContext poContext) {
    final RenderBox loBar = poContext.findRenderObject() as RenderBox;
    final RenderBox loOverlay =
        Overlay.of(poContext)?.context.findRenderObject() as RenderBox;
    const Offset loOffset = Offset.zero;

    final RelativeRect loPosition = RelativeRect.fromRect(
      Rect.fromPoints(
        loBar.localToGlobal(
          loBar.size.centerRight(loOffset),
          ancestor: loOverlay,
        ),
        loBar.localToGlobal(
          loBar.size.centerRight(loOffset),
          ancestor: loOverlay,
        ),
      ),
      loOffset & loOverlay.size,
    );

    return loPosition;
  }
}

class ItemPickerDialog extends StatefulWidget {
  final String? title;
  final String? searchHint;
  final String? cancelBtn;
  final List<Map<String, dynamic>>? items;
  final bool enableSearch;

  ItemPickerDialog(
    this.title,
    this.items, [
    this.enableSearch = true,
    this.searchHint = '',
    this.cancelBtn,
  ]);

  @override
  _ItemPickerDialogState createState() => new _ItemPickerDialogState();
}

class _ItemPickerDialogState extends State<ItemPickerDialog> {
  TextEditingController _oCtrlSearchQuery = TextEditingController();
  List<Map<String, dynamic>> _lItemListShow = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _lItemListOriginal = <Map<String, dynamic>>[];
  int _iQtItems = -1;

  @override
  void initState() {
    super.initState();

    _oCtrlSearchQuery.addListener(_search);
    _lItemListOriginal.clear();
    _lItemListShow.clear();
    _lItemListOriginal.addAll(widget.items ?? <Map<String, dynamic>>[]);
    _lItemListShow.addAll(_lItemListOriginal);
    _iQtItems = _lItemListOriginal.length;
  }

  @override
  void dispose() {
    _oCtrlSearchQuery.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _titleDialog(),
      content: Container(
        width: double.maxFinite,
        child: _content(),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelBtn ?? ''),
        ),
      ],
    );
  }

  Widget _titleDialog() {
    if (!widget.enableSearch) {
      return Text(widget.title ?? '');
    }

    return Column(
      children: <Widget>[
        Text(widget.title ?? ''),
        TextField(
          controller: _oCtrlSearchQuery,
          decoration: InputDecoration(
            icon: Icon(Icons.search),
            hintText: widget.searchHint,
            //hintStyle: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _content() {
    if (_iQtItems == -1) {
      return Center(child: CircularProgressIndicator());
    } else if (_iQtItems == 0) {
      return _showEmpty();
    }

    return ListItem(_lItemListShow);
  }

  Widget _showEmpty() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(0, -0.5),
          child: Icon(
            Icons.category,
            size: 50,
          ),
        ),
      ],
    );
  }

  void _search() {
    String lsQuery = _oCtrlSearchQuery.text;

    if (lsQuery.length > 2) {
      lsQuery.toLowerCase();

      String lsValue;

      setState(() {
        _lItemListShow.clear();

        _lItemListOriginal.forEach((loCredential) {
          lsValue = loCredential['label']?.toString().toLowerCase() ??
              loCredential['value']!.toString().toLowerCase();

          if (lsValue.contains(lsQuery)) {
            _lItemListShow.add(loCredential);
          }
        });

        _iQtItems = _lItemListShow.length;
      });
    } else {
      setState(() {
        _lItemListShow.clear();

        _lItemListOriginal.forEach((loCredential) {
          _lItemListShow.add(loCredential);
        });

        _iQtItems = _lItemListShow.length;
      });
    }
  }
}

class ListItem extends StatelessWidget {
  final List<Map<String, dynamic>> _lItens;

  ListItem(this._lItens);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _itemList(context),
    );
  }

  List<Widget> _itemList(context) {
    List<Widget> llItems = <Widget>[];

    _lItens.forEach((lmItem) {
      Widget loIten = ListTile(
        leading: lmItem['icon'] ?? null,
        title: Text(
          lmItem['label']?.toString() ?? lmItem['value']!.toString(),
          style: lmItem['textStyle'] ?? lmItem['textStyle'],
        ),
        enabled: lmItem['enable'] ?? true,
        onTap: () => Navigator.pop(context, lmItem),
      );

      llItems.add(loIten);
    });

    return llItems;
  }
}
