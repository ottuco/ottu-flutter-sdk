// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ottu/cardValidators/my_strings.dart';
import 'package:ottu/cardValidators/payment_card.dart';
import 'package:ottu/consts/colors.dart';
import 'package:ottu/consts/consts.dart';
import 'package:ottu/consts/imagePath.dart';
import 'package:ottu/generated/l10n.dart';
import 'package:ottu/screen/payment_details_screen.dart';
import 'package:ottu/widget/checkbox.dart';
import 'package:ottu/widget/dialogs.dart';
import '../cardValidators/input_formatters.dart';

// ignore: must_be_immutable

class CardTile extends StatefulWidget {
  String image;
  String cardname;
  bool cansavecard;
  String charges;
  Function paybuttonCallback;
  String customerID;
  String flow; // 'flow' parameter as a named argument
  bool isChecked;
  Function setIsChecked;
  Function oncardtap;
  TextEditingController nameOnCardController;
  TextEditingController cardNumberController;
  TextEditingController dateController;
  TextEditingController cvvController;
  bool isCardFlowSelected;
  bool isRedirectSelected;

  CardTile({
    required this.cansavecard,
    required this.paybuttonCallback,
    required this.oncardtap,
    required this.cardNumberController,
    required this.cvvController,
    required this.nameOnCardController,
    required this.dateController,
    required this.image,
    required this.cardname,
    required this.charges,
    required this.isCardFlowSelected,
    required this.isChecked,
    required this.setIsChecked,
    required this.isRedirectSelected,
    required this.flow,
    required this.customerID,
    Key? key,
  }) : super(key: key);

  @override
  State<CardTile> createState() => _CardTileState();
}

final formKey = GlobalKey<FormState>();

class _CardTileState extends State<CardTile> {
  final autoValidateMode = AutovalidateMode.disabled;
  final _card = PaymentCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          onTap: () {
            widget.oncardtap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isCardFlowSelected || widget.isRedirectSelected ? primaryColor : borderColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      getImageWidget(widget.image),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.cardname.toString(),
                            style: TextStyle(
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          widget.oncardtap();
                        },
                        icon: Icon(
                          widget.isCardFlowSelected
                              ? Icons.keyboard_arrow_down_outlined
                              : currentLocale == const Locale('ar')
                                  ? Icons.keyboard_arrow_left_outlined
                                  : Icons.keyboard_arrow_right_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.isCardFlowSelected)
                  SizedBox(
                    height: 8.h,
                  ),
                Visibility(
                  visible: widget.isCardFlowSelected,
                  child: SizedBox(
                    child: Column(
                      children: [
                        SizedBox(
                          // height: 40.h,
                          child: TextFormField(
                            enabled: isEnabled,
                            controller: widget.nameOnCardController,
                            cursorColor: primaryColor,
                            style: TextStyle(
                              fontSize: 13.sp,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              hintText: S.of(context).NameOnCard,
                              hintStyle: TextStyle(
                                fontSize: 13.sp,
                              ),
                              prefixIcon: Image.asset(
                                '${imagePath}card_name.png',
                                package: 'ottu',
                                scale: 3.5,
                                color: secondaryGreyColor,
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
                            onSaved: (String? value) {
                              _card.name = value;
                            },
                            keyboardType: TextInputType.text,
                            validator: (String? value) => value!.isEmpty || value.length < 4 ? Strings.fieldReq : null,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          // height: 40.h,
                          child: TextFormField(
                            enabled: isEnabled,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 13.sp,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(19),
                              CardNumberInputFormatter(),
                            ],
                            controller: widget.cardNumberController,
                            decoration: InputDecoration(
                              isDense: true,
                              hintStyle: TextStyle(
                                fontSize: 13.sp,
                              ),
                              suffixIcon: CardUtils.getCardIcon(paymentCard.type),
                              hintText: S.of(context).CardNumber,
                              prefixIcon: Image.asset(
                                '${imagePath}card_number.png',
                                package: 'ottu',
                                scale: 3.5,
                                color: secondaryGreyColor,
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
                            onSaved: (String? value) {
                              paymentCard.number = CardUtils.getCleanedNumber(value!);
                            },
                            validator: CardUtils.validateCardNum,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: SizedBox(
                                // height: 40.h,
                                child: TextFormField(
                                  enabled: isEnabled,
                                  cursorColor: primaryColor,
                                  controller: widget.dateController,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4), CardMonthInputFormatter()],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                    hintStyle: TextStyle(
                                      fontSize: 13.sp,
                                    ),
                                    prefixIcon: Image.asset(
                                      '${imagePath}card_date.png',
                                      package: 'ottu',
                                      scale: 3.5,
                                      color: secondaryGreyColor,
                                    ),
                                    hintText: S.of(context).MM_YY,
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
                                  validator: CardUtils.validateDate,
                                  keyboardType: TextInputType.number,
                                  onSaved: (value) {
                                    List<int> expiryDate = CardUtils.getExpiryDate(value!);
                                    paymentCard.month = expiryDate[0];
                                    paymentCard.year = expiryDate[1];
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: SizedBox(
                                // height: 40.h,
                                child: TextFormField(
                                  enabled: isEnabled,
                                  cursorColor: primaryColor,
                                  controller: widget.cvvController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  onChanged: (v) {
                                    setState(() {
                                      widget.paybuttonCallback(v);
                                    });
                                    if (v.length == 3) {
                                      setState(() {
                                        payType = 'paywithcard';
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.all(10),
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
                                    paymentCard.cvv = int.parse(value!);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.sp,
                        ),
                        if (widget.cansavecard)
                          Row(
                            children: [
                              CustomRadio(
                                // activeColor: primaryColor,
                                selected: widget.isChecked,
                                onChanged: (value) {
                                  widget.setIsChecked();
                                },
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                S.of(context).ClickToSaveYourCard,
                                style: TextStyle(fontSize: 11.sp),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Dialogs().showCardSaveDialog(context);
                                },
                                child: const Icon(
                                  Icons.info,
                                  color: blackColor,
                                ),
                              )
                            ],
                          ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getImageWidget(String imageUrl) {
    if (imageUrl.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl,
        width: 50,
      );
    } else {
      return Image.network(
        imageUrl,
        width: 50,
        errorBuilder: (context, error, stackTrace) {
          // Custom widget to display when image loading fails
          return Container(
            width: 40,
            height: 40,
            color: Colors.grey, // You can customize the color as needed
          );
        },
      );
    }
  }
}
