import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utilities/image_constants.dart';
import '../widget/app_bar_widget.dart';
import '../widget/loading_Indicator_widget.dart';
import '../widget/toast_message.dart';
import 'dart:async' show Timer;
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

class StripePaymentPage extends StatefulWidget {
  final  String?stripeKey;
  final String? name;
  final String? state;
  final String? address;
  final String? country;
  final String? city;
  final Function? onSuccess;
  final String? orderId;
  final String? clientSecret;
  final String? customerId;
  const StripePaymentPage({super.key,this.stripeKey,this.onSuccess,
    this.city,
    this.address,
    this.name,
    this.orderId,
    this.clientSecret,
    this.customerId,
    this.country,
    this.state
  });

  @override
  State<StripePaymentPage> createState() => _StripePaymentPageState();
}

class _StripePaymentPageState extends State<StripePaymentPage> {
  bool _isLoading =true;
  bool paymentSuccess=false;
  String orderId="";
  int counterValue=8;
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    initStripePay();
    super.initState();
  }

  initStripePay(){
    stripe.Stripe.publishableKey = widget.stripeKey??"";
    getAndSetData();
  }
  void _handlePaymentSuccess(paymentId) async {
    IToastMsg.showMessage("Payment success don't close the app");
    setState(() {
      paymentSuccess=true;
      _isLoading=false;
    });
    _startTimer(paymentId??"");
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
    orderId=widget.orderId??"";
    openCheckOut();

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
          Text("Please wait, while we are processing order id: $orderId",
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
  openCheckOut()async{
    setState(() {
      _isLoading=true;
    });
    try {
      await stripe.Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: stripe.SetupPaymentSheetParameters(
              customerId: widget.customerId,
              billingDetails:  stripe.BillingDetails(
                  name: widget.name,
                  address: stripe.Address(
                      state: widget.state,
                      postalCode: "",
                      line2:widget.address,
                      country: widget.country,
                      city: widget.city,
                      line1: widget.address)),
              paymentIntentClientSecret: widget.clientSecret, // Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'User'))
          .then((value) {
        displayPaymentSheet();
      });
    } catch (err) {
      if(kDebugMode){print(err);}
      setState(() {
        _isLoading=false;
      });
      Get.back();
      // throw Exception(err);
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

  displayPaymentSheet() async {
    setState(() {
      _isLoading=true;
    });
    try {

      await stripe.Stripe.instance.presentPaymentSheet().then((value) {
        // successPayment(paymentIntent['id']);
        _handlePaymentSuccess(widget.orderId);

      }).onError((error, stackTrace) {
        setState(() {
          _isLoading=false;
        });
        throw Exception(error);

      });
    } on stripe.StripeException catch (e) {
      if(kDebugMode){
        print(e);
      }

      setState(() {
        _isLoading=false;
      });
      Get.back();
    } catch (e) {
      setState(() {
        _isLoading=false;
      });
      Get.back();
    }
  }
}
