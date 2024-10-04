import 'package:grpc/grpc.dart';
import 'generated/bank.pbgrpc.dart';  // Import the generated .pbgrpc.dart files


class Bankserviceclient {
  late AccountServiceClient client;
  late ClientChannel channel;

  Bankserviceclient() {
    channel = ClientChannel(
      '192.168.161.119', // Change this to your server's address
      port: 50051, // Ensure this matches your gRPC server's port
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    client = AccountServiceClient(channel);
  }

  // Function to close the channel when done
  void shutdown() async {
    await channel.shutdown();
  }

  // Create Account
  Future<CreateAccountResponse> createAccount(String name, double initialBalance) async {
    final request = CreateAccountRequest()
      ..name = name
      ..initialBalance = initialBalance;
    return await client.createAccount(request);
  }

  // Transfer Amount
  Future<TransferAmountResponse> transferAmount(int fromAccount, int toAccount, double amount) async {
    final request = TransferAmountRequest()
      ..fromAccount = fromAccount
      ..toAccount = toAccount
      ..transferAmount = amount;
    return await client.transferAmount(request);
  }

  // Get Account Details
  Future<AccountDetails> getAccountDetails(int accountNumber) async {
    final request = AccountRequest()..accountNumber = accountNumber;
    return await client.getAccountDetails(request);
  }

  // Get Transaction History
  Future<TransactionHistoryResponse> getTransactionHistory(int accountNumber) async {
    final request = TransactionHistoryRequest()..accountNumber = accountNumber;
    return await client.getTransactionHistory(request);
  }
}
