// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/utils/enum.dart';

import '../../../domain/news_base_use_case/use_case_aritcles.dart';
import 'articles_event.dart';
import 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  ArticlesBloc(this.useCaseArticles) : super(const ArticlesState()) {
    on<FetchArticleDataEvent>(_fetchDataEvent, transformer: droppable());
  }

  final UseCaseArticles useCaseArticles;

  Future<FutureOr<void>> _fetchDataEvent(
      FetchArticleDataEvent event, Emitter<ArticlesState> emit) async {
    if (state.request == Request.loading) {
      final remoteData = await useCaseArticles.getArticlesData();
      final localArticlesData = await useCaseArticles.getLocalArticlesData();
      // Online State
      if (remoteData.isNotEmpty) {
        emit(
            state.copyWith(articlesModel: remoteData, request: Request.loaded));
      }

      // OFFline State
      if (remoteData.isEmpty) {
        emit(state.copyWith(
            localData: localArticlesData,
            noMorePosts: false,
            request: Request.offline));
      }

      // If network fail after login ...
      if (localArticlesData.isEmpty) {
        emit(state.copyWith(request: Request.error));
      }
    } else {
      final remoteData = await useCaseArticles.getArticlesData(
          from: state.articlesModel.length);
      if (remoteData.length < 5) {
        emit(state.copyWith(
            noMorePosts: true,
            articlesModel: List.of(state.articlesModel)..addAll(remoteData),
            request: Request.loaded));
      } else {
        emit(state.copyWith(
            noMorePosts: false,
            articlesModel: List.of(state.articlesModel)..addAll(remoteData),
            request: Request.loaded));
      }
    }
  }
}
