import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:userapp/pages/stripe_payment_page.dart';
import 'package:userapp/services/stripe_service.dart';
import '../model/user_model.dart';
import '../pages/razor_pay_payment_page.dart';
import '../services/payment_gateway_service.dart';
import '../utilities/image_constants.dart';
import '../controller/txn_controller.dart';
import '../controller/user_controller.dart';
import '../helpers/date_time_helper.dart';
import '../helpers/theme_helper.dart';
import '../model/txn_model.dart';
import '../services/razor_pay_service.dart';
import '../services/user_service.dart';
import '../utilities/app_constans.dart';
import '../utilities/colors_constant.dart';
import '../widget/app_bar_widget.dart';
import '../widget/button_widget.dart';
import '../widget/loading_Indicator_widget.dart';
import '../widget/toast_message.dart';
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final ScrollController _scrollController=ScrollController();
  final  TextEditingController _amountController=TextEditingController();
  final TxnController txnController=Get.put(TxnController());
  UserController userController=Get.find(tag: "user");
  bool _paymentLoading = false;
  List <int> amountList=[250,500,1000,1500,2000];
  bool _isLoading=false;
  String? keyId;
  String? keySecret;
  int? paymentGetawayId;
  bool activePaymentGetaway=false;
  UserModel? userModel;
  String? activePaymentGatewayName;
  String? activePaymentGatewayKey;
  String? activePaymentGatewaySecret;
  final GlobalKey<FormState> _formKey2 =  GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    txnController.getData();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    getAndSetData();
    txnController.getData();
    super.initState();
  }

  successPayment()async {
    IToastMsg.showMessage("success");
      txnController.getData();
      userController.getData();
    setState(() {
      _paymentLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_paymentLoading,
      child: Scaffold(
        backgroundColor: ColorResources.bgColor,
       appBar: IAppBar.commonAppBar(title: "Wallet"),
        body: _isLoading?const ILoadingIndicatorWidget():_paymentLoading
            ? const ILoadingIndicatorWidget(): _buildBody(),
      ),
    );
  }

  _buildBody() {
    return ListView(
      controller: _scrollController,
      padding:const EdgeInsets.all(8),
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: ColorResources.secondaryColor,
          ),
          height: 200,
          child: Stack(
            children: [
              Positioned(
                  top:0,
                  right:0,
                  bottom:0,
                  left:0,
                  child: Image.asset(ImageConstants.containerBgImage)),
              Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Text("Current balance",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),),
                  FutureBuilder(
                      future: UserService.getDataById(),
                      builder: (context,AsyncSnapshot snapshot) {
                        return RichText(
                          text:  TextSpan(
                            text: '${AppConstants.appCurrency}${snapshot.hasData?snapshot.data?.walletAmount??0:0}',
                            style:  const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            ),
                            children: const <TextSpan>[
                              TextSpan(text: '',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                  )
                              ),

                            ],
                          ),
                        );
                      }
                  ),
                  const SizedBox(height: 20),
                  SmallButtonsWidget(
                      rounderRadius: 20,
                      color: ColorResources.greenFontColor,
                      width: 200,
                      title: "+ Add Money", onPressed: (){
                    _openBottomSheet();

                  })
                ],
              )
              )
            ],
          ),
        ),
        const ListTile(title: Text("Transaction History",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16
          ),
        ),),
        Obx(() {
          if (!txnController.isError.value) { // if no any error
            if (txnController.isLoading.value) {
              return const IVerticalListLongLoadingWidget();
            } else if (txnController.dataList.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("No transaction found"),
              );
            } else {
              return
                _buildConsultationList(txnController.dataList);
            }
          }else {
            return Container();
          } //Error svg
        }
        )

      ],
    );
  }

  _buildConsultationList(List dataList) {

    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount:dataList.length,
        itemBuilder: (context,index){
          TxnModel txnModel=dataList[index];
          return  Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: .1,
            child: ExpansionTile(
              title:
              Text("${txnModel.amount??"--"}${AppConstants.appCurrency}",
                    style:  TextStyle(
                      color:  txnModel.type=="Credited"?Colors.green:txnModel.type=="Debited"?Colors.red:null,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),
                  ),

              trailing:   Text(txnModel.type??"--",
                style:   TextStyle(
                    color: txnModel.type=="Credited"?Colors.green:txnModel.type=="Debited"?Colors.red:null,
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                ),
              ),
              subtitle:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  txnModel.notes==null||txnModel.notes==""?Container():  Text(txnModel.notes??"",
                    style: const TextStyle(
                        color: ColorResources.secondaryFontColor ,
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                    ),
                  )   ,
                  Text(DateTimeHelper.getDataFormatWithTime(txnModel.createdAt??""),
                    style: const TextStyle(
                        color: ColorResources.secondaryFontColor ,
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ),
           //   notes
              leading:     txnModel.type=="Credited"?
              const CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 10,
                  child: Icon(Icons.add,
                    color: Colors.white,
                    size: 12,
                  )
              ):txnModel.type=="Debited"?
              const CircleAvatar(
                backgroundColor: Colors.redAccent,
                radius: 10,
                child: Icon(Icons.remove,
                  color: Colors.white,
                  size: 12,
                ),
              ): Container(),
              children: [
                const SizedBox(height: 3),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Transaction Id: ${txnModel.id??"--"}",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: ColorResources.secondaryFontColor ,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
              ],
            ),
          );

        });
  }
  _openBottomSheet(){
    final formKey = GlobalKey<FormState>();
    return
      showModalBottomSheet(
        isScrollControlled: true,
        shape:  const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Add Money",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),),
                      IconButton(
                          onPressed: (){
                            Get.back();
                          }, icon: const Icon(Icons.close)),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$')), // Limit to two decimal places
                        ],
                        validator: ( item){
                          if(item!.isEmpty){
                            return "Enter Valid Amount";
                          }
                          else if(item.isNotEmpty){
                            if(int.parse(item)<=0||int.parse(item)>5000){
                              return "Enter Amount Between 1${AppConstants.appCurrency} To 5000${AppConstants.appCurrency}";
                            }else    if(int.parse(item)>0){
                              return null;
                            }
                          }
                          return null;
                        },
                        controller: _amountController,
                        decoration: ThemeHelper().textInputDecoration('Amount'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        childAspectRatio: 1.7,
                        // crossAxisSpacing: 20,
                        // mainAxisSpacing: 20
                      ),
                      itemCount: amountList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return GestureDetector(
                          onTap: (){
                            _amountController.text=amountList[index].toString();
                          },
                          child: Card(
                              color: Colors.grey.shade100,
                              elevation: .1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child:Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${AppConstants.appCurrency}${amountList[index]}",
                                  textAlign: TextAlign.center,
                                  style:const TextStyle(
                                      color: ColorResources.primaryFontColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400
                                  ),),
                              )
                          ),
                        );
                      }),
                  const SizedBox(height: 10),
                  SmallButtonsWidget(title: "Process", onPressed: (){
                    Get.back();
                    if(activePaymentGatewayName=="Razorpay"){
                      createOrder();
                    }
                   else  if(activePaymentGatewayName=="Stripe"){
                     showStripeDetailsBottomSheet();
                    }
                    else{
                      IToastMsg.showMessage("No active payment gateway");
                    }
                  })

                ],
              ),
            ),
          );
        },
      ).whenComplete(() {

      });
  }

  void getAndSetData() async{
    setState(() {
      _isLoading=true;
    });
    final res=await UserService.getDataById();
    if(res!=null){
      userModel=res;
      _nameController.text="${userModel?.fName??"User"} ${userModel?.lName??""}";
    }
    final activePG=await PaymentGatewayService.getActivePaymentGateway();
    if(activePG!=null){
      activePaymentGatewayName=activePG.title;
      activePaymentGatewaySecret=activePG.secret;
      activePaymentGatewayKey=activePG.key;
    }
    setState(() {
      _isLoading=false;
    });

  }

  void createOrder() async{
    setState(() {
      _isLoading=true;
    });
    final res=await RazorPayService.createOrderWallet(amount: _amountController.text, key: activePaymentGatewayKey??"", secret:activePaymentGatewaySecret??"");
    if(res!=null){
      if(kDebugMode){
        print("Order Id ${res['id']}");
      }
      final orderId=res['id'];
      if(orderId!=null||orderId!=""){
        final String countryCodeWithNumber="${userModel?.isdcode??""}${userModel?.phone??""}";
        Get.to(()=>RazorPayPaymentPage(
          name: "${userModel?.fName??"User"} ${userModel?.lName??"User"}",
          description: "Amount credited to user wallet",
          email: userModel?.email??"",
          phone:  countryCodeWithNumber,
          amount: _amountController.text,
          onSuccess: successPayment,
          rzKey: activePaymentGatewayKey,
          rzOrderId:orderId ,
        ));
      }else{
        IToastMsg.showMessage("Something went wrong");
      }
    }
    setState(() {
      _isLoading=false;
    });
  }

  void createOrderStripe() async{
    setState(() {
      _isLoading=true;
    });
    final res=await StripeService.createStripeIntentWallet(
      amount: _amountController.text,
      secret:activePaymentGatewaySecret??"",
      name:_nameController.text,
      address:_addressController.text ,
      city:_cityController.text ,
      country:_countryController.text ,
      state: _stateController.text,
    );
    if(res!=null){
      if(kDebugMode){
        print("Order Id ${res['id']}");
      }
      final orderId=res['id'];
      if(orderId!=null||orderId!=""){
        Get.to(()=>StripePaymentPage(
          name:_nameController.text,
          address:_addressController.text ,
          city:_cityController.text ,
          country:_countryController.text ,
          state: _stateController.text,
          onSuccess: successPayment,
          stripeKey: activePaymentGatewayKey,
          orderId:orderId ,
          customerId: res['customer_id'] ,
          clientSecret:res['client_secret'] ,
        ));
      }else{
        IToastMsg.showMessage("Something went wrong");
      }
    }
    setState(() {
      _isLoading=false;
    });
  }
  void showStripeDetailsBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child:
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _formKey2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text("Please fill the details",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: ( item){
                          return item!.length>3?null:"Enter name";
                        },
                        controller: _nameController,
                        decoration: ThemeHelper().textInputDecoration('Name*'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: ( item){
                          return item!.length>5?null:"Enter address";
                        },
                        controller: _addressController,
                        decoration: ThemeHelper().textInputDecoration('Address*'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: ( item){
                          return item!.length>3?null:"Enter city";
                        },
                        controller: _cityController,
                        decoration: ThemeHelper().textInputDecoration('City*'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: ( item){
                          return item!.length>3?null:"Enter State";
                        },
                        controller: _stateController,
                        decoration: ThemeHelper().textInputDecoration('State*'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: ( item){
                          return item!.length>3?null:"Enter Country";
                        },
                        controller: _countryController,
                        decoration: ThemeHelper().textInputDecoration('Country*'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SmallButtonsWidget(
                      title: "Proceed to pay",
                      onPressed: (){
                        if (_formKey2.currentState!.validate()) {
                          Navigator.pop(context);
                          createOrderStripe();
                        }
                      },
                    )

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
