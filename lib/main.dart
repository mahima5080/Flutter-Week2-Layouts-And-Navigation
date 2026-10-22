import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class Expense {
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Expense({required this.title, required this.amount, required this.category, required this.date});
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker UI App',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Expense> _expenses = [
    Expense(title: 'Groceries', amount: 450.0, category: 'Food', date: DateTime.now()),
    Expense(title: 'Bus Pass', amount: 120.0, category: 'Transport', date: DateTime.now()),
  ];

  void _addExpense(String title, double amount, String category) {
    setState(() {
      _expenses.add(
        Expense(title: title, amount: amount, category: category, date: DateTime.now()),
      );
      _selectedIndex = 0; // Switch to Dashboard after adding
    });
  }

  double get _totalExpense {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DashboardScreen(expenses: _expenses, total: _totalExpense),
      AddExpenseScreen(onAddExpense: _addExpense),
      HistoryScreen(expenses: _expenses),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Mahima Chaudhari'),
              accountEmail: Text('mahima@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.indigo),
              ),
              decoration: BoxDecoration(color: Colors.indigo),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text('Add Expense'),
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Expense History'),
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add Expense'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}

// 1. Dashboard Screen
class DashboardScreen extends StatelessWidget {
  final List<Expense> expenses;
  final double total;

  const DashboardScreen({super.key, required this.expenses, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            color: Colors.indigo[600],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text('Total Spending', style: TextStyle(fontSize: 18, color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('₹${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text('No expenses recorded.'))
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final item = expenses[index];
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.indigoAccent,
                            child: Icon(Icons.receipt_long, color: Colors.white),
                          ),
                          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(item.category),
                          trailing: Text('₹${item.amount.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// 2. Add Expense Screen
class AddExpenseScreen extends StatefulWidget {
  final Function(String, double, String) onAddExpense;

  const AddExpenseScreen({super.key, required this.onAddExpense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';

  final List<String> _categories = ['Food', 'Transport', 'Shopping', 'Bills', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Expense Title', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
            items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
            onChanged: (val) => setState(() => _selectedCategory = val!),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              final title = _titleController.text.trim();
              final amount = double.tryParse(_amountController.text.trim());

              if (title.isNotEmpty && amount != null && amount > 0) {
                widget.onAddExpense(title, amount, _selectedCategory);
              }
            },
            child: const Text('Add Expense', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

// 3. Expense History Screen
class HistoryScreen extends StatelessWidget {
  final List<Expense> expenses;

  const HistoryScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: expenses.isEmpty
          ? const Center(child: Text('History is empty.'))
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final e = expenses[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.payment, color: Colors.indigo[700]),
                    title: Text(e.title),
                    subtitle: Text('${e.category} • ${e.date.day}/${e.date.month}/${e.date.year}'),
                    trailing: Text('₹${e.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
    );
  }
}