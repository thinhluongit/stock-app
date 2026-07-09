// NumberFormat/DateFormat come from easy_localization's intl re-export.
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/core/theme/app_colors.dart';
import 'package:stock_app/data/mock/mock_data.dart';
import 'package:stock_app/data/models/models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Intraday line for one market index, with a chip row to switch indices.
class IndexChart extends StatefulWidget {
  const IndexChart({super.key});

  @override
  State<IndexChart> createState() => _IndexChartState();
}

class _IndexChartState extends State<IndexChart> {
  static final _valueFormat = NumberFormat('#,##0.00');
  static final _changeFormat = NumberFormat('+#,##0.00;-#,##0.00');
  static final _percentFormat = NumberFormat('+#,##0.00;-#,##0.00');
  static final _timeFormat = DateFormat.Hm();

  late TrackballBehavior _trackball;
  String _selected = MockData.indices.first.name;

  @override
  void initState() {
    super.initState();
    _trackball = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      lineType: TrackballLineType.vertical,
      lineColor: AppColors.textSecondary,
      lineWidth: 1,
      lineDashArray: const [4, 3],
      tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
      builder: _buildTooltip,
    );
  }

  MarketIndex get _index => MockData.indexByName(_selected);

  /// Green up, red down, amber unchanged — the app's board semantics.
  Color get _trendColor {
    if (_index.isUp) return AppColors.up;
    if (_index.isDown) return AppColors.down;
    return AppColors.reference;
  }

  IconData get _trendIcon {
    if (_index.isUp) return Icons.arrow_drop_up;
    if (_index.isDown) return Icons.arrow_drop_down;
    return Icons.remove;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'market.marketIndices'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildIndexChips(),
          const SizedBox(height: 16),
          _buildHeader(),
          const SizedBox(height: 8),
          SizedBox(height: 190, child: _buildChart()),
        ],
      ),
    );
  }

  Widget _buildIndexChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          for (final index in MockData.indices) ...[
            _buildChip(index),
            if (index != MockData.indices.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildChip(MarketIndex index) {
    final selected = index.name == _selected;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => setState(() => _selected = index.name),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
            ),
          ),
          child: Text(
            index.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  /// The headline number. The chart carries the shape; this carries the value,
  /// so no data label is needed on any individual point.
  Widget _buildHeader() {
    final index = _index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _valueFormat.format(index.value),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: _trendColor,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon + sign, so direction is never carried by color alone.
                    Icon(_trendIcon, size: 20, color: _trendColor),
                    Flexible(
                      child: Text(
                        '${_changeFormat.format(index.change)} '
                        '(${_percentFormat.format(index.percent)}%)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _trendColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${'common.volume'.tr()} ${_formatVolume(index.volume)}',
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                // Names the dashed line drawn across the plot.
                Text(
                  '${'market.reference'.tr()} '
                  '${_valueFormat.format(index.reference)}',
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final index = _index;
    final ticks = MockData.intradayOf(index);
    final color = _trendColor;
    final (min, max) = _yRange(ticks, index.reference);

    return SfCartesianChart(
      margin: EdgeInsets.zero,
      plotAreaBorderWidth: 0,
      trackballBehavior: _trackball,
      primaryXAxis: DateTimeCategoryAxis(
        dateFormat: _timeFormat,
        interval: 12, // one label per trading hour
        labelPlacement: LabelPlacement.onTicks,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: const TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
        ),
      ),
      primaryYAxis: NumericAxis(
        opposedPosition: true,
        minimum: min,
        maximum: max,
        numberFormat: _valueFormat,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: const MajorGridLines(
          width: 1,
          color: AppColors.divider,
          dashArray: [4, 4],
        ),
        labelStyle: const TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
        ),
        plotBands: [
          // Yesterday's close: everything above it is a gain. Labelled in the
          // header rather than in-plot, where the text collides with the line.
          PlotBand(
            start: index.reference,
            end: index.reference,
            borderColor: AppColors.textSecondary,
            borderWidth: 1,
            dashArray: const [4, 3],
          ),
        ],
      ),
      series: [
        SplineAreaSeries<IndexTick, DateTime>(
          dataSource: ticks,
          xValueMapper: (tick, _) => tick.time,
          yValueMapper: (tick, _) => tick.value,
          borderColor: color,
          borderWidth: 2,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: 0.28),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
        // Endpoint dot: the one point worth marking directly.
        ScatterSeries<IndexTick, DateTime>(
          dataSource: [ticks.last],
          xValueMapper: (tick, _) => tick.time,
          yValueMapper: (tick, _) => tick.value,
          enableTooltip: false,
          enableTrackball: false,
          markerSettings: MarkerSettings(
            isVisible: true,
            height: 9,
            width: 9,
            color: color,
            borderColor: AppColors.surface,
            borderWidth: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildTooltip(BuildContext context, TrackballDetails details) {
    final point = details.point;
    if (point == null) return const SizedBox.shrink();

    final time = point.x as DateTime;
    final value = (point.y as num).toDouble();
    final delta = value - _index.reference;
    final percent = _index.reference == 0 ? 0.0 : delta / _index.reference * 100;
    final color = delta > 0
        ? AppColors.up
        : delta < 0
            ? AppColors.down
            : AppColors.reference;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _timeFormat.format(time),
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
          const SizedBox(height: 2),
          Text(
            _valueFormat.format(value),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            '${_changeFormat.format(delta)} (${_percentFormat.format(percent)}%)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Pads the series range and always keeps the reference line in frame.
  (double, double) _yRange(List<IndexTick> ticks, double reference) {
    var min = reference;
    var max = reference;
    for (final tick in ticks) {
      if (tick.value < min) min = tick.value;
      if (tick.value > max) max = tick.value;
    }

    final padding = (max - min) * 0.2;
    return (min - padding, max + padding);
  }

  String _formatVolume(double volume) {
    if (volume >= 1e9) return '${(volume / 1e9).toStringAsFixed(2)}B';
    if (volume >= 1e6) return '${(volume / 1e6).toStringAsFixed(1)}M';
    if (volume >= 1e3) return '${(volume / 1e3).toStringAsFixed(1)}K';
    return volume.toStringAsFixed(0);
  }
}
