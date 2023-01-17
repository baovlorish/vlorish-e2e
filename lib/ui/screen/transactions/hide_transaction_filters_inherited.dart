part of 'transactions_layout.dart';

class HideTransactionFiltersInherited extends StatefulWidget {
  static HideTransactionFiltersData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HideTransactionFiltersData>()
          as HideTransactionFiltersData;

  const HideTransactionFiltersInherited({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  _HideTransactionFiltersInheritedState createState() =>
      _HideTransactionFiltersInheritedState();
}

class _HideTransactionFiltersInheritedState
    extends State<HideTransactionFiltersInherited> {
  bool showFilters = false;

  void onShowFiltersToggled(bool newValue) {
    setState(() {
      showFilters = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HideTransactionFiltersData(
      showFilters: showFilters,
      onMyFieldChange: onShowFiltersToggled,
      child: widget.child,
    );
  }
}

class HideTransactionFiltersData extends InheritedWidget {
  final bool showFilters;
  final ValueChanged<bool> onMyFieldChange;

  HideTransactionFiltersData({
    Key? key,
    required this.showFilters,
    required this.onMyFieldChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(HideTransactionFiltersData oldWidget) {
    return oldWidget.showFilters != showFilters ||
        oldWidget.onMyFieldChange != onMyFieldChange;
  }
}
