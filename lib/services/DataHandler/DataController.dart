import 'dart:async';
import 'dart:convert';
import 'dart:developer';


import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/apis/core/pairing/utils/pairing_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/json_rpc_models.dart';
//import 'package:walletconnect_flutter_v2/apis/core/relay_client/json_rpc_2/src/client.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/session_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/sign_client_models.dart';
import 'package:walletconnect_flutter_v2/apis/utils/namespace_utils.dart';
import 'package:walletconnect_flutter_v2/apis/web3app/web3app.dart';
import 'package:web3dart/web3dart.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart';

import '../EthereumTransaction.dart';
import '../metamask_service.dart';

class DataController extends GetxController {
  String urltest="https://bpetest.netlify.app/";
//  String newmessage='javascript:handleReceiveMessage("Hello, world!")';
  final bool _isConnected = false;
  var token = '';
  String maticAmount = '';
  String celtAmount = '';
  late Web3Client web3client;
  late DeployedContract contract;
  String contractAddress = "0x3a31275aA3a516FAA6C0325aA7bDDD2FbCBBa666";
  String testAddress = '0xA32Ed59011F366632fb2D03a7A0Cade4cf11E4Ee';
  String? account;
  static String? _url;
  String? deeplinkUrl;
  String get deepLink => 'metamask://wc?uri=$_url';


  static SessionData? _sessionData;

  String deeplinkUrl2 =
"metamask://wc?uri=wc:80f55ba4d073df27d07db2135987d4af9eb6718ab66ee9e5695b8db9175cdfa5@2?relay-protocol=irn&symKey=ce8d10f8d46f88725f0f4bb79d51b19b166779357c06908f085cd329621196b3&methods=%5Bwc_sessionPropose%2Cwc_sessionRequest%5D%2C%5Bwc_authRequest%5D";
  final WebViewController controller =
  WebViewController.fromPlatformCreationParams(
      const PlatformWebViewControllerCreationParams());

  @override
  void onInit() {
    log("this is the final deeplink url $deepLink");

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("Flutter",
        onMessageReceived: (JavaScriptMessage message) {
          AmountFromwallet=message.message;
          print("ammount is $AmountFromwallet");
          setAmountFromwallet(AmountFromwallet!);

          // String newmessage='javascript:handleReceiveMessage("Hello, world!")';
          //
          // controller.loadRequest(Uri.parse(newmessage));
          // Dart code
          // Send a message to JavaScript

  initiateWebviewTransaction();

          print('Message from WebView: ${message.message}');
        },


      )
      ..loadRequest(
          Uri.parse(urltest
            // 'https://bpe-cardiscardis.vercel.app?account=$account'
          ));

    super.onInit();
  }

  String? AmountFromwallet='';
  String? fromAmount;


  String? setAmountFromwallet(String amount) {
    AmountFromwallet = amount;
   // Get.snackbar('Message from WebView', AmountFromwallet!);
    print("Amount from wallet: $AmountFromwallet");
    update();
    return AmountFromwallet;

  }



  initiateWebviewTransaction() async {
    print("i have started the transaction");
    String messages = maticAmount;

    try {
      controller.runJavaScript('window.receiveMessageFromFlutter({ fromFlutter: true, message: "$messages" });');
  //    controller.runJavaScript('window.receiveMessageFromFlutter({data: "$messages" };');

    } catch (e) {
      print('Error running JavaScript: $e');
    }
  }


