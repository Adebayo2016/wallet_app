import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:url_launcher/url_launcher_string.dart';
//import 'package:walletconnect_flutter_v2/apis/core/relay_client/json_rpc_2/src/client.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/session_models.dart';
import 'package:walletconnect_flutter_v2/apis/utils/namespace_utils.dart';
import 'package:web3dart/web3dart.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart';

import '../metamask_service.dart';

class DataController extends GetxController {

  String? AmountFromwallet;
  String? fromAmount;
  static String? _url;
  static SessionData? _sessionData;
  late Web3Client web3client;
  var token = '';
  String testAddress = '0xA32Ed59011F366632fb2D03a7A0Cade4cf11E4Ee';


  String? setAmountFromwallet(String amount) {
    AmountFromwallet = amount;
    return AmountFromwallet;
  }



  initiateWebviewTransaction() async {
    final Completer<WebViewController> _controller = Completer<
        WebViewController>();

   WebViewController controller = await _controller.future;

    String message = AmountFromwallet.toString();
    controller.runJavaScript('handleReceiveMessage("$message")');

  }


  // connectToMetaMask() async {
  //
  //   MetaMaskServiceImp().connectWithMetamaskWallet(
  //     onSessionUpdate: (session) {
  //       // setState(() {
  //       //   print('session ${session.data()}-+++++++++++++=');
  //       // });
  //     },
  //     onDisplayUri: (uri) {
  //       setState(() {
  //         _url = uri;
  //       });
  //       launchUrlString(uri,
  //           mode: LaunchMode.externalApplication);
  //     },
  //   ).then((result) {
  //     result.fold((failure) {
  //       print('Failed to connect: $failure');
  //     }, (connectResponse) async {
  //       print('Updated session+++++++++ $connectResponse');
  //       _sessionData = await connectResponse.session.future;
  //       String walletAccount = NamespaceUtils.getAccount(
  //         _sessionData!
  //             .namespaces.values.first.accounts.first,
  //       );
  //       print('account ++++++++--------$walletAccount');
  //       web3client = Web3Client(
  //           'https://polygon-mumbai.infura.io/v3/d0f4119a707544e7b1fcbc93c9bf659e',
  //           Client());
  //       EthereumAddress address =
  //       EthereumAddress.fromHex(walletAccount);
  //       EtherAmount etherBalance =
  //       await web3client.getBalance(address);
  //
  //       token = web3client
  //           .getTransactionCount(address)
  //           .toString();
  //
  //       print(
  //           '+++===Matic balance at address: ${etherBalance.getValueInUnit(EtherUnit.ether)}');
  //       // ignore: use_build_context_synchronously
  //       // var response = await transferToken(context);
  //       EthereumAddress toAddress =
  //       EthereumAddress.fromHex(testAddress);
  //       var response =
  //       await query('balanceOf', [toAddress]);
  //       print('++++++++CELT Balance: $response');
  //       setState(() {
  //         maticAmount = etherBalance
  //             .getValueInUnit(EtherUnit.ether)
  //             .toString();
  //         celtAmount = response[0].toString();
  //         account = walletAccount;
  //
  //       });
  //     });
  //   });
  //
  // }
  // Future<List<dynamic>> query(String name, List<dynamic> args) async {
  //   final contract = await loadContract();
  //   final ethFunction = contract.function(name);
  //   final result = await web3client.call(
  //       contract: contract, function: ethFunction, params: args);
  //   return result;
  // }
  //
  //
  // Future approve(BuildContext context) async {
  //   BigInt bigAmount = BigInt.from(10e18);
  //   EthereumAddress toAddress = EthereumAddress.fromHex(testAddress);
  //   var response = await submit("approve", [toAddress, bigAmount], context);
  //   return response;
  // }

}
