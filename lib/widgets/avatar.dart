import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, required this.radius, required this.url})
      : super(key: key);
  final double radius;
  final String? url;

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> provider() => url == null
        ? AssetImage('assets/images/logoo.png')
        : NetworkImage(url!) as ImageProvider;
    return CircleAvatar(
      radius: radius,
      backgroundImage: provider(),
    );
  }
}

class AvatarWithActivity extends Avatar {
  const AvatarWithActivity(
      {Key? key, required radius, required url, required this.isActive})
      : super(key: key, radius: radius, url: url);
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        super.build(context),
        Positioned(
          right: 15,
          top: 35,
          child: Container(
            height: radius * 0.3,
            width: radius * 0.3,
            decoration: BoxDecoration(
                color: isActive ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(radius)),
          ),
        )
      ],
    );
  }
}
