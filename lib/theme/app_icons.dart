import 'package:flutter/material.dart';

/// Design-system icons mapped to the closest Material icons.
/// Use with [Icon]: `Icon(AppIcons.search, size: AppIcons.md)`.
abstract final class AppIcons {
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 36;

  static const add = Icons.add_rounded;
  static const backArrow = Icons.arrow_back_rounded;
  static const bundle = Icons.inventory_2_outlined;
  static const cached = Icons.cached_rounded;
  static const calendar = Icons.calendar_today_outlined;
  static const chevronDown = Icons.keyboard_arrow_down_rounded;
  static const chevronUp = Icons.keyboard_arrow_up_rounded;
  static const clock = Icons.schedule_rounded;
  static const compareArrows = Icons.compare_arrows_rounded;
  static const dashboard = Icons.dashboard_outlined;
  static const delete = Icons.delete_outline_rounded;
  static const download = Icons.download_rounded;
  static const edit = Icons.edit_outlined;
  static const eyeOpen = Icons.visibility_outlined;
  static const filter = Icons.filter_list_rounded;
  static const form = Icons.description_outlined;
  static const gavel = Icons.gavel_rounded;
  static const govt = Icons.account_balance_outlined;
  static const logout = Icons.logout_rounded;
  static const mail = Icons.mail_outline_rounded;
  static const menu = Icons.menu_rounded;
  static const notification = Icons.notifications_none_rounded;
  static const personRaisedHand = Icons.emoji_people_rounded;
  static const phone = Icons.phone_outlined;
  static const portfolio = Icons.work_outline_rounded;
  static const principal = Icons.account_balance_wallet_outlined;
  static const profile = Icons.person_outline_rounded;
  static const profile2 = Icons.badge_outlined;
  static const quiz = Icons.quiz_outlined;
  static const rightArrow = Icons.arrow_forward_rounded;
  static const search = Icons.search_rounded;
  static const shakeHands = Icons.handshake_outlined;
  static const signup = Icons.person_add_alt_outlined;
  static const timer = Icons.timer_outlined;
  static const trash = Icons.delete_outline_rounded;
  static const upload = Icons.cloud_upload_outlined;
  static const upload2 = Icons.upload_rounded;
  static const watchlist = Icons.star_outline_rounded;
  static const bookmark = Icons.bookmark_border_rounded;
  static const bookmarkFilled = Icons.bookmark_rounded;

  /// Name → icon, in design order. Handy for galleries and lookups.
  static const all = <String, IconData>{
    'add': add,
    'backArrow': backArrow,
    'bundle': bundle,
    'cached': cached,
    'calendar': calendar,
    'chevronDown': chevronDown,
    'chevronUp': chevronUp,
    'clock': clock,
    'compareArrows': compareArrows,
    'dashboard': dashboard,
    'delete': delete,
    'download': download,
    'edit': edit,
    'eyeOpen': eyeOpen,
    'filter': filter,
    'form': form,
    'gavel': gavel,
    'govt': govt,
    'logout': logout,
    'mail': mail,
    'menu': menu,
    'notification': notification,
    'personRaisedHand': personRaisedHand,
    'phone': phone,
    'portfolio': portfolio,
    'principal': principal,
    'profile': profile,
    'profile2': profile2,
    'quiz': quiz,
    'rightArrow': rightArrow,
    'search': search,
    'shakeHands': shakeHands,
    'signup': signup,
    'timer': timer,
    'trash': trash,
    'upload': upload,
    'upload2': upload2,
    'watchlist': watchlist,
    'bookmark': bookmark,
    'bookmarkFilled': bookmarkFilled,
  };
}