  connectToMetaMask() async {
    // MetaMaskServiceImp().connectWithMetamaskWallet(
    //   onSessionUpdate: (session) {
    //     print("this is the session in sessionUpdate $session");
    //     // setState(() {
    //     //   print('session ${session.data()}-+++++++++++++=');
    //     // });
    //   },
    //   onDisplayUri: (uri) {
    //     _url = uri;
    //     launchUrlString(uri,
    //         mode: LaunchMode.externalApplication);
    //     update();
    //   },
    // ).then((result) {
    //   result.fold((failure) {
    //     print('Failed to connect: $failure');
    //   }, (connectResponse) async {
    //     print('Updated session+++++++++ $connectResponse');
    //     _sessionData = await connectResponse.session.future.then((value) {
    //       _sessionData= value;
    //       print("session data  here is $value");
    //       return value;
    //     });
    //     String walletAccount = NamespaceUtils.getAccount(
    //       _sessionData!
    //           .namespaces.values.first.accounts.first,
    //     );
    //     print('account ++++++++--------$walletAccount');
    //     web3client = Web3Client(
    //         'https://polygon-mumbai.infura.io/v3/d0f4119a707544e7b1fcbc93c9bf659e',
    //         Client());
    //     EthereumAddress address =
    //     EthereumAddress.fromHex(walletAccount);
    //     EtherAmount etherBalance =
    //     await web3client.getBalance(address);
    //
    //     token = web3client
    //         .getTransactionCount(address)
    //         .toString();
    //
    //     print(
    //         '+++===Matic balance at address: ${etherBalance.getValueInUnit(EtherUnit.ether)}');
    //     // ignore: use_build_context_synchronously
    //     // var response = await transferToken(context);
    //     EthereumAddress toAddress =
    //     EthereumAddress.fromHex(testAddress);
    //     var response =
    //     await query('balanceOf', [toAddress]);
    //     print('++++++++CELT Balance: $response');
    //     maticAmount = etherBalance
    //         .getValueInUnit(EtherUnit.ether)
    //         .toString();
    //     celtAmount = response[0].toString();
    //     account = walletAccount;
    //     update();
    //
    //     // setState(() {
    //     //
    //     // });
    //   });
    // });

    final metaMaskService = MetaMaskServiceImp();


    metaMaskService.connectWithMetamaskWallet(
      onSessionUpdate: (session) {
        print('Session updated');
        update();
      },
      onDisplayUri: (uri) {
        update();
        // setDeepLinkurl(uri);
        launchUrlString(uri, mode: LaunchMode.externalApplication);
      },
    ).then((result) {
      result.fold((failure) {
        print('Connection failed: $failure');
      }, (connectResponse) async {

        print("connection response" + connectResponse.toString());
        handleConnectResponse(connectResponse);
      });
    });
  }

// Function to handle the response from the connection
  Future<void> handleConnectResponse(ConnectResponse connectResponse) async {
    _sessionData = await connectResponse.session.future;
    print('Session completed');


try {
   String walletAccount = NamespaceUtils.getAccount(
      _sessionData!.namespaces.values.first.accounts.first,
    );
    print('Account: $walletAccount');

    web3client = Web3Client(
      'https://polygon-mumbai.infura.io/v3/d0f4119a707544e7b1fcbc93c9bf659e',
      Client(),
    );

    // Get the balance and token
    await getBalanceAndToken(walletAccount);

} catch (e) {
  print('Error in Response : $e'); 
   

    // Initialize the Web3 client
    
  };
  }

// Function to get the balance and token
  Future<void> getBalanceAndToken(String walletAccount) async {
    EthereumAddress address = EthereumAddress.fromHex(walletAccount);
    EtherAmount etherBalance = await web3client.getBalance(address);
    int transactionCount = await web3client.getTransactionCount(address);
    token = transactionCount.toString();
    print("this is the token $token");

    num matBalance = await etherBalance.getValueInUnit(EtherUnit.ether);
    maticAmount=matBalance.toString();

    print('Matic balance: ${etherBalance.getValueInUnit(EtherUnit.ether)}');

    EthereumAddress toAddress = EthereumAddress.fromHex(testAddress);
    var response = await query('balanceOf', [toAddress]);

    print('CELT Balance: $response');
    maticAmount = etherBalance.getValueInUnit(EtherUnit.ether).toString();
   // setMaticBalance(maticAmount);
    celtAmount = response[0].toString();
    account = walletAccount;
    print("account balance is $account");
    update();

  }
  Future<List<dynamic>> query(String name, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(name);
    final result = await web3client.call(
        contract: contract, function: ethFunction, params: args);
    return result;

  }


  // Future approve(BuildContext context) async {
  //   BigInt bigAmount = BigInt.from(10e18);
  //   EthereumAddress toAddress = EthereumAddress.fromHex(testAddress);
  //   var response = await submit("approve", [toAddress, bigAmount], context);
  //   print ("Approval response is$response");
  //   return response;
  // }



  Future<dynamic> submit(
      String name, List<dynamic> args, BuildContext context) async {
    final contract = await loadContract();
    // final encoded = contract.function(name).encodeCall(args);
    Web3App? wcClient = await createWeb3Instance();

    Transaction transaction = Transaction.callContract(
      from: EthereumAddress.fromHex(account!),
      contract: contract,
      function: contract.function(name),
      parameters: args,
    );

    EthereumTransaction ethereumTransaction = EthereumTransaction(
      from: account!,
      to: contractAddress,
      value: "0x0",
      data: hex.encode(List<int>.from(transaction.data!)),

      /// ENCODE TRANSACTION USING convert LIB
    );
    print("this is the url $deepLink");
    await launchUrlString(
      deeplinkUrl2,
      //deeplinkUrl!,
      mode: LaunchMode.externalApplication,
    );




    final signResponse = await wcClient.request(
      topic: _sessionData!.topic,
      chainId: "eip155:80001",
      request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [ethereumTransaction.toJson()]),
    );
    return signResponse;
  }

  Future<Web3App> createWeb3Instance() async {
    Web3App wcClient = await Web3App.createInstance(
      projectId: 'aa2f55bd083438976d9e912489dfdc53',
      metadata: const PairingMetadata(
        redirect: Redirect(),
        name: 'dApp (Requester)',
        description: 'A dapp that can request that transactions be signed',
        url: 'https://walletconnect.com',
        icons: ['https://avatars.githubusercontent.com/u/37784886'],
      ),
    );

    return wcClient;
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    final contract = DeployedContract(ContractAbi.fromJson(abi, "CELT"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

 String? setDeepLinkurl (String _url){
   deeplinkUrl = _url;
   print("original Deeplink url is $deeplinkUrl");
  // "metamask://wc?uri=$_url";
    update();
    return deeplinkUrl;

 }

 String? setMaticBalance (String matBalance){
    maticAmount = matBalance;
    print("this is the matic balance $maticAmount");
    update();
    return maticAmount;
 }

  Future transferToken(BuildContext context) async {
    BigInt bigAmount = BigInt.from(10e18);
    EthereumAddress toAddress = EthereumAddress.fromHex(testAddress);
    var response = await submit("transfer", [toAddress, bigAmount], context);
    print("response is this $response");
    return response;
  }

}
