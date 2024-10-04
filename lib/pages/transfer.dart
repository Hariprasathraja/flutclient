import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'transactions.dart';
import 'package:flutclient/generated/bank.pb.dart';
import 'package:flutclient/generated/bank.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class TransferApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TransferScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TransferScreen extends StatefulWidget {
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  String _selectedPurpose = 'Education';
  List<String> _purposes = ['Education', 'Food', 'Rent', 'Shopping'];
  String recipient='Hari';
  TextEditingController amountController=TextEditingController();
  late AccountServiceClient accountServiceClient;

  @override
  void initState(){
    super.initState();

    final channel=ClientChannel(
      'localhost',
      port:50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    accountServiceClient=AccountServiceClient(channel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text('Transfer', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // From Account
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              decoration: BoxDecoration(
                color: Color(0xFF044D4F),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '00342745928',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),

            // To Recipients
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.add, color: Colors.black),
                ),
                SizedBox(width: 16.0),
                // Sample Avatars (replace with actual data)
                _buildAvatar('Aliya'),
                _buildAvatar('Calira'),
                _buildAvatar('Bob'),
                _buildAvatar('Samy'),
                _buildAvatar('Sara'),
              ],
            ),
            SizedBox(height: 16.0),

            // Amount input
            TextField(
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '₹',
              ),
            ),
            SizedBox(height: 16.0),

            // Purpose dropdown
            DropdownButtonFormField<String>(
              value: _selectedPurpose,
              decoration: InputDecoration(
                labelText: 'Purpose',
              ),
              onChanged: (newValue) {
                setState(() {
                  _selectedPurpose = newValue!;
                });
              },
              items: _purposes.map((String purpose) {
                return DropdownMenuItem<String>(
                  value: purpose,
                  child: Text(purpose),
                );
              }).toList(),
            ),
            SizedBox(height: 32.0),

            // Send button
            ElevatedButton(
              onPressed: () async{
                try{
                  String input=amountController.text.replaceAll(RegExp('₹'),'');
                
                  if (input.isEmpty || double.tryParse(input) == null) {
                    throw FormatException("Invalid input");
                  }
                  double amount=double.parse(input);

                  final request=TransferAmountRequest(
                    fromAccount: 1,
                    toAccount: 2,
                    transferAmount: amount,
                  );
                  try{
                    final response=await accountServiceClient.transferAmount(request);

                    if (response.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Transfer Successful!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Transfer Failed: ${response.message}")),
                      );
                    }
                  }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Transfer Error: $e")),
                    );
                  }
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invalid amount"))
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
                backgroundColor: Color(0xFF044D4F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text('Send'),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Color(0xFF044D4F),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index){
          switch(index){
            case 2: //Transactions
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>TransactionsScreen()),
                );
                break;
          }
        },
      ),
    );
  }

  // Function to create an avatar for a contact
  Widget _buildAvatar(String name) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(
              'https://www.w3schools.com/w3images/avatar2.png'), // Placeholder
          radius: 24.0,
        ),
        SizedBox(height: 4.0),
        Text(name, style: TextStyle(fontSize: 12.0)),
      ],
    );
  }
}
