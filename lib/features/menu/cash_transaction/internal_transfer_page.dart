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
    const sourceSubAccount = '08';
    const destSubAccount = '01';

    final contentForm = 'internalTransfer.contentTemplate'.tr(
      namedArgs: {
        'username': user.username,
        'from': sourceSubAccount,
        'to': destSubAccount,
      },
    );

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          AppInputField(
            label: 'internalTransfer.transactionType'.tr(),
            readOnly: true,
            hintText: 'menu.internalTransfer'.tr(),
            // keyboardType: TextInputType.number,
            // suffixIcon: const Icon(Icons.attach_money),
          ),
          AppInputField(
            label: 'internalTransfer.account'.tr(),
            readOnly: true,
            hintText: user.username,
          ),
          AppInputField(
            label: 'internalTransfer.sourceSubAccount'.tr(),
            readOnly: true,
            hintText: sourceSubAccount,
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
          ),
          AppInputField(
            label: 'internalTransfer.maxTransferAmount'.tr(),
            hintText: 0.toString(),
            suffixIcon: const Icon(Icons.change_circle_outlined),
            keyboardType: TextInputType.number,
          ),
          AppInputField(
            label: 'internalTransfer.destSubAccount'.tr(),
            readOnly: true,
            hintText: destSubAccount,
            suffixIcon: const Icon(Icons.close),
          ),
          AppInputField(
            label: 'internalTransfer.transferAmount'.tr(),
            hintText: user.username,
            keyboardType: TextInputType.number,
            suffixIcon: const Icon(Icons.close),
          ),
          AppInputField(
            label: 'internalTransfer.note'.tr(),
            hintText: contentForm,
            suffixIcon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
