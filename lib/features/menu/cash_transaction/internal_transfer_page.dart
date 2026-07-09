import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/data/models/app_user.dart';
import 'package:stock_app/features/home/widgets/app_input_field.dart';
import 'package:stock_app/providers/user_provider.dart';

/// Account menu screen pushed from the Home AppBar.
///
/// All labels are localized; the AppBar carries the language switcher so the
/// user can change language here too (content re-translates in place).
class InternalTransferPage extends StatelessWidget {
  const InternalTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Build fresh (non-const) so labels re-translate on locale change.
    final user = context.read<UserProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('menu.internalTransfer'.tr()),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: _buildContent(user!),
    );
  }

  Widget _buildContent(AppUser user) {
    final contentForm =
        'Chuyển tiền nội bộ TK ${user.username} từ tiểu khoản 08 sang 01';

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          AppInputField(
            label: 'Loại giao dịch',
            readOnly: true,
            hintText: 'menu.internalTransfer'.tr(),
            // keyboardType: TextInputType.number,
            // suffixIcon: const Icon(Icons.attach_money),
          ),
          AppInputField(
            label: 'Tài khoản',
            readOnly: true,
            hintText: user.username,
          ),
          AppInputField(
            label: 'Tiểu khoản chuyển',
            readOnly: true,
            hintText: '08',
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
          ),
          AppInputField(
            label: 'Số tiền chuyển tối đa',
            hintText: 0.toString(),
            suffixIcon: const Icon(Icons.change_circle_outlined),
            keyboardType: TextInputType.number,
          ),
          AppInputField(
            label: 'Tiểu khoản nhận',
            readOnly: true,
            hintText: '01',
            suffixIcon: const Icon(Icons.close),
          ),
          AppInputField(
            label: 'Số tiền chuyển',
            hintText: user.username,
            keyboardType: TextInputType.number,
            suffixIcon: const Icon(Icons.close),
          ),
          AppInputField(
            label: 'Nội dung',
            hintText: contentForm,
            suffixIcon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
