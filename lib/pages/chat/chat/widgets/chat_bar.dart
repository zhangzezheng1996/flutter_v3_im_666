import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../common/index.dart';

class ChatBarWidget extends StatefulWidget {
  const ChatBarWidget({
    super.key,
    this.chatTextEditingController,
    this.onTextSend,
    this.onSoundRecordBefore,
    this.onImageSend,
    this.onSoundSend,
    this.isClose,
  });

  /// 聊天输入框控制器
  final TextEditingController? chatTextEditingController;

  /// 发送文字
  final Function(String text)? onTextSend;

  /// 录音前
  final Function()? onSoundRecordBefore;

  /// 发送图片
  final Function(List<AssetEntity>)? onImageSend;

  /// 发送语音
  final Function(String path, int seconds)? onSoundSend;

  /// 关闭
  final bool? isClose;

  @override
  State<ChatBarWidget> createState() => ChatBarWidgetState();
}

class ChatBarWidgetState extends State<ChatBarWidget> {
  // 子栏高度
  final double _keyboardHeight = 200;

  // 显示表情栏
  bool _isShowEmoji = false;

  // 显示语言栏
  bool _isShowVoice = false;

  // 显示更多栏
  bool _isShowMore = false;

  // 是否是输入框
  bool _isTextEdit = false;

  // 输入框焦点
  final FocusNode _focusNode = FocusNode();

  // 输入框控制器
  late TextEditingController _chatTextEditingController;

  @override
  void initState() {
    super.initState();
    _chatTextEditingController =
        widget.chatTextEditingController ?? TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // 底部弹出评论栏
  Widget _buildBar() {
    List<Widget> ws = [];

    // 语音按钮
    ws.add(IconWidget.svg(
      _isShowVoice == true ? AssetsSvgs.keyboardSvg : AssetsSvgs.voiceSvg,
      size: 32,
      color: AppColors.outline,
    ).onTap(_onToggleVoice).paddingRight(AppSpace.iconTextSmail));

    // 语音输入
    if (_isShowVoice == true) {
      ws.add(ButtonWidget.textRoundFilled(
        "按住 说话",
        bgColor: AppColors.surface,
        borderRadius: AppRadius.button,
        borderColor: AppColors.outline,
        textColor: AppColors.secondary,
        textWeight: FontWeight.bold,
        height: 38,
      )
          .paddingRight(
            AppSpace.iconTextSmail,
          )
          .expanded());
    }

    // 文字输入
    if (_isShowVoice != true) {
      ws.add(InputWidget.textFilled(
        controller: _chatTextEditingController,
        hintText: "请输入内容",
        focusNode: _focusNode,
        borderColor: AppColors.outline,
        fillColor: AppColors.background,
        onChanged: (value) {
          setState(() {
            _isTextEdit = value.isNotEmpty;
          });
        },
        onSubmitted: (value) {
          _onSendText();
        },
      )
          .height(38)
          .paddingRight(
            AppSpace.iconTextSmail,
          )
          .expanded());
    }

    // 表情按钮
    ws.add(IconWidget.svg(
      _isShowEmoji == true ? AssetsSvgs.keyboardSvg : AssetsSvgs.stickerSvg,
      size: 32,
      color: AppColors.outline,
    ).onTap(_onToggleEmoji).paddingRight(AppSpace.iconTextSmail));

    // 更多按钮
    if (_isTextEdit == false) {
      ws.add(IconWidget.svg(
        AssetsSvgs.add2Svg,
        size: 32,
        color: AppColors.outline,
      ).onTap(_onToggleMore));
    } else {
      ws.add(ButtonWidget.primary(
        "发送",
        onTap: _onSendText,
      ).constrained(
        height: 32,
        width: 60,
      ));
    }

    return ws.toRow(crossAxisAlignment: CrossAxisAlignment.center);
  }

  // 表情列表
  Widget _buildEmojiList() {
    return SizedBox(
      height: _keyboardHeight,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          // 横轴上的组件数量
          crossAxisCount: 7,
          // 沿主轴的组件之间的逻辑像素数。
          mainAxisSpacing: 10,
          // 沿横轴的组件之间的逻辑像素数。
          crossAxisSpacing: 10,
        ),
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.grey[200],
          );
        },
      ),
    ).paddingTop(AppSpace.listRow);
  }

  // 更多列表
  Widget _buildMoreList() {
    return SizedBox(
      height: _keyboardHeight,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          Container(
            width: 100,
            height: 100,
            color: AppColors.surfaceVariant,
          ),
          Container(
            width: 100,
            height: 100,
            color: AppColors.surfaceVariant,
          ),
        ],
      ),
    ).paddingTop(AppSpace.listRow);
  }

  Widget _mainView() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      padding: MediaQuery.of(context).viewInsets,
      color: AppColors.onInverseSurface,
      child: <Widget>[
        _buildBar(),
        if (_isShowEmoji) _buildEmojiList(),
        if (_isShowMore) _buildMoreList(),
      ]
          .toColumn(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          )
          .padding(all: AppSpace.bottomView)
          .safeArea(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }

  ///////////////////////////////////////////////////////

  // 关闭
  void onClose() {
    _focusNode.unfocus();
    _isShowEmoji = false;
    _isShowVoice = false;
    _isShowMore = false;
  }

  // 切换语音
  void _onToggleVoice() {
    setState(() {
      _isShowVoice = !_isShowVoice;
      _isShowEmoji = false;
      _isShowMore = false;
    });
    if (_isShowVoice) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  // 切换表情
  void _onToggleEmoji() {
    setState(() {
      _isShowVoice = false;
      _isShowEmoji = !_isShowEmoji;
      _isShowMore = false;
    });
    if (_isShowEmoji) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  // 切换更多
  void _onToggleMore() {
    setState(() {
      _isShowVoice = false;
      _isShowEmoji = false;
      _isShowMore = !_isShowMore;
    });
    if (_isShowMore) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  // 发送文字
  void _onSendText() {
    widget.onTextSend?.call(_chatTextEditingController.text);
    _chatTextEditingController.text = "";
    setState(() {
      _isTextEdit = false;
    });
  }
}
