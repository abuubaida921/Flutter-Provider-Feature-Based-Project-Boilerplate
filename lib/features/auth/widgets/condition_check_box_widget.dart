import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/custom_themes.dart';
import '../../../util/dimensions.dart';
import '../../splash/controllers/splash_controller.dart';
import '../controllers/auth_controller.dart';


class ConditionCheckBox extends StatelessWidget {
  const ConditionCheckBox({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController splashController = Provider.of<SplashController>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Consumer<AuthController>(
        builder: (ctx, authController, _){
          return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            InkWell(
              onTap: ()=> authController.toggleTermsCheck(),
              child: Row(children: [
                SizedBox(width : 20, height : 20,
                  child: Container(alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.75), width: 1.5),
                          borderRadius: BorderRadius.circular(6)),
                      child: Icon(CupertinoIcons.checkmark_alt,size: 15,
                          color: authController.isAcceptTerms? Theme.of(context).primaryColor.withValues(alpha:.75): Colors.transparent))),
              ]),
            ),
            Text('i_agree_with_the',  style: textMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            )),
            InkWell(
              // onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => HtmlViewScreen(
              //   title: getTranslated('terms_condition', context),
              //   url: splashController.configModel?.termsConditions,
              // ))),

              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Text('terms_condition', style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor.withValues(alpha:0.8),
                  decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor,
                )),
              ),
            ),
          ]);
        }
      ),
    );
  }
}
