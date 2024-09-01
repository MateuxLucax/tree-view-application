import '../model/company.dart';
import '../repository/company_repository.dart';
import '../state/company_state.dart';
import '../store/base_store.dart';

class CompanyController extends BaseStore {
  final ICompanyRepository repository = TractianApiCompanyRepository();
  CompanyState state = CompanyLoading();

  Future<void> fetchCompanies() async {
    try {
      final Iterable<Company> companies = await repository.fetchCompanies();
      state = CompanyLoaded(companies);
    } catch (e) {
      state = CompanyError(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
