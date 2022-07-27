import 'package:dartz/dartz.dart';
import 'package:repo_viewer/core/domain/fresh.dart';
import 'package:repo_viewer/core/infrastructure/network_exceptions.dart';
import 'package:repo_viewer/github/core/domain/github_failure.dart';
import 'package:repo_viewer/github/core/domain/github_repo.dart';
import 'package:repo_viewer/github/repos/searched_repos/infrastructure/searched_repos_remote_service.dart';
import 'package:repo_viewer/github/repos/core/infrastructure/extensions.dart';

class SearchedReposRepository {
  final SearchedReposRemoteService remoteService;

  SearchedReposRepository(this.remoteService);

  Future<Either<GithubFailure, Fresh<List<GithubRepo>>>> getSearchedReposPage(
    String query,
    int page,
  ) async {
    try {
      final remotePageItems =
          await remoteService.getSearchedReposPage(query, page);
      return right(
        remotePageItems.maybeWhen(
          withNewData: (data, maxPage) => Fresh.yes(
            data.toDomain(),
            isNextPageAvailable: page < maxPage,
          ),
          orElse: () => Fresh.no([], isNextPageAvailable: false),
        ),
      );
    } on RestApiExceptions catch (e) {
      return left(GithubFailure.api(e.errorCode));
    }
  }
}
