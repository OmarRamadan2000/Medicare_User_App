import 'package:flutter/material.dart';
import '../helpers/theme_helper.dart';

class ISearchBox{
  static buildSearchBox({required TextEditingController? textEditingController,String? labelText,onFieldSubmitted}){
   return  Container(
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        onFieldSubmitted: (value){onFieldSubmitted();},
        keyboardType: TextInputType.name,
        controller: textEditingController,
        decoration: ThemeHelper().textInputDecoration(labelText??"",const Icon(Icons.search)),
      ),
    );
  }
  static buildSearchBoxMap({required TextEditingController? textEditingController,String? labelText,Function()?onTap,
    bool? disabled}){
    return  Container(
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        onTap:onTap ,
        keyboardType: TextInputType.name,
        controller: textEditingController,
        decoration: ThemeHelper().textInputDecoration(labelText??"",const Icon(Icons.search)),
        readOnly: disabled??false,
      ),
    );
  }
}

