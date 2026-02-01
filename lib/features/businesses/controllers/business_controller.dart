import 'package:flutter/material.dart';
import 'package:ngoni_pay/features/businesses/models/business_model.dart';
import '../services/business_service.dart';

class BusinessController extends ChangeNotifier {
  List<BusinessModel> businesses = [];
  bool isLoading = false;
  String? error;

  Future<bool> createBusiness(BusinessModel business) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await BusinessService.createBusiness(business);

      return true;
    } catch (e) {
      error = 'Erreur lors de la création du business';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBusinesses() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      businesses = await BusinessService.getMyBusinesses();
    } catch (e) {
      error = "Erreur lors du chargement des business";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
