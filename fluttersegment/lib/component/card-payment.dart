import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CardPayment extends StatelessWidget {
  final String titleLabel;
  final String contentLabel;
  final String totalTransaction;
  final String imageCostume;
  IconData? cardIcon;
  VoidCallback? onTap;
  int? percentage;

  CardPayment({
    super.key,
    required this.titleLabel,
    required this.contentLabel,
    required this.totalTransaction,
    required this.imageCostume,
    this.percentage,
    this.cardIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFFC8F4CD),
              ),
              child: Image.asset(
                imageCostume,
                width: 25,
                height: 25,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      contentLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Dari ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black, // Specify the text color
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '$totalTransaction',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' transaksi'),
                        ],
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: onTap,
                  child: Text("$percentage% >",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
