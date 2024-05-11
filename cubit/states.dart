abstract class SokarState{}


class SokarInitialState extends SokarState{}

class RegisterInitialState extends SokarState{}
class RegisterLoadingState extends SokarState{}
class RegisterSuccessState extends SokarState{}
class RegisterErrorState extends SokarState{}

class CreateUserSuccessState extends SokarState{}
class CreateUserErrorState extends SokarState{}

class LoginInitialState extends SokarState{}
class LoginLoadingState extends SokarState{}
class LoginSuccessState extends SokarState{
  final String uid;
  LoginSuccessState(this.uid);
}
class LoginErrorState extends SokarState{}

class SokarCubitClosedState extends SokarState{}


class GetUserLoadingState extends SokarState{}
class GetUserSuccessState extends SokarState{}
class GetUserErrorState extends SokarState{}

class OpenObsecuerState extends SokarState{}
class CloseObsecuerState extends SokarState{}



