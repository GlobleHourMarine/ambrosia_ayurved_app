import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String? title;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    this.leading,
    this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(166, 207, 250, 187),
              Color.fromARGB(255, 90, 196, 80),
            ],
          ),
        ),
      ),
      leading: leading != null
          ? Padding(
              padding: const EdgeInsets.all(5.0),
              child: Material(
                color: Colors.black.withOpacity(0.21),
                borderRadius: BorderRadius.circular(12),
                child: leading,
              ),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                letterSpacing: 0.8,
                fontSize: 24,
              ),
            )
          : null,
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(63);
}
