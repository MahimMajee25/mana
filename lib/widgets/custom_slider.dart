import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CustomeVerticalSlider.dart';

class VerticalRangeSelector extends StatefulWidget {
  const VerticalRangeSelector({super.key});

  @override
  _VerticalRangeSelectorState createState() => _VerticalRangeSelectorState();
}

class _VerticalRangeSelectorState extends State<VerticalRangeSelector> {
  double _value = 6;
  double? _lastValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'HOW MANY TIMES PER DAY DO YOU PREFER TO EAT?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                height: 365,
                child: CustomVerticalSlider(
                  value: _value,
                  onChanged: (val) {
                    setState(() {
                      _value = val;
                      if (_lastValue != val) {
                        HapticFeedback.lightImpact();
                        _lastValue = val;
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'TIMES A DAY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}