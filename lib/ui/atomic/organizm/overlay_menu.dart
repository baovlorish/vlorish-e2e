import 'package:flutter/material.dart';

enum _ModalEntryType { positioned, aligned, selfPositioned, anchored }

class _Leader {
  _Leader(
    this.layerlink,
    this.followers,
  )   : modalAlignment = Alignment.centerLeft,
        anchorAlignment = Alignment.centerRight;

  Alignment anchorAlignment;
  Alignment modalAlignment;

  void updateAligments(
      {required Alignment anchorAlignment, required Alignment modalAlignment}) {
    this.anchorAlignment = anchorAlignment;
    this.modalAlignment = modalAlignment;
  }

  final LayerLink layerlink;
  final List<String> followers;

  @override
  String toString() {
    return '_Leader{layerlink: $layerlink, followers: $followers}';
  }
}

final Map<String, _Leader> _anchorMap = {};
OverlayEntry? overlayEntry;

void showModal(ModalEntry modalEntry) {
  final context = modalEntry.context;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    overlayEntry?.remove();
    final overlayState = Overlay.of(context, rootOverlay: true);
    overlayEntry = OverlayEntry(builder: (BuildContext context) => modalEntry);

    if (overlayState != null && overlayEntry != null) {
      overlayState.insert(overlayEntry!);
    }
  });
}

void removeModal() {
  if (overlayEntry != null) {
    overlayEntry!.remove();
    overlayEntry = null;
  }
}

class ModalEntry extends StatefulWidget {
  const ModalEntry.positioned(
    this.context, {
    Key? key,
    required this.tag,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.aboveTag,
    this.belowTag,
    this.removeOnPop = false,
    this.removeOnPushNext = false,
    this.barrierDismissible = false,
    this.barrierColor = Colors.transparent,
    this.onRemove,
    required this.child,
  })  : offset = Offset.zero,
        anchorTag = null,
        alignment = Alignment.center,
        anchorAlignment = null,
        modalAlignment = null,
        _modalEntryType = _ModalEntryType.positioned,
        assert(left == null || right == null),
        assert(top == null || bottom == null),
        assert(aboveTag == null || belowTag == null),
        super(key: key);

  const ModalEntry.aligned(
    this.context, {
    Key? key,
    required this.tag,
    required this.alignment,
    this.aboveTag,
    this.belowTag,
    this.offset = Offset.zero,
    this.removeOnPop = false,
    this.removeOnPushNext = false,
    this.barrierDismissible = false,
    this.barrierColor = Colors.transparent,
    this.onRemove,
    required this.child,
  })  : left = null,
        top = null,
        right = null,
        bottom = null,
        anchorTag = null,
        anchorAlignment = null,
        modalAlignment = null,
        _modalEntryType = _ModalEntryType.aligned,
        assert(aboveTag == null || belowTag == null),
        super(key: key);

  const ModalEntry.selfPositioned(
    this.context, {
    Key? key,
    required this.tag,
    this.aboveTag,
    this.belowTag,
    required this.anchorTag,
    this.offset = Offset.zero,
    this.removeOnPop = false,
    this.removeOnPushNext = false,
    this.barrierDismissible = false,
    this.barrierColor = Colors.transparent,
    this.onRemove,
    required this.child,
  })  : left = 0,
        top = null,
        right = null,
        bottom = 0,
        alignment = Alignment.center,
        anchorAlignment = null,
        modalAlignment = null,
        _modalEntryType = _ModalEntryType.selfPositioned,
        assert(aboveTag == null || belowTag == null),
        super(key: key);

  /// ignores self postioning of [ModalAnchor] and uses explicitly set [modalAlignment] and [anchorAlignment]
  const ModalEntry.anchored(
    this.context, {
    Key? key,
    required this.tag,
    this.aboveTag,
    this.belowTag,
    required this.anchorTag,
    this.offset = Offset.zero,
    this.removeOnPop = false,
    this.removeOnPushNext = false,
    this.barrierDismissible = false,
    this.barrierColor = Colors.transparent,
    required this.modalAlignment,
    required this.anchorAlignment,
    this.onRemove,
    required this.child,
  })  : left = 0,
        top = null,
        right = null,
        bottom = 0,
        alignment = Alignment.center,
        _modalEntryType = _ModalEntryType.anchored,
        assert(aboveTag == null || belowTag == null),
        super(key: key);

