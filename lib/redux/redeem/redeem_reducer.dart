import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/redeem/redeem_actions.dart';
import 'package:redux/redux.dart';

final redReducers = combineReducers<AppState>([
  TypedReducer<AppState, RedeemTagAction>(_redeemBadge),
]);

AppState _redeemBadge(AppState state, RedeemTagAction action) {
  return AppState(
    navSelectedIndex: 4,
    user: state.user,
    selectedCollection: state.selectedCollection,
    selectedBadge: state.selectedBadge,
    selectedCollections: state.selectedCollections,
    timeLimited: state.timeLimited,
  );
}
