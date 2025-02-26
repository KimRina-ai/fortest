import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'seeMyGul.dart';

import 'alarmTap.dart'; // alarmTap.dart 파일
import 'categoryTap.dart'; // categoryTap.dart 파일
import 'login.dart'; // login.dart 파일
import 'searchTap.dart'; // searchTap.dart 파일


void main() {
  runApp(const MaterialApp(
    home: PersonalInfoScreen(),
  ));
}


void goToAnotherPage(BuildContext context, String pageName) {
  // 버튼에 따라 그에 해당하는 파일로 이동
  switch (pageName) {
    case "LoginScreen":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      break;

    case "SeeMyGulScreen":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SeeMyGulScreen(gulItems: [], imagePath: '', item: '', selectedCategory: '', features: '',  )),
      );
      break;

    case "CategoryTap":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CategoryTapScreen()),
      );
      break;

    case "SearchTap":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchTapScreen()),
      );
      break;


    case "AlarmTap":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AlarmTapScreen()),
      );
      break;


  }
}


class UserData {
  String name;

  String password;
  String email;
  String nickname;
  String? profileImgUrl;

  UserData(
      {required this.name,
        required this.password,
        required this.email,
        required this.nickname,
        required this.profileImgUrl,
      });
}




class PersonalInfoScreen extends StatefulWidget{
  const PersonalInfoScreen({Key? key}) : super(key:key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {

  UserData userData =
  UserData(name: '',
      email: '',
      nickname: '',
      profileImgUrl: '',
      password: '');
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser);
    if (currentUser != null) {
      try {
        // Set a timeout for the data loading process
        const timeout = Duration(seconds: 10);
        DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get()
            .timeout(timeout);

        print("Loaded user data: ${userDataSnapshot.data()}");
        setState(() {
          userData = UserData(
            name: userDataSnapshot['username'],
            email: currentUser.email ?? '',
            nickname: userDataSnapshot['nickname'],
            profileImgUrl: userDataSnapshot['profileImgUrl'],
            password: '',
          );
          isLoading = false;
        });
      } catch (e) {
        // Handle timeout or other errors
        print("Error loading user data: $e");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to handle logout
  Future<void> handleLogout() async {
    await FirebaseAuth.instance.signOut();
    // Redirect to the login screen after logout
    goToAnotherPage(context, "LoginScreen");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보',
            style: TextStyle(fontSize: 25, fontFamily: 'HakgyoansimDoldam',
              fontWeight: FontWeight.w700,)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          )
        ],
      ),

      body: Column(
        children: [
          InkWell(
            onTap: () {
              goToAnotherPage(context, "LoginScreen");
            },
            child: Container(
              width: double.infinity,
              height: 300,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 84, 224, 255),
                    Color.fromARGB(230, 106, 255, 204),
                  ],
                ),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Show loading indicator while data is being fetched
                  isLoading
                      ? CircularProgressIndicator()
                      : Column(
                    children: [
                      // 사용자가 로그인한 경우 프로필 이미지를 표시
                      if (userData.profileImgUrl != null && userData.profileImgUrl!.isNotEmpty)
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(userData.profileImgUrl!),
                        ),
                      const SizedBox(height: 20),
                      // 닉네임이 있는 경우 환영 메시지 표시, 없으면 로그인 안내 텍스트 표시
                      Text(
                        userData.nickname != null && userData.nickname.isNotEmpty
                            ? '${userData.nickname} 님 환영합니다 :)'
                            : '로그인 해주세요 :)',
                        style: const TextStyle(
                          fontSize: 35,
                          fontFamily: 'HakgyoansimDoldam',
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
          ),

          ),
          const SizedBox(height: 30),

          if (FirebaseAuth.instance.currentUser != null) // Only show these buttons when logged in
          InkWell(
            onTap: () {
              goToAnotherPage(context, "SeeMyGulScreen");
            },
            child: const Row(
              children: [
                SizedBox(width:10),
                Icon(Icons.note, size: 40),
                SizedBox(width: 20),
                Text("내 게시글 보기", style: TextStyle(fontSize: 32,
                  fontFamily: 'HakgyoansimDoldam',
                  fontWeight: FontWeight.w700,)
                ),
              ],
            ),
          ),


          const SizedBox(height: 20),

          if (FirebaseAuth.instance.currentUser != null) // Only show these buttons when logged in
          InkWell(
            onTap: () {
              // '프로필 수정' 버튼을 누를 때 실행할 작업
              // 예: goToAnotherPage(context, "EditProfile");
            },
            child: const Row(
              children: [
                SizedBox(width:10),
                Icon(Icons.person, size: 40),
                SizedBox(width: 20),
                Text("프로필 수정", style: TextStyle(fontSize: 32,
                  fontFamily: 'HakgyoansimDoldam',
                  fontWeight: FontWeight.w700,)),
              ],
            ),
          ),


          const SizedBox(height: 20),

          if (FirebaseAuth.instance.currentUser != null) // Only show these buttons when logged in
          InkWell(
            onTap: () {
              // '비밀번호 변경' 버튼을 누를 때 실행할 작업
              // 예: goToAnotherPage(context, "ChangePassword");
            },
            child: const Row(
              children: [
                SizedBox(width:10),
                Icon(Icons.lock, size: 40),
                SizedBox(width: 20),
                Text("비밀번호 변경", style: TextStyle(fontSize: 32,
                  fontFamily: 'HakgyoansimDoldam',
                  fontWeight: FontWeight.w700,)),
              ],
            ),
          ),


          const SizedBox(height: 20),

          if (FirebaseAuth.instance.currentUser != null) // Only show these buttons when logged in
          InkWell(
            onTap: () {
              // '회원 탈퇴' 버튼을 누를 때 실행할 작업
              // 예: goToAnotherPage(context, "Withdrawal");
            },
            child: const Row(
              children: [
                SizedBox(width:10),
                Icon(Icons.account_circle, size: 40),
                SizedBox(width: 20),
                Text("회원 탈퇴", style: TextStyle(fontSize: 32,
                  fontFamily: 'HakgyoansimDoldam',
                  fontWeight: FontWeight.w700,)),
              ],
            ),
          ),


          const SizedBox(height: 20),

          if (FirebaseAuth.instance.currentUser != null) // Only show these buttons when logged in
          InkWell(
            onTap: handleLogout,
            child: const Row(
              children: [
                SizedBox(width:10),
                Icon(Icons.logout, size: 40),
                SizedBox(width: 20),
                Text("로그아웃", style: TextStyle(fontSize: 32,
                  fontFamily: 'HakgyoansimDoldam',
                  fontWeight: FontWeight.w700,)),
              ],
            ),
          ),

        ],
      ),


      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "카테고리",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "검색",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "알림",
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0: // 카테고리 탭
              goToAnotherPage(context, "CategoryTap");
              break;
            case 1: // 검색 탭
              goToAnotherPage(context, "SearchTap");
              break;
            case 2: // 알림 탭
              goToAnotherPage(context, "AlarmTap");
              break;
          }
        },
      ),
    );
  }
}
