
// import 'package:flutter/material.dart';
// import 'package:store_app/core/utils/app_colors.dart';

// class CommentsScreen extends StatefulWidget {
//   const CommentsScreen({super.key});

//   @override
//   State<CommentsScreen> createState() => _CommentsScreenState();
// }

// class _CommentsScreenState extends State<CommentsScreen> {
//   final TextEditingController _commentController =
//       TextEditingController();
//   int _editingIndex = -1;

//   List<Map<String, dynamic>> comments = [
//     {
//       'name': 'Sara Ahmed',
//       'comment':
//           'Absolutely delicious! This is my go-to recipe now.',
//       'rating': 5,
//       'timeAgo': '2 days ago',
//       'avatar': '👩',
//     },
//     {
//       'name': 'John Doe',
//       'comment':
//           'Great recipe, easy to follow. My family loved it!',
//       'rating': 4,
//       'timeAgo': '1 week ago',
//       'avatar': '👨',
//     },
//     {
//       'name': 'Layla Hassan',
//       'comment':
//           'Made this twice already. Perfect every time!',
//       'rating': 5,
//       'timeAgo': '2 weeks ago',
//       'avatar': '👩‍🦱',
//     },
//     {
//       'name': 'Mike Chen',
//       'comment': 'Good but I added extra cheese and it was 🔥',
//       'rating': 4,
//       'timeAgo': '3 weeks ago',
//       'avatar': '👨‍🦱',
//     },
//   ];

//   void _addComment() {
//     if (_commentController.text.trim().isEmpty) return;
//     setState(() {
//       if (_editingIndex >= 0) {
//         comments[_editingIndex]['comment'] =
//             _commentController.text.trim();
//         _editingIndex = -1;
//       } else {
//         comments.insert(0, {
//           'name': 'You',
//           'comment': _commentController.text.trim(),
//           'rating': 5,
//           'timeAgo': 'Just now',
//           'avatar': '🙂',
//         });
//       }
//       _commentController.clear();
//     });
//   }

//   void _deleteComment(int index) {
//     setState(() => comments.removeAt(index));
//   }

//   void _editComment(int index) {
//     setState(() {
//       _editingIndex = index;
//       _commentController.text = comments[index]['comment'] as String;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 20, vertical: 16),
//               child: Row(
//                 children: [
//                   const BackButton(),
//                   Expanded(
//                     child: Text(
//                         '${comments.length} Reviews',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.title)),
//                   ),
//                   const SizedBox(width: 40),
//                 ],
//               ),
//             ),

//             // Rating summary
//             Container(
//               margin:
//                   const EdgeInsets.symmetric(horizontal: 20),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppColors.surface,
//                 borderRadius: BorderRadius.circular(18),
//                 border: Border.all(color: AppColors.divider),
//               ),
//               child: Row(
//                 children: [
//                   Column(
//                     children: const [
//                       Text('4.7',
//                           style: TextStyle(
//                               fontSize: 36,
//                               fontWeight: FontWeight.w800,
//                               color: AppColors.title,
//                               letterSpacing: -1)),
//                       Text('out of 5',
//                           style: TextStyle(
//                               fontSize: 12,
//                               color: AppColors.bodyText)),
//                     ],
//                   ),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     child: Column(
//                       children: List.generate(
//                         5,
//                         (i) => Padding(
//                           padding: const EdgeInsets.only(bottom: 4),
//                           child: Row(
//                             children: [
//                               Text('${5 - i}',
//                                   style: const TextStyle(
//                                       fontSize: 12,
//                                       color: AppColors.bodyText)),
//                               const SizedBox(width: 6),
//                               const Icon(Icons.star_rounded,
//                                   color: AppColors.starColor,
//                                   size: 12),
//                               const SizedBox(width: 6),
//                               Expanded(
//                                 child: ClipRRect(
//                                   borderRadius:
//                                       BorderRadius.circular(4),
//                                   child: LinearProgressIndicator(
//                                     value: [0.7, 0.2, 0.05, 0.03, 0.02][i],
//                                     backgroundColor:
//                                         AppColors.tagBg,
//                                     valueColor:
//                                         const AlwaysStoppedAnimation(
//                                             AppColors.starColor),
//                                     minHeight: 6,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             Expanded(
//               child: ListView.separated(
//                 physics: const BouncingScrollPhysics(),
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 itemCount: comments.length,
//                 separatorBuilder: (_, __) =>
//                     const SizedBox(height: 10),
//                 itemBuilder: (_, i) => _CommentTile(
//                   name: comments[i]['name'] as String,
//                   comment: comments[i]['comment'] as String,
//                   rating: comments[i]['rating'] as int,
//                   timeAgo: comments[i]['timeAgo'] as String,
//                   avatar: comments[i]['avatar'] as String?,
//                   isOwn: comments[i]['name'] == 'You',
//                   onEdit: () => _editComment(i),
//                   onDelete: () => _deleteComment(i),
//                 ),
//               ),
//             ),

