import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:flutter/material.dart';

class Testing extends StatelessWidget {
  const Testing({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: media.width * 0.25,
            height: 160,
            decoration: BoxDecoration(
              color: Acolors.primary,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(35),
                  bottomRight: Radius.circular(35)),
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                    margin: const EdgeInsets.only(
                        top: 8, bottom: 8, left: 10, right: 20),
                    width: media.width - 80,
                    height: 120,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            bottomLeft: Radius.circular(35),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, 4))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Total Price",
                          style: TextStyle(
                              // color: TColor.primaryText,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "100",
                          style: TextStyle(
                              // color: TColor.primaryText,
                              fontSize: 21,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 130,
                          height: 25,
                          child: ElevatedButton(
                              child: Text('Add to cart'), onPressed: () {}),
                        )
                      ],
                    ),
                    ),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const MyOrderView()));
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.5),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ]),
                    alignment: Alignment.center,
                    child: IconButton(
                        icon: Icon(Icons.shopping_bag_outlined),
                        onPressed: () {}),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
