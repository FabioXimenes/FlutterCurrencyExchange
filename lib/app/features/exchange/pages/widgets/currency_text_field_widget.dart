import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/currencies/currencies_cubit.dart';

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
  late CurrencyTextInputFormatter formatter;
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
          formatter.format(widget.initialAmount!.toStringAsFixed(2));
    }
  }

  @override
  void didUpdateWidget(covariant CurrencyTextFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialAmount != widget.initialAmount) {
      textController.text =
          formatter.format(widget.initialAmount!.toStringAsFixed(2));
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<CurrenciesCubit, CurrenciesState>(
              builder: (context, state) {
                if (state is! CurrenciesLoaded) {
                  return const SizedBox();
                }

                return DropdownButtonHideUnderline(
                  child: DropdownButton<Currency>(
                    alignment: Alignment.centerLeft,
                    isDense: true,
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
                            textController.text =
                                formatter.format(textController.text);
                            widget.onCurrencySelected(currency);
                          }
                        : null,
                    value: selectedCurrency,
                  ),
                );
              },
            ),
            TextFormField(
              enabled: widget.enabled,
              onTap: () {
                if (selectedCurrency == null) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please select the currency first.',
                      ),
                    ),
                  );
                }
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              canRequestFocus: selectedCurrency != null,
              decoration: InputDecoration(
                prefix: selectedCurrency != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(selectedCurrency!.symbol),
                      )
                    : null,
              ),
              controller: textController,
              inputFormatters: [formatter],
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final amount = formatter.getUnformattedValue();
                widget.onValueChanged(amount.toDouble());
              },
            ),
          ],
        ),
      ),
    );
  }
}
