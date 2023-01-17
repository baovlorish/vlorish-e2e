// part of 'transactions_layout.dart';
//
// class RebuildTransactionPageInherited extends StatefulWidget {
//   const RebuildTransactionPageInherited({Key? key, required this.child})
//       : super(key: key);
//   final Widget child;
//
//   @override
//   _RebuildTransactionPageInheritedState createState() =>
//       _RebuildTransactionPageInheritedState();
// }
//
// class _RebuildTransactionPageInheritedState
//     extends State<RebuildTransactionPageInherited> {
//   bool moveStatsToTheTop = false;
//
//   @override
//   Widget build(BuildContext context) {
//     moveStatsToTheTop = MediaQuery.of(context).size.width < 1300;
//     return _RebuildTransactionPageData(
//       moveStatsToTheTop: moveStatsToTheTop,
//       child: widget.child,
//     );
//   }
// }
//
// class _RebuildTransactionPageData with ChangeNotifier {
//   bool moveStatsToTheTop = false;
//
//   _RebuildTransactionPageData({
//     Key? key,
//     required this.moveStatsToTheTop,
//     required Widget child,
//   });
// }
