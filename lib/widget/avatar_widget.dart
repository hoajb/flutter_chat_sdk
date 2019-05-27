import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_sdk/resource/app_resources.dart';

class AvatarWidget extends StatelessWidget {
  final String urlAvatar;
  final String displayName;
  final double size;

  const AvatarWidget(
      {Key key,
      @required this.urlAvatar,
      @required this.displayName,
      @required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (urlAvatar == null || urlAvatar.isEmpty)
        ? CircleAvatar(
            radius: size / 2,
            backgroundColor: Colors.green.shade800,
            child: Text(displayName != null
                ? displayName.toUpperCase()[0] ?? '-'
                : '-'),
          )
        : Material(
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.colorThemeAccent),
                    ),
                    width: size,
                    height: size,
                    padding: EdgeInsets.all(15.0),
                  ),
              imageUrl: urlAvatar,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            clipBehavior: Clip.hardEdge,
          );
  }
}
