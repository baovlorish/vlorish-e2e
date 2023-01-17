import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickAvatarWidget extends StatefulWidget {
  final String? image;
  final String assetImage;
  final Function(XFile pickedFile) onImageSet;
  final Function() onImageValidationError;

  const PickAvatarWidget({
    Key? key,
    this.image,
    required this.assetImage,
    required this.onImageSet,
    required this.onImageValidationError,
  }) : super(key: key);

  @override
  _PickAvatarWidgetState createState() => _PickAvatarWidgetState();
}

class _PickAvatarWidgetState extends State<PickAvatarWidget> {
  String? currentImage;
  final picker = ImagePicker();

  Future getImage(BuildContext context) async {
    final maxSizeOfAvatar = 4194304; // 4mb in bytes
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null &&
        (await pickedFile.readAsBytes()).lengthInBytes < maxSizeOfAvatar &&
        (pickedFile.mimeType == 'image/png' ||
            pickedFile.mimeType == 'image/jpeg' ||
            pickedFile.mimeType == 'image/gif')) {
      widget.onImageSet(pickedFile);
      setState(() {
        currentImage = pickedFile.path;
      });
    } else {
      widget.onImageValidationError();
    }
  }

  @override
  void initState() {
    currentImage = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
              width: 132.0,
              height: 132.0,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: CustomColorScheme.button,
                    ),
                    borderRadius: BorderRadius.circular(66),
                  ),
                  child: ClipOval(
                    child: currentImage != null
                        ? Image.network(
                            currentImage!,
                            width: 132.0,
                            height: 132.0,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            widget.assetImage,
                            width: 132.0,
                            height: 132.0,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
          ),
          ClipOval(
            child: Container(
              color: CustomColorScheme.button,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  focusColor: CustomColorScheme.whiteInkWell,
                  hoverColor: CustomColorScheme.whiteInkWell,
                  splashColor: CustomColorScheme.whiteInkWell,
                  icon: ImageIcon(
                    AssetImage('assets/images/icons/edit_ic.png'),
                    color: CustomColorScheme.tableWhiteText,
                    size: 24,
                  ),
                  onPressed: () {
                    getImage(context);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