//             // Add comment bar
//             Container(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//               decoration: const BoxDecoration(
//                 color: AppColors.surface,
//                 border: Border(
//                     top: BorderSide(color: AppColors.divider)),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 46,
//                       decoration: BoxDecoration(
//                         color: AppColors.background,
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: TextField(
//                         controller: _commentController,
//                         style: const TextStyle(
//                             fontSize: 14, color: AppColors.title),
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: _editingIndex >= 0
//                               ? 'Edit your comment...'
//                               : 'Write a review...',
//                           hintStyle: const TextStyle(
//                               color: AppColors.hintText,
//                               fontSize: 14),
//                           contentPadding:
//                               const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 12),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: _addComment,
//                     child: Container(
//                       width: 46,
//                       height: 46,
//                       decoration: BoxDecoration(
//                         color: AppColors.primary,
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Icon(
//                         _editingIndex >= 0
//                             ? Icons.check_rounded
//                             : Icons.send_rounded,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _CommentTile extends StatelessWidget {
//   final String name;
//   final String comment;
//   final int rating;
//   final String timeAgo;
//   final String? avatar;
//   final bool isOwn;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;

//   const _CommentTile({
//     required this.name,
//     required this.comment,
//     required this.rating,
//     required this.timeAgo,
//     this.avatar,
//     this.isOwn = false,
//     this.onEdit,
//     this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: isOwn
//               ? AppColors.primary.withOpacity(0.2)
//               : AppColors.divider,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   color: AppColors.tagBg,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(avatar ?? '👤',
//                       style: const TextStyle(fontSize: 18)),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(name,
//                         style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.title)),
//                     Text(timeAgo,
//                         style: const TextStyle(
//                             fontSize: 11,
//                             color: AppColors.hintText)),
//                   ],
//                 ),
//               ),
//               Row(
//                 children: List.generate(
//                   5,
//                   (i) => Icon(
//                     i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
//                     color: AppColors.starColor,
//                     size: 13,
//                   ),
//                 ),
//               ),
//               if (isOwn) ...[
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: onEdit,
//                   child: const Icon(Icons.edit_outlined,
//                       size: 16, color: AppColors.bodyText),
//                 ),
//                 const SizedBox(width: 6),
//                 GestureDetector(
//                   onTap: onDelete,
//                   child: const Icon(Icons.delete_outline,
//                       size: 16, color: AppColors.heartColor),
//                 ),
//               ],
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(comment,
//               style: const TextStyle(
//                   fontSize: 13,
//                   color: AppColors.bodyText,
//                   height: 1.5)),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:store_app/features/home/views/product_Search_screen.dart';

class CommentsScreen extends StatefulWidget {
  // Real reviews passed from ProductDetailScreen
  final List<ReviewModel> reviews;

  const CommentsScreen({
    super.key,
    this.reviews = const [],
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  late List<ReviewModel> _reviews;

  @override
  void initState() {
    super.initState();
    _reviews = List.from(widget.reviews);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Average rating
  double get avgRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        _reviews.length;
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;
    // In real app → call API to add comment
    // For now we add locally as a placeholder
    setState(() {
      _reviews.insert(
        0,
        ReviewModel(
          rating: 5,
          comment: _commentController.text.trim(),
          date: DateTime.now().toIso8601String(),
          reviewerName: 'You',
          reviewerEmail: 'you@example.com',
        ),
      );
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16, color: AppColors.title),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${_reviews.length} Reviews',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.title,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Rating summary
            if (_reviews.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          avgRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppColors.title,
                            letterSpacing: -1,
                          ),
                        ),
                        const Text(
                          'out of 5',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.bodyText),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: List.generate(5, (i) {
                          final starVal = 5 - i;
                          final count = _reviews
                              .where((r) => r.rating == starVal)
                              .length;
                          final ratio = _reviews.isEmpty
                              ? 0.0
                              : count / _reviews.length;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Text('$starVal',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.bodyText)),
                                const SizedBox(width: 4),
                                const Icon(Icons.star_rounded,
                                    color: AppColors.starColor, size: 12),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: ratio,
                                      backgroundColor: AppColors.tagBg,
                                      valueColor:
                                          const AlwaysStoppedAnimation(
                                              AppColors.starColor),
                                      minHeight: 6,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text('$count',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.bodyText)),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Reviews List
            Expanded(
              child: _reviews.isEmpty
                  ? const Center(
                      child: Text('No reviews yet. Be the first!',
                          style: TextStyle(
                              color: AppColors.bodyText, fontSize: 14)),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _reviews.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final r = _reviews[i];
                        return CommentTile(
                          name: r.reviewerName,
                          comment: r.comment,
                          rating: r.rating,
                          timeAgo: _formatDate(r.date),
                          isOwn: r.reviewerName == 'You',
                          onDelete: r.reviewerName == 'You'
                              ? () => setState(() => _reviews.removeAt(i))
                              : null,
                        );
                      },
                    ),
            ),

            // Add comment bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border:
                    Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _commentController,
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.title),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write a review...',
                          hintStyle: TextStyle(
                              color: AppColors.hintText, fontSize: 14),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _addComment,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
      if (diff.inDays > 0) return '${diff.inDays} days ago';
      if (diff.inHours > 0) return '${diff.inHours} hours ago';
      return 'Just now';
    } catch (_) {
      return isoDate;
    }
  }
}