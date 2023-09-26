// // ignore_for_file: prefer_const_constructors

// import 'package:dating/assets/icons.dart';
// import 'package:dating/chat/bloc/chat_bloc.dart';
// import 'package:dating/chat/chat_view.dart';
// import 'package:dating/chatslist/bloc/chats_bloc.dart';
// import 'package:dating/misc/extensions.dart';
// import 'package:dating/supabase/service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class ChatsList extends HookWidget {
//   const ChatsList({
//     super.key,
//     this.chats,
//   });

//   final List<ChatExt>? chats;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ChatsBloc, ChatsState>(
//       builder: (context, state) {
//         return ListView(
//           children: (state.chats)
//               .map((chat) => _ChatListViewItem(chat: chat))
//               .toList(),
//         );
//       },
//     );
//   }
// }

// class _ChatListViewItem extends StatelessWidget {
//   const _ChatListViewItem({
//     super.key,
//     required this.chat,
//   });

//   final Chat chat;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 1),
//       color: chat.containsUnread ? Colors.yellow.shade100 : null,
//       elevation: 1,
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context).push(
//             ChatView.route(
//               partner: chat.partner,
//               chat: chat,
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               chat.partner.hasAvatar
//                   ? CircleAvatar(
//                       foregroundImage:
//                           NetworkImage(chat.partner.photos.first.url),
//                       radius: 32,
//                     )
//                   : Container(
//                       width: 64,
//                       height: 64,
//                       clipBehavior: Clip.antiAlias,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: context.colorScheme.primaryContainer
//                             .withOpacity(0.7),
//                       ),
//                       child: SvgPicture.asset(
//                         IconAssets.userPlaceholder,
//                         colorFilter: ColorFilter.mode(
//                           context.colorScheme.primary.withOpacity(0.2),
//                           BlendMode.srcIn,
//                         ),
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       chat.partner.name,
//                       style: context.textTheme.titleLarge,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       chat.messages.last.text,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
