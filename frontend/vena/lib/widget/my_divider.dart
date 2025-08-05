import 'package:flutter/material.dart';

import '../utils/size.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Row(
        children: [
          const SizedBox(width: 70),
          SizedBox(
            width: ScreenSize.getSize(context).width * 0.2,
            child: Divider(
              thickness: 1.25,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Ya da",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: ScreenSize.getSize(context).width * 0.2,
            child: Divider(
              thickness: 1.25,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
