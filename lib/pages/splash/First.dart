import 'package:blood_donation_app/constants.dart';
import 'package:blood_donation_app/pages/auth/login.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BodySplash extends StatefulWidget {
  BodySplash({super.key});

  @override
  State<BodySplash> createState() => _BodySplashState();
}

class _BodySplashState extends State<BodySplash> {
  int currentPage = 0;
  List<Map<String, String>> splashs = [
    {
      'image': 'assets/images/splash-3.png',
      'title': 'Bienvenue sur BloodConnect',
      'subtitle':
          'Donnez votre sang, sauvez des vies. Commencez à faire la différence dès aujourd\'hui !'
    },
    {
      'image': 'assets/images/splash-2.png',
      'title': 'Trouvez des Donneurs à Proximité',
      'subtitle':
          'Connectez-vous rapidement avec des donneurs de sang près de chez vous.'
    },
    {
      'image': 'assets/images/splash-1.png',
      'title': 'Simple et Sécurisé',
      'subtitle': 'Vos dons et demandes sont en sécurité avec nous.'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => {},
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle skip action
            },
            child: Text(
              'Passer',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
                child: Center(
                    child: PageView.builder(
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                          });
                        },
                        itemCount: splashs.length,
                        itemBuilder: (BuildContext context, index) {
                          return Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                height: 25,
                              ),
                              Image.asset(
                                '${splashs[index]["image"]}',
                                height: 270,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                "${splashs[index]["title"]}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "${splashs[index]["subtitle"]}",
                                style: const TextStyle(fontSize: 17),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          );
                        }))),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(splashs.length, (index) {
                        return AnimatedContainer(
                          duration: Durations.long1,
                          width: currentPage == index ? 30 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color:
                                currentPage == index ? mainColor : secondColor,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                        );
                      })
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  materialButton(context, () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const Login();
                      },
                    ));
                  }, "Commencer")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

MaterialButton materialButton(
    BuildContext context, Function()? onPress, String text) {
  return MaterialButton(
    minWidth: double.infinity - 40,
    padding: const EdgeInsets.symmetric(vertical: 14),
    onPressed: onPress,
    color: mainColor,
    textColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
    ),
  );
}
