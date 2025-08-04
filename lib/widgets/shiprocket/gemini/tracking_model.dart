import 'package:intl/intl.dart';

class TrackingData {
  final int trackStatus;
  final int shipmentStatus;
  final List<ShipmentTrack> shipmentTrack;
  final List<dynamic>? shipmentTrackActivities;
  final String trackUrl;
  final String? qcResponse;
  final bool isReturn;
  final String? error;

  TrackingData({
    required this.trackStatus,
    required this.shipmentStatus,
    required this.shipmentTrack,
    this.shipmentTrackActivities,
    required this.trackUrl,
    this.qcResponse,
    required this.isReturn,
    this.error,
  });

  factory TrackingData.fromJson(Map<String, dynamic> json) {
    return TrackingData(
      trackStatus: json['track_status'] as int,
      shipmentStatus: json['shipment_status'] as int,
      shipmentTrack: (json['shipment_track'] as List<dynamic>)
          .map((e) => ShipmentTrack.fromJson(e as Map<String, dynamic>))
          .toList(),
      shipmentTrackActivities:
          json['shipment_track_activities'] as List<dynamic>?,
      trackUrl: json['track_url'] as String,
      qcResponse: json['qc_response'] as String?,
      isReturn: json['is_return'] as bool,
      error: json['error'] as String?,
    );
  }
}

class ShipmentTrack {
  final int id;
  final String awbCode;
  final int? courierCompanyId;
  final int shipmentId;
  final int orderId;
  final String pickupDate;
  final String deliveredDate;
  final String weight;
  final int packages;
  final String currentStatus;
  final String destination;
  final String origin;
  final String courierName;
  final String? edd;
  final String podStatus;
  final String? rtoDeliveredDate;
  final String? returnAwbCode;
  final String updatedTimeStamp;

  ShipmentTrack({
    required this.id,
    required this.awbCode,
    this.courierCompanyId,
    required this.shipmentId,
    required this.orderId,
    required this.pickupDate,
    required this.deliveredDate,
    required this.weight,
    required this.packages,
    required this.currentStatus,
    required this.destination,
    required this.origin,
    required this.courierName,
    this.edd,
    required this.podStatus,
    this.rtoDeliveredDate,
    this.returnAwbCode,
    required this.updatedTimeStamp,
  });

  factory ShipmentTrack.fromJson(Map<String, dynamic> json) {
    return ShipmentTrack(
      id: json['id'] as int,
      awbCode: json['awb_code'] as String,
      courierCompanyId: json['courier_company_id'] as int?,
      shipmentId: json['shipment_id'] as int,
      orderId: json['order_id'] as int,
      pickupDate: json['pickup_date'] as String,
      deliveredDate: json['delivered_date'] as String,
      weight: json['weight'] as String,
      packages: json['packages'] as int,
      currentStatus: json['current_status'] as String,
      destination: json['destination'] as String,
      origin: json['origin'] as String,
      courierName: json['courier_name'] as String,
      edd: json['edd'] as String?,
      podStatus: json['pod_status'] as String,
      rtoDeliveredDate: json['rto_delivered_date'] as String?,
      returnAwbCode: json['return_awb_code'] as String?,
      updatedTimeStamp: json['updated_time_stamp'] as String,
    );
  }

  String get formattedUpdatedTime {
    if (updatedTimeStamp.isEmpty) {
      return 'N/A';
    }
    try {
      final dateTime = DateTime.parse(updatedTimeStamp);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return updatedTimeStamp;
    }
  }
}
