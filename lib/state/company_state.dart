import '../model/company.dart';

sealed class CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanyLoaded extends CompanyState {
  CompanyLoaded(this.companies);

  final Iterable<Company> companies;
}

class CompanyError extends CompanyState {
  CompanyError(this.message);

  final String message;
}
