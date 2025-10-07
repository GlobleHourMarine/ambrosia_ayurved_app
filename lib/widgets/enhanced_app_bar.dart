import 'package:ambrosia_ayurved/ambrosia/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
import 'package:ambrosia_ayurved/widgets/translation/translation_provider_local.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class EnhancedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function(String) onSearchChanged;
  final String searchQuery;

  const EnhancedAppBar({
    Key? key,
    required this.title,
    required this.onSearchChanged,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<EnhancedAppBar> createState() => _EnhancedAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _EnhancedAppBarState extends State<EnhancedAppBar> {
  bool _isSearching = false;
  String fullHintText = 'Search products...';
  String visibleHintText = '';
  int hintIndex = 0;
  Timer? typingTimer;
  Timer? searchTimer;
  Duration typingSpeed = const Duration(milliseconds: 100);
  bool isTyping = true;
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    _startTypingEffect();

    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus && _searchController.text.isEmpty) {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  void _startTypingEffect() {
    typingTimer = Timer.periodic(typingSpeed, (timer) {
      if (!_isSearching &&
          _searchController.text.isEmpty &&
          !_searchFocusNode.hasFocus) {
        setState(() {
          if (isTyping) {
            if (hintIndex < fullHintText.length) {
              visibleHintText += fullHintText[hintIndex];
              hintIndex++;
            } else {
              isTyping = false;
            }
          } else {
            if (hintIndex > 0) {
              visibleHintText = visibleHintText.substring(0, hintIndex - 1);
              hintIndex--;
            } else {
              isTyping = true;
            }
          }
        });
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _isSearching = value.isNotEmpty || _searchFocusNode.hasFocus;
      if (_isSearching) {
        visibleHintText = fullHintText;
      }
    });

    searchTimer?.cancel();
    searchTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchChanged(value);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      visibleHintText = '';
      hintIndex = 0;
    });
    widget.onSearchChanged('');
    _searchFocusNode.unfocus();
    _startTypingEffect();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchFocusNode.requestFocus();
      } else {
        _searchFocusNode.unfocus();
        _clearSearch();
      }
    });
  }

  @override
  void dispose() {
    typingTimer?.cancel();
    searchTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final currentLanguage =
        Provider.of<LanguageProvider>(context).selectedLocale.languageCode;

    return AppBar(
      elevation: 8,
      shadowColor: Colors.black26,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFCFFABB),
              Color(0xFF5AC450),
            ],
          ),
        ),
      ),
      leading: _isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _toggleSearch,
            )
          : null,
      automaticallyImplyLeading: !_isSearching,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.2),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _isSearching
            ? Container(
                key: const ValueKey('search'),
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  textInputAction: TextInputAction.search,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: (_isSearching || _searchFocusNode.hasFocus)
                        ? 'Search products...'
                        : visibleHintText,
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF5AC450),
                      size: 22,
                    ),
                    suffixIcon:
                        (_isSearching && _searchController.text.isNotEmpty)
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xFF5AC450),
                                  size: 20,
                                ),
                                onPressed: _clearSearch,
                              )
                            : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                ),
              )
            : Text(
                key: const ValueKey('title'),
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  fontSize: 20,
                ),
              ),
      ),
      centerTitle: true,
      actions: _isSearching
          ? null
          : [
              // Search Icon Button
              Container(
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.search, size: 24),
                  onPressed: _toggleSearch,
                  tooltip: 'Search',
                ),
              ),

              // Language Selector
              PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value != currentLanguage) {
                    Provider.of<LanguageProvider>(context, listen: false)
                        .changeLanguage(value);
                  }
                },
                offset: const Offset(0, 56),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.language, size: 24),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (BuildContext context) =>
                    LanguageProvider.languages
                        .map((language) => PopupMenuItem<String>(
                              value: language['locale'],
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: 18,
                                    color: language['locale'] == currentLanguage
                                        ? const Color(0xFF5AC450)
                                        : Colors.transparent,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    language['name'],
                                    style: TextStyle(
                                      fontWeight:
                                          language['locale'] == currentLanguage
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
              ),

              // Cart Icon with Badge
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          size: 26,
                        ),
                        if (cart.totalUniqueItems > 0)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF5722),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Center(
                                child: Text(
                                  '${cart.totalUniqueItems}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
    );
  }
}

// Usage Example:
/*
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: EnhancedAppBar(
      title: 'Your App Title',
      onSearchChanged: _onSearchChanged,
      searchQuery: _searchQuery,
    ),
    body: YourBodyContent(),
  );
}
*/
