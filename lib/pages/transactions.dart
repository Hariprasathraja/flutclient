import 'package:flutter/material.dart';
import 'home_page.dart';
class TransactionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Transactions',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '',
                style: TextStyle(color: Colors.black, fontSize: 14.0),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Filter buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('All', true),
                _buildFilterButton('Income', false),
                _buildFilterButton('Expense', false),
              ],
            ),
            SizedBox(height: 16),

            // Transaction List
            Text(
              'Today',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildTransactionItem('Grocery', '₹400', Icons.shopping_cart, true),
            _buildTransactionItem('IESCO Bill', '₹120', Icons.receipt, true),
            SizedBox(height: 16),

            Text(
              'Yesterday',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildTransactionItem('Fund Transferred', '₹1,200', Icons.swap_horiz, false),
            _buildTransactionItem('Mobile Bill', '₹235', Icons.phone_android, true),
            _buildTransactionItem('Salary', '₹6,500', Icons.attach_money, false),
            _buildTransactionItem('Card Payment', '₹155', Icons.credit_card, true),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Highlight the Transactions tab
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
            case 0: //Homepage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>HomeScreen()),
                );
                break;
          }
        },
      ),
    );
  }

  // Function to build a filter button
  Widget _buildFilterButton(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF044D4F) : Colors.grey[300],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Function to build transaction item
  Widget _buildTransactionItem(String title, String amount, IconData icon, bool isExpense) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(icon, color: Colors.black),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16.0)),
                ],
              ),
            ),
            Text(
              isExpense ? '-$amount' : amount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: isExpense ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
