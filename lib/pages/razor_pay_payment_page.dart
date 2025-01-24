import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:get/get.dart';
import '../utilities/image_constants.dart';
import '../widget/app_bar_widget.dart';
import '../widget/loading_Indicator_widget.dart';
import '../widget/toast_message.dart';
import 'dart:async' show Timer;

class RazorPayPaymentPage extends StatefulWidget {
  final String? amount;
  final  String?rzKey;
  final String? name;
  final String? phone;
  final String? email;
  final String? description;
  final Function? onSuccess;
  final String? rzOrderId;
   const RazorPayPaymentPage({super.key,this.amount,this.rzKey,this.onSuccess,
   this.email,
     this.phone,
     this.name,
     this.description,
     this.rzOrderId
   });

  @override
  State<RazorPayPaymentPage> createState() => _RazorPayPaymentPageState();
}

class _RazorPayPaymentPageState extends State<RazorPayPaymentPage> {
  bool _isLoading =true;
  bool paymentSuccess=false;
  Razorpay? _razorpay;
  String rzOrderId="";
  int counterValue=8;
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    initRazorPay();
    getAndSetData();
    super.initState();
  }

  initRazorPay(){
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    IToastMsg.showMessage("Payment success don't close the app");
    setState(() {
      paymentSuccess=true;
      _isLoading=false;
    });
    _startTimer(response.paymentId??"");
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    IToastMsg.showMessage("Payment error");
    setState(() {
      paymentSuccess=false;
      _isLoading=false;
    });
    Get.back();
  }
  void _handleExternalWallet(ExternalWalletResponse response) {
    IToastMsg.showMessage("Something went wrong");
    setState(() {
      paymentSuccess=false;
      _isLoading=false;

    });
    Get.back();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    if(_razorpay!=null){_razorpay!.clear();}
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isLoading||paymentSuccess?false:true,
      child: Scaffold(
        appBar: IAppBar.commonAppBar(title: "Payment"),
        body:_isLoading?const ILoadingIndicatorWidget(): _buildBody(),
      ),
    );
  }

  void getAndSetData() async{
    setState(() {
      _isLoading=true;
    });
    rzOrderId=widget.rzOrderId??"";
    openCheckOut(rzOrderId);

  }
  _buildBody()
  {
    return  Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Image.asset(ImageConstants.paymentSuccessImageBox,
           height: 200,
           ),
          const Text("Payment Success",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18
          ),),
          const SizedBox(height: 10),
          Text("Please wait, while we are processing order id: $rzOrderId",
            textAlign: TextAlign.center,
            style:const  TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500
            ),),
          const SizedBox(height: 10),
          Text("$counterValue (s)",
            style:const  TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500
            ),)
        ],
      ),
    );
  }
  openCheckOut(orderId){
    final amountN=((double.parse(widget.amount??"0")*100).toInt()).toString();
    var options = {
      'key':widget.rzKey,
      'amount':amountN,
      'name': widget.name,
      'order_id':orderId,
      'description': widget.description ?? "",
      'prefill': {
        'contact': widget.phone ?? "",
        'email': widget.email
      },
      "notify": {"sms": true, "email": false},
      "method": {
        "netbanking": true,
        "card": true,
        "wallet": false,
        'upi': true,
      },
    };
    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint('Error: e');
      setState(() {
        _isLoading=false;
      });
      Get.back();
    }
  }
  void _startTimer(String paymentId) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        counterValue--;
      });
      if(counterValue==0){
        _stopTimer();
        Get.back();
        if( widget.onSuccess!=null)
       {
         widget.onSuccess!();
       }
      }
    });

  }
  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
