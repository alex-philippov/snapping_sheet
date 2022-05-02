import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:snapping_sheet/src/sheet_position_data.dart';

class SnappingSheetConfig {
  final List<SnappingPosition> snappingPositions;
  final SnappingPosition? initialSnappingPosition;
  final Function(SheetPositionData positionData)? onSheetMoved;
  final Function(
    SheetPositionData positionData,
    SnappingPosition snappingPosition,
  )? onSnapCompleted;

  final Function(
    SheetPositionData positionData,
    SnappingPosition snappingPosition,
  )? onSnapStart;

  SnappingSheetConfig({
    this.onSheetMoved,
    this.onSnapCompleted,
    this.onSnapStart,
    this.initialSnappingPosition,
    this.snappingPositions = const [
      SnappingPosition.factor(
        positionFactor: 0.0,
        grabbingContentOffset: GrabbingContentOffset.top,
      ),
      SnappingPosition.factor(positionFactor: 0.5),
      SnappingPosition.factor(
        positionFactor: 1.0,
        grabbingContentOffset: GrabbingContentOffset.bottom,
      ),
    ],
  });

  SnappingPosition initSnappingPosition() =>
      initialSnappingPosition ?? snappingPositions.first;
}
