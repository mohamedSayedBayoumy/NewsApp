import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/functions/snack_bar.dart';
import '../../../../core/utils/enum.dart';
import '../../../domain/weather_base_use_case/weather_base_usecase.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(this.baseWeatherUseCase) : super(WeatherState()) {
    on<FetchWeatherDataEvent>(_fetchWeatherDataEvent);
    on<FetchWeatherDataByCountryNameEvent>(_fetchWeatherDataByCountryNameEvent);
  }

  final BaseWeatherUseCase baseWeatherUseCase;

  Future<FutureOr<void>> _fetchWeatherDataEvent(
      FetchWeatherDataEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(statusRequest: Request.loading));
    final result = await baseWeatherUseCase.fetchWeatherByLanAndLat();

    result.fold((l) {
      emit(state.copyWith(
        statusRequest: Request.offline,
      ));
    }, (r) {
      emit(state.copyWith(
        statusRequest: Request.loaded,
        weatherModel: r,
      ));
    });
  }

  Future<FutureOr<void>> _fetchWeatherDataByCountryNameEvent(
      FetchWeatherDataByCountryNameEvent event,
      Emitter<WeatherState> emit) async {
    emit(state.copyWith(statusRequest: Request.loading));

    try {
      print("object");
      final result = await baseWeatherUseCase.fetchWeatherByCountryName(
          country: event.country);

      result.fold((l) {
        emit(state.copyWith(
          message: l.errorMessage,
          statusRequest: Request.offline,
        ));
      }, (r) {
        print(" r object");
        emit(state.copyWith(
          statusRequest: Request.loaded,
          weatherModel: r,
        ));
      });
    } catch (e) {
      if (e.toString() ==
          "NoSuchMethodError: The method 'map' was called on null.") {
        ScaffoldMessenger.of(event.context).showSnackBar(snackBar(
            "يرجى التحقق من الاسم الذي أدخلته ",
            context: event.context));
      }
    }
  }
}
