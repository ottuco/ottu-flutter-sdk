// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ottu/consts/imagePath.dart';
import 'package:ottu/generated/l10n.dart';
import 'package:ottu/screen/payment_details_screen.dart';
import '../cardValidators/payment_card.dart';
import '../consts/colors.dart';
import '../consts/consts.dart';

///saved card widget
class SavedCard extends StatefulWidget {
  final bool isSelected;
  final String brand;
  Function cvvStatus;
  final String number;
  final String expiryMonth;
  final String expiryYear;
  final bool paywithcvv;
  final TextEditingController cvvcontroller;
  final Function onCardTap;

  SavedCard({
    Key? key,
    required this.isSelected,
    required this.brand,
    required this.cvvStatus,
    required this.expiryMonth,
    required this.cvvcontroller,
    required this.expiryYear,
    required this.paywithcvv,
    required this.onCardTap,
    required this.number,
  }) : super(key: key);

  @override
  State<SavedCard> createState() => _SavedCardState();
}

class _SavedCardState extends State<SavedCard> {
  String cardimage(String image) {
    if (image == 'VISA') {
      return 'visa.png';
    }
    if (image == 'MASTERCARD') {
      return 'Mastercard_logo.png';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, child) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.isSelected ? primaryColor : borderColor,
          ),
        ),
        margin: const EdgeInsets.all(5),
        child: Row(
          children: [
            IgnorePointer(
              ignoring: true,
              child: Checkbox(
                value: widget.isSelected,
                shape: const StadiumBorder(),
                activeColor: primaryColor,
                side: const BorderSide(color: secondaryGreyColor),
                onChanged: (e) {},
              ),
            ),
            Image.asset(
              imagePath + cardimage(widget.brand),
              package: 'ottu',
              key: UniqueKey(),
              width: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.brand} ${widget.number}',
                  style: TextStyle(fontSize: 12.sp),
                ),
                Text(
                  '${S.of(context).Expiredon} ${widget.expiryMonth}/${widget.expiryYear}',
                  style: TextStyle(fontSize: 10.sp),
                ),
                if (widget.paywithcvv && widget.isSelected)
                  SizedBox(
                    height: 8.h,
                  ),
                if (widget.paywithcvv && widget.isSelected)
                  Row(
                    children: [
                      SizedBox(
                        // height: 40,
                        width: 100.w,
                        child: TextFormField(
                          controller: widget.cvvcontroller,
                          enabled: isEnabled,
                          cursorColor: primaryColor,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          onChanged: (v) {
                            widget.cvvStatus(v);
                            if (v.length >= 3) {
                              setState(() {
                                payType = 'paywithsavedcard';
                              });
                            } else {
                              setState(() {
                                payType = '';
                              });
                            }
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            hintStyle: TextStyle(
                              fontSize: 13.sp,
                            ),
                            hintText: S.of(context).CCV,
                            prefixIcon: Image.asset(
                              '${imagePath}card_cvv.png',
                              package: 'ottu',
                              scale: 3.5,
                              color: Colors.grey[400],
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: secondaryGreyColor,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: secondaryGreyColor,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          validator: CardUtils.validateCVV,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            // paymentCard.cvv = int.parse(value!);
                          },
                        ),
                      ),
                    ],
                  )
              ],
            ),
            const Spacer(),
            if (widget.isSelected)
              InkWell(
                onTap: () {
                  widget.onCardTap();
                },
                child: Image.asset(
                  '${imagePath}delete.png',
                  package: 'ottu',
                  scale: 4,
                ),
              ),
          ],
        ),
      );
    });
  }
}
