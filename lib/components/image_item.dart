
// class ImageItem extends StatefulWidget {
//   String index;
//   ImageItem({super.key, required this.index});

//   @override
//   State<ImageItem> createState() => _ImageItemState();
// }

// class _ImageItemState extends State<ImageItem>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         AnimationController(vsync: this, duration: const Duration(seconds: 1));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selectedImage = context.select<UserProvider, Map<String, dynamic>>(
//         (provider) => provider.selectedImage);
//     return AspectRatio(
//       aspectRatio: 1 / 1,
//       child: Container(
//         clipBehavior: Clip.antiAlias,
//         margin: EdgeInsets.all(5),
//         child: selectedImage.containsKey(widget.index)
//             ? Container(
//                 child: context
//                     .read<UserProvider>()
//                     .make_iamge(widget.index, _controller)!,
//               )
//             : Icon(
//                 Icons.add,
//               ),
//         decoration: BoxDecoration(
//           border: Border.all(width: 0.5),
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           shape: BoxShape.rectangle,
//         ),
//       ),
//     );
//   }
// }
