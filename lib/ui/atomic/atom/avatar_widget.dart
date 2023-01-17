import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? initials;
  final String? imageUrl;
  final double size;
  final String? colorGeneratorKey;
  const AvatarWidget(
      {Key? key,
      this.initials,
      this.imageUrl,
      this.size = 52,
      this.colorGeneratorKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: size,
        width: size,
        color: imageUrl != null
            ? Colors.white
            : colorGeneratorKey != null
                ? colorGenerator(colorGeneratorKey!)
                : Color.fromRGBO(187, 22, 128, 1),
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                height: size,
                width: size,
                fit: BoxFit.cover,
              )
            : initials != null
                ? Center(
                    child: Text(
                    initials!,
                    style:
                        TextStyle(color: Colors.white, fontSize: size / 2.5),
                  ))
                : SizedBox(),
      ),
    );
  }

  Color colorGenerator(String email) {
    var charSum = 0;
    for (var char in email.codeUnits) {
      charSum += char;
    }
    var result = charSum % Colors.primaries.length;
    return Colors.primaries[result].shade400;
  }
}