  final BuildContext context;

  /// Unique tag for [ModalEntry]
  final String tag;

  /// [ModalEntry] will be positioned just above given aboveTag [ModalEntry]
  final String? aboveTag;

  /// [ModalEntry] will be positioned just above given belowTag [ModalEntry]
  final String? belowTag;

  /// [child] widget which will be shown as modal
  final Widget child;

  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  final Alignment alignment;

  /// For [ModalEntry.anchored] follower alignment
  final Alignment? modalAlignment;

  /// For [ModalEntry.anchored] anchor alignment
  final Alignment? anchorAlignment;

  /// The additional offset to apply to the [ModalEntry] position
  final Offset offset;

  /// The [ModalAnchor] tag on this widget tree that will act as an anchor for the [ModalEntry]
  final String? anchorTag;

  /// Remove [ModalEntry] on pop
  final bool removeOnPop;

  /// Remove [ModalEntry] on push
  final bool removeOnPushNext;

  /// Modal barrier color
  final Color barrierColor;

  /// Remove [ModalEntry] on tapping the barrier
  final bool barrierDismissible;

  /// Callback function on [ModalEntry] removal
  final VoidCallback? onRemove;

  final _ModalEntryType _modalEntryType;

  @override
  ModalEntryState createState() => ModalEntryState();
}

class ModalEntryState extends State<ModalEntry> with RouteAware {
  LayerLink? link;
  Alignment anchorAlignment = Alignment.centerRight;
  Alignment modalAlignment = Alignment.centerLeft;

  @override
  void initState() {
    super.initState();
    if (widget.anchorTag != null) {
      if (!_anchorMap.containsKey(widget.anchorTag)) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('Unable to find ModalAnchor with given anchorTag'),
          ErrorDescription(
            'ModalAnchor must be visible before showing ModalEntry.\n'
            'Make sure that ModalAnchor is visible and ModalEntry is using correct anchorTag. Given anchorTag was: ${widget.anchorTag}',
          )
        ]);
      }
      link = _anchorMap[widget.anchorTag]!.layerlink;
      _anchorMap[widget.anchorTag]!.followers.add(widget.tag);
      anchorAlignment = _anchorMap[widget.anchorTag]!.anchorAlignment;
      modalAlignment = _anchorMap[widget.anchorTag]!.modalAlignment;
    }
  }

  @override
  void dispose() {
    remove();
    super.dispose();
  }

  void remove() {
    if (mounted) {
      if (widget.onRemove != null) {
        widget.onRemove!();
      }
      removeModal();
    }
  }

  @override
  void didPop() {
    if (widget.removeOnPop) {
      remove();
    }
  }

  @override
  void didPushNext() {
    if (widget.removeOnPushNext) {
      remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    anchorAlignment = _anchorMap[widget.anchorTag]?.anchorAlignment ?? Alignment.topLeft;
    modalAlignment = _anchorMap[widget.anchorTag]?.modalAlignment ?? Alignment.topLeft;
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !widget.barrierDismissible,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => remove(),
                child: ColoredBox(color: widget.barrierColor)),
          ),
        ),
        if (widget._modalEntryType == _ModalEntryType.positioned)
          Positioned(
            top: widget.top,
            left: widget.left,
            bottom: widget.bottom,
            right: widget.right,
            child: widget.child,
          )
        else if (widget._modalEntryType == _ModalEntryType.aligned)
          Transform.translate(
            offset: widget.offset,
            child: Align(
              alignment: widget.alignment,
              child: widget.child,
            ),
          )
        else if (widget._modalEntryType == _ModalEntryType.selfPositioned)
          CompositedTransformFollower(
            link: link!,
            showWhenUnlinked: true,
            offset: widget.offset,
            targetAnchor: anchorAlignment,
            followerAnchor: modalAlignment,
            child: widget.child,
          )
        else if (widget._modalEntryType == _ModalEntryType.anchored)
          CompositedTransformFollower(
            link: link!,
            showWhenUnlinked: true,
            offset: widget.offset,
            targetAnchor: widget.anchorAlignment!,
            followerAnchor: widget.modalAlignment!,
            child: widget.child,
          )
      ],
    );
  }
}

