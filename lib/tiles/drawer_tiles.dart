import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({Key? key, required this.icon, required this.text, required this.page, required this.controller})
      : super(key: key);

  final IconData icon;
  final String text;
  final int page;
  final PageController controller;


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          height: 60,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: controller.page?.round() == page ? Theme.of(context).primaryColor : Colors.grey[700],
              ),
              SizedBox(
                width: 32,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 16, color: controller.page?.round() == page ? Theme.of(context).primaryColor : Colors.grey[700]),
              ),
            ],
      ),
        ),
      ),
    );
  }
}
