import 'package:ngoni_pay/features/dashboard/stats/daily/daily_stat.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RevenueLineChart extends StatelessWidget {
  final List<DailyStat> data;

  const RevenueLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Aucune donnée'));
    }

    final maxAmount = data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: maxAmount == 0 ? 1 : maxAmount * 1.2,

            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),

            // 🎯 TOOLTIP INTERACTIF
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.black87,
                tooltipRoundedRadius: 8,
                getTooltipItems: (spots) {
                  return spots.map((spot) {
                    final index = spot.x.toInt();
                    final item = data[index];
                    return LineTooltipItem(
                      '${item.day}\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: '${item.amount.toStringAsFixed(0)} FCFA',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),

            // 🏷️ AXES
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: data.length <= 7
                      ? 1
                      : data.length <= 14
                      ? 2
                      : 5, // 🔥 clé du fix

                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();

                    if (index < 0 || index >= data.length) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        data[index].day,
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 📈 COURBE
            lineBarsData: [
              LineChartBarData(
                spots: data.asMap().entries.map((e) {
                  return FlSpot(e.key.toDouble(), e.value.amount);
                }).toList(),
                isCurved: true,
                barWidth: 3,
                color: Colors.green,

                // 🔵 POINTS
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.green,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),

                // 🌿 ZONE SOUS COURBE
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.green.withOpacity(0.15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