class ModalAnchor extends StatefulWidget {
  ModalAnchor({
    Key? key,
    required this.tag,
    required this.child,
    this.preferBottomTrigger = 100,
    this.preferLeftTrigger = 400,
  }) : super(key: key);

  /// Unique tag for [ModalAnchor]
  final String tag;
  final Widget child;

  /// if distance between [ModalAnchor] and bottom of the screen,
  /// is less than [preferBottomTrigger], [ModalEntry] will be anchored to bottom of it
  final double preferBottomTrigger;

  /// if distance between [ModalAnchor] and right end of the screen,
  /// is less than [preferLeftTrigger], [ModalEntry] will be anchored to the left side
  final double preferLeftTrigger;

  @override
  _ModalAnchorState createState() => _ModalAnchorState();
}

class _ModalAnchorState extends State<ModalAnchor> {
  final link = _Leader(LayerLink(), []);
  Alignment anchorAlignment = Alignment.centerRight;
  Alignment modalAlignment = Alignment.centerLeft;

  final GlobalKey _key = GlobalKey();

  var prevRect = Rect.fromLTRB(0, 0, 0, 0);

  Rect? getShiftedRect() {
    try {
      var renderObject = _key.currentContext?.findRenderObject();
      var translation = renderObject?.getTransformTo(null).getTranslation();
      if (translation != null && renderObject?.paintBounds != null) {
        return renderObject!.paintBounds
            .shift(Offset(translation.x, translation.y));
      }
    } catch (e) {
      return null;
    }
  }

  // this is where positioning the entry magic happens
  void updateAlignments() {
    var rect = getShiftedRect();
    if (rect != null) {
      var preferBottom = false;
      var preferLeft = false;
      if (MediaQuery.of(context).size.height - rect.bottom <
          widget.preferBottomTrigger) {
        preferBottom = true;
      }
      if (MediaQuery.of(context).size.width - rect.right <
          widget.preferLeftTrigger) {
        preferLeft = true;
      }

      if (preferLeft) {
        if (preferBottom) {
          anchorAlignment = Alignment.bottomLeft;
          modalAlignment = Alignment.bottomRight;
        } else {
          anchorAlignment = Alignment.topLeft;
          modalAlignment = Alignment.topRight;
        }
      } else {
        if (preferBottom) {
          anchorAlignment = Alignment.bottomRight;
          modalAlignment = Alignment.bottomLeft;
        } else {
          anchorAlignment = Alignment.topRight;
          modalAlignment = Alignment.topLeft;
        }
      }
      link.updateAligments(
          anchorAlignment: anchorAlignment, modalAlignment: modalAlignment);
    }
  }

  @override
  void initState() {
    super.initState();
    _anchorMap[widget.tag] = link;
  }

  @override
  void dispose() {
    _anchorMap.remove(widget.tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var newRect = getShiftedRect();
      if (prevRect != newRect && newRect != null) {
        prevRect = newRect;
        updateAlignments();
      }
    });
    _anchorMap[widget.tag] = link;
    return CompositedTransformTarget(
      link: link.layerlink,
      key: _key,
      child: widget.child,
    );
  }
}

/// Returns [ModalAnchor] if [tag]!=null or [child] otherwise.
class MaybeModalAnchor extends StatelessWidget {
  /// Unique tag for [ModalAnchor]
  final String? tag;
  final Widget child;

  /// if distance between [ModalAnchor] and bottom of the screen,
  /// is less than [preferBottomTrigger], [ModalEntry] will be anchored to bottom of it
  final double preferBottomTrigger;

  /// if distance between [ModalAnchor] and right end of the screen,
  /// is less than [preferLeftTrigger], [ModalEntry] will be anchored to the left side
  final double preferLeftTrigger;

  MaybeModalAnchor({
    Key? key,
    this.tag,
    required this.child,
    this.preferBottomTrigger = 100,
    this.preferLeftTrigger = 400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tag != null
        ? ModalAnchor(
            tag: tag!,
            preferBottomTrigger: preferBottomTrigger,
            preferLeftTrigger: preferLeftTrigger,
            child: child,
          )
        : child;
  }
}
