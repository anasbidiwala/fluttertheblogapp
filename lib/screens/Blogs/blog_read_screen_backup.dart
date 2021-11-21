// import 'dart:async';
//
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:skeleton_loader/skeleton_loader.dart';
// import 'package:the_blog_app/models/blogs_model.dart';
// import 'package:the_blog_app/utils/constants.dart';
// import 'package:the_blog_app/utils/model_object_helper.dart';
// import 'package:the_blog_app/utils/size_config.dart';
//
// import 'add_blog_screen.dart';
//
// class BlogReadScreen extends StatefulWidget {
//
//   const BlogReadScreen({Key? key, required this.singleBlog, this.isFromNotification = false, this.blogId}) : super(key: key);
//
//   final SingleBlog singleBlog;
//   final bool isFromNotification;
//   final String? blogId;
//
//   @override
//   _BlogReadScreenState createState() => _BlogReadScreenState();
// }
//
// class _BlogReadScreenState extends State<BlogReadScreen> with ModelObjectHelper {
//
//   bool isBlogFetched = false;
//   var htmlData = "";
//   StreamController streamController = StreamController.broadcast();
//   late final SingleBlog? singleBlog;
//
//
//   @override
//   void initState() {
//     initModel(context);
//     if(widget.isFromNotification)
//     {
//       WidgetsBinding.instance!.addPostFrameCallback((_){
//         fetchBlog();
//       });
//     }else{
//
//       singleBlog = widget.singleBlog;
//     }
//     super.initState();
//   }
//
//   Future<void> fetchBlog()
//   async {
//     singleBlog = await blogsModel.fetchSingleBlogWithBlogId(context: context,blogId: widget.blogId!);
//     if(singleBlog!=null)
//     {
//       setState(() {
//         isBlogFetched = true;
//       });
//     }
//
//   }
//
//   void showConfirmationDialog()
//   {
//     // set up the buttons
//     Widget cancelButton = TextButton(
//       child: const Text("No"),
//       onPressed:  () {
//         Get.back();
//       },
//     );
//     Widget continueButton = TextButton(
//       child: const Text("Yes"),
//       onPressed:  () async {
//         await blogsModel.deleteBlog(context: context, blogId: singleBlog!.blogId);
//         Get.back();
//       },
//     );
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text("Are You Sure?"),
//       content: Text("You Want To Delete This Blog?"),
//       actions: [
//         cancelButton,
//         continueButton,
//       ],
//     );
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//
//   Widget get blogWidget => CustomScrollView(
//     slivers: [
//       SliverAppBar(
//         // shape: RoundedRectangleBorder(
//         //   borderRadius: BorderRadius.circular(20)
//         // ),
//         expandedHeight: 200,
//         pinned: true,
//         flexibleSpace: FlexibleSpaceBar(
//           background: Hero(
//             tag: singleBlog!.blogId.toString(),
//             child: CachedNetworkImage(
//               imageUrl: "${singleBlog!.blogImgUrl}",
//               fit: BoxFit.cover,
//
//               placeholder: (context, url) => SkeletonLoader(builder: Container(
//                 width: double.infinity,
//                 color: Colors.black,
//               ),),
//               errorWidget: (context, url, error){
//                 print("WHAT IS ERROR ${url} ${error.toString()}");
//                 return Icon(Icons.error);
//               },
//             ),
//           ),
//         ),
//       ),
//       SliverPersistentHeader(
//         pinned: true,
//         delegate: PersistentHeader(
//           widget: Hero(
//             tag: singleBlog!.blogId + "_header",
//             transitionOnUserGestures: true,
//             child: Material(
//               type: MaterialType.transparency, // likely needed
//               child: Container(
//                 height: 90,
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: appModel.primaryColorDark,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Expanded(
//                             child: Container(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 12, top: 8, bottom: 0),
//                                 child: Column(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.center,
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     AutoSizeText(
//                                       singleBlog!.blogTitle,
//                                       textAlign: TextAlign.left,
//                                       maxLines: 2,
//                                       minFontSize: 6,
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 16,
//                                           color: appModel.whiteColor
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 8,
//                                     ),
//                                     Text(
//                                       "Author - ${singleBlog!.blogOwnerName}",
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.white
//                                               .withOpacity(0.8)),
//                                     ),
//
//
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 right: 16, top: 8),
//                             child: Column(
//                               mainAxisAlignment:
//                               MainAxisAlignment.center,
//                               crossAxisAlignment:
//                               CrossAxisAlignment.end,
//                               children: <Widget>[
//                                 Text(
//                                   '${singleBlog!.blogAddedOn}',
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: appModel.whiteColor,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 SizedBox(height: 10,),
//                                 singleBlog!.blogOwnerId == userModel.userDetails!.userId ?Row(
//                                   children: [
//                                     InkWell(onTap: (){
//                                       Get.off(() => AddBlogScreen(addBlogScreenMode: AddBlogScreenMode.EDIT,singleBlog: singleBlog!,));
//                                     },child: Icon(LineIcons.edit,color: appModel.whiteColor,)),
//                                     SizedBox(width: 8,),
//                                     InkWell(onTap: (){
//                                       showConfirmationDialog();
//                                     },child: Icon(LineIcons.trash,color: appModel.whiteColor,))
//                                   ],
//                                 ):Container()
//                                 // Text(
//                                 //   '/per person',
//                                 //   style: TextStyle(
//                                 //       fontSize: 12,
//                                 //       color:
//                                 //       Colors.grey.withOpacity(0.8)),
//                                 // ),
//
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       SliverToBoxAdapter(
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(8),
//           child: Text(singleBlog!.blogDesc),
//         ),
//       )
//
//     ],
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: widget.isFromNotification ? isBlogFetched ? singleBlog!=null ? blogWidget : Center(child: Text("Blog Has Been Removed From Server."),) : Center(child: Text("Please Wait Blog Details Is Fetching"),) : blogWidget,
//       ),
//     );
//   }
// }
//
// class PersistentHeader extends SliverPersistentHeaderDelegate {
//   final Widget widget;
//
//   PersistentHeader({required this.widget});
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       width: double.infinity,
//       height: 90.0,
//       child: Card(
//         margin: EdgeInsets.all(0),
//         color: Colors.white,
//         elevation: 5.0,
//         child: Center(child: widget),
//       ),
//     );
//   }
//
//   @override
//   double get maxExtent => 90.0;
//
//   @override
//   double get minExtent => 90.0;
//
//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
// }
