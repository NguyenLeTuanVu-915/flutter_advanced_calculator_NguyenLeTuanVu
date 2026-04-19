import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../providers/calculator_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProv = context.watch<HistoryProvider>();
    final calc = context.read<CalculatorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử tính toán'),
        actions: [
          if (historyProv.history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Xóa tất cả',
              onPressed: () => _confirmClear(context, historyProv),
            ),
        ],
      ),
      body: historyProv.history.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Chưa có lịch sử', style: TextStyle(color: Colors.grey)),
          ],
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: historyProv.history.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = historyProv.history[index];
          return ListTile(
            title: Text(
              item.expression,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            subtitle: Text(
              '= ${item.result}',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              _formatTime(item.timestamp),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () {
              // Bug 5 fix: setExpression thay vì addToExpression
              // addToExpression cộng thêm vào chuỗi hiện có → bị nhân đôi
              // setExpression thay thế hoàn toàn
              calc.setExpression(item.result);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _confirmClear(BuildContext context, HistoryProvider prov) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa lịch sử'),
        content: const Text('Bạn có chắc muốn xóa toàn bộ lịch sử?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              prov.clearAll();
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}