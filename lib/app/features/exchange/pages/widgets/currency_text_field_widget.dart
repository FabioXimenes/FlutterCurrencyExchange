import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubit/currencies/currencies_cubit.dart';

class CurrencyTextFieldWidget extends StatefulWidget {
  final Currency? initialCurrency;
  final double? initialAmount;
  final Function(Currency currency) onCurrencySelected;
  final Function(double amount) onValueChanged;
  final String hintText;
  final bool enabled;

  const CurrencyTextFieldWidget({
    required this.onCurrencySelected,
    required this.onValueChanged,
    required this.hintText,
    this.initialCurrency,
    this.initialAmount,
    this.enabled = true,
    super.key,
  });

  @override
  State<CurrencyTextFieldWidget> createState() =>
      _CurrencyTextFieldWidgetState();
}

class _CurrencyTextFieldWidgetState extends State<CurrencyTextFieldWidget> {
  TextEditingController textController = TextEditingController();
  CurrencyTextInputFormatter? formatter;
  Currency? selectedCurrency;

  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.initialCurrency;
    formatter = CurrencyTextInputFormatter(
      symbol: '',
      decimalDigits: 2,
    );
    if (widget.initialAmount != null) {
      textController.text =
          formatter!.format(widget.initialAmount!.toStringAsFixed(2));
    }
  }

  @override
  void didUpdateWidget(covariant CurrencyTextFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialAmount != widget.initialAmount) {
      textController.text =
          formatter!.format(widget.initialAmount!.toStringAsFixed(2));
    }

    if (oldWidget.initialCurrency != widget.initialCurrency) {
      selectedCurrency = widget.initialCurrency;
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                enabled: widget.enabled,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefix: selectedCurrency != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(selectedCurrency!.symbol),
                        )
                      : null,
                  suffixIcon: SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 32,
                          width: 2,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        BlocBuilder<CurrenciesCubit, CurrenciesState>(
                          builder: (context, state) {
                            if (state is! CurrenciesLoaded) {
                              return const SizedBox();
                            }

                            return DropdownButtonHideUnderline(
                              child: DropdownButton<Currency>(
                                alignment: Alignment.centerRight,
                                style: Theme.of(context).textTheme.bodyMedium,
                                items: List.generate(
                                  state.currencies.length,
                                  (index) => DropdownMenuItem(
                                    value: state.currencies[index],
                                    child: Text(
                                        '${state.currencies[index].code} - ${state.currencies[index].name}'),
                                  ),
                                ),
                                hint: Text(widget.hintText),
                                onChanged: widget.enabled
                                    ? (currency) {
                                        if (currency == null) return;
                                        setState(() {
                                          selectedCurrency = currency;
                                        });

                                        formatter = CurrencyTextInputFormatter(
                                          symbol: '',
                                          decimalDigits: 2,
                                        );
                                        textController.text = formatter!
                                            .format(textController.text);
                                        widget.onCurrencySelected(currency);
                                      }
                                    : null,
                                value: selectedCurrency,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                controller: textController,
                inputFormatters: [
                  formatter ?? FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final amount = double.tryParse(value);
                  if (amount != null) {
                    widget.onValueChanged(amount);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
