import 'package:dio/dio.dart';

import '../../../common/constants/api_constant.dart';
import '../../../common/constants/variable_constant.dart';
import '../local/cache/app_cache.dart';
import 'dio_client.dart';

class ApiRequest {
  late Dio _dio;

  ApiRequest() {
    _dio = DioClient.instance.dio;
  }

  Future signInRequest(String email, String password) {
    return _dio.post(ApiConstant.SIGN_IN,
        data: {"email": email, "password": password});
  }

  Future signUpRequest(String name, String email, String phone, String password,
      String address) {
    return _dio.post(ApiConstant.SIGN_UP, data: {
      "name": name,
      "phone": phone,
      "address": address,
      "email": email,
      "password": password
    });
  }

  Future getProducts() {
    return _dio.get(ApiConstant.PRODUCTS);
  }

  Future getCart() {
    return _dio.get(ApiConstant.CART,
        options: Options(
            headers: {
              "authorization":
                  "Bearer ${AppCache.getString(VariableConstant.TOKEN)}",
            }));
  }

  Future updateCart(String idProduct, int quantity) {
    return _dio.post(ApiConstant.UPDATE_CART,
        data: {
          "id_product": idProduct,
          "id_cart": AppCache.getString(VariableConstant.CART_ID),
          "quantity": quantity
        },
        options: Options(headers: {
          "authorization":
              "Bearer ${AppCache.getString(VariableConstant.TOKEN)}",
        }));
  }

  Future addToCart(String idProduct) {
    return _dio.post(ApiConstant.ADD_CART,
        data: {"id_product": idProduct},
        options: Options(
            validateStatus: (status) {
              return status! <= 500;
            },
            headers: {
              "authorization":
                  "Bearer ${AppCache.getString(VariableConstant.TOKEN)}",
            }));
  }

  Future confirmCart() {
    return _dio.post(ApiConstant.CONFiRM_CART,
        data: {"id_cart": AppCache.getString(VariableConstant.CART_ID),
          "status" : false},
        options: Options(
            headers: {
              "authorization":
                  "Bearer ${AppCache.getString(VariableConstant.TOKEN)}",
            }));
  }

  Future orderHistory(){
    return _dio.post(ApiConstant.ORDER_HISTORY,
        options: Options(
            validateStatus: (status) {
              return status! <= 500;
            },
            headers: {
              "authorization":
              "Bearer ${AppCache.getString(VariableConstant.TOKEN)}",
            }));
  }
}
