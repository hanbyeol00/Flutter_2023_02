import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_member/screen/firebase_join.dart';
import 'package:flutter_member/screen/firebase_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Member",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// google 로그인을 수행하기 위한 초기화 함수
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class _HomePageState extends State<HomePage> {
  GoogleSignInAccount? _currentUser;

  late User? _authUser;

  @override
  void initState() {
    super.initState();
    _authUser = FirebaseAuth.instance.currentUser;
    /**
     * google login 이 되면 google 로 부터 이벤트가 전달될텐데
     * 이벤트를 기다리다가 user 정보가 오면 _currentUser 에
     * google login 정보를 저장하라
     */
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    }); // end SingIn
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Member"),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
    );
  } // end build

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            // 변수 ?? 값 : 변수 값이 null 이면 값을 return
            // user.displayName != null ? user.displayName : ""
            title: Text(user.displayName ?? ""),
            subtitle: Text(user.email),
          ),
          ElevatedButton(
            onPressed: () async {
              await _googleSignIn.signOut();
            },
            child: const Text("로그아웃"),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _authUser == null
              ? const Text(
                  "로그인",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                )
              : const Text(
                  "로그인 되어있음",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
          Container(
            margin: const EdgeInsets.all(10),
            child: _authUser != null
                ? Column(
                    children: [
                      _authUser!.emailVerified
                          ? Text("User Name : ${_authUser!.email}")
                          : const Text("이메일 인증이 되어 있지 않음"),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            _authUser = FirebaseAuth.instance.currentUser;
                            setState(() {});
                          },
                          child: const Text("로그아웃"))
                    ],
                  )
                : Column(
                    children: [
                      // 파사드 패턴, 끌어올리기 패턴
                      LoginPage(loginSubmit: loginSubmit),
                      googleLogin(),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JoinPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "이메일로 회원가입",
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(
            height: 20,
          ),
          /**
           * Flexible
           * 내부에 있는 widget 이 화면을 벗어나려고 할때
           * fit 속성을 FlexFit.tight 로 설정하면
           * 화면 범위내에서 화면의 남은 영역만 차지하도록
           * 내부 화면 범위를 제한한다
           */
          const Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: SizedBox(height: 1000),
          ),
        ],
      );
    }
  }

  void loginSubmit({required email, required password}) async {
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      // firebase_auth 에서 제공하는 API 클래스
      UserCredential resultAuth =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _authUser = resultAuth.user;
      setState(() {});
    } on FirebaseException catch (e) {
      String message = "";
      if (e.code == "user-not-fount") {
        message = "사용자가 존재하지 않습니다";
      } else if (e.code == "wrong=password") {
        message = "비밀번호가 맞지 않습니다";
      } else if (e.code == "invalid-email") {
        message = "이메일을 확인해 주세요";
      } else {
        message = "알 수 없는 오류발생";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.deepOrange,
        ),
      );
    }
  }

  GestureDetector googleLogin() {
    return GestureDetector(
      onTap: () async {
        try {
          await _googleSignIn.signIn();
        } catch (e) {
          print(e);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF4285F4)),
            ),
            width: 35,
            height: 35,
            child: Image.asset("images/btn_google.png"),
          ),
          Container(
            color: const Color(0xFF4285F4),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Google 로그인",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
