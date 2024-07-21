import "package:flutter/material.dart";

class supportPage extends StatefulWidget {
  const supportPage({super.key});

  @override
  State<supportPage> createState() => _supportPageState();
}

class _supportPageState extends State<supportPage> {
  List<bool> expandedList = [false, false, false, false, false, false, false];
  List<double> _containerHeights = [50.0, 50.0, 50.0, 50.0, 50.0, 50.0, 50.0];

  void _toggleContainer(int index) {
    setState(() {
      expandedList[index] = !expandedList[index];
      _containerHeights[index] = expandedList[index] ? 180.0 : 50.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 249, 248),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: heightScreen * 0.15,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 85, 131, 249),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Support',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    'assets/support.png',
                    width: widthScreen * 0.35,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  supportOption(
                      widthScreen,
                      context,
                      'How do I place an order?',
                      'Can I change my order after placing it?',
                      'What are the available payment methods?',
                      0),
                  SizedBox(
                    height: 10,
                  ),
                  supportOption(
                      widthScreen,
                      context,
                      'How do I track my order?',
                      'Is tracking available for international orders?',
                      'How do I view the status of each order?',
                      1),
                  SizedBox(
                    height: 10,
                  ),
                  supportOption(
                      widthScreen,
                      context,
                      'What are the shipping options?',
                      'How long does each shipping option take?',
                      'Are there any shipping fees?',
                      2),
                  SizedBox(
                    height: 10,
                  ),
                  supportOption(
                      widthScreen,
                      context,
                      'How do I return an item?',
                      'What is the return policy?',
                      'How do I initiate a return?',
                      3),
                  SizedBox(
                    height: 10,
                  ),
                  supportOption(
                      widthScreen,
                      context,
                      'How do I contact customer support?',
                      'What are the available channels?',
                      'What are the support hours?',
                      4),
                  SizedBox(
                    height: 10,
                  ),
                  supportOption(
                      widthScreen,
                      context,
                      'How do I view my billing history?',
                      'Can I download my invoices?',
                      'How do I resolve billing issues?',
                      5),
                  SizedBox(
                    height: 10,
                  ),
                  supportOption(
                      widthScreen,
                      context,
                      'How do I get a refund?',
                      'What is the refund policy?',
                      'How long does it take process a refund?',
                      6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack supportOption(double widthScreen, BuildContext context, String mainText,
      String firstIssue, String secondIssue, int index) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: widthScreen * 0.85,
          height: _containerHeights[index],
          decoration: BoxDecoration(
              color: Color.fromARGB(203, 48, 130, 197),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: 50,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        mainText,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_downward_outlined,
                          color: Colors.white),
                      onPressed: () {
                        _toggleContainer(index);
                      },
                    ),
                  ],
                ),
              ),
              if (expandedList[index])
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        iconButton(firstIssue, context),
                        iconButton(secondIssue, context),
                      ]),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Row iconButton(String issue, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            issue,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        IconButton(
          onPressed: () async {
            await showDialog(
                barrierColor: Colors.black12.withOpacity(0.7),
                context: context,
                builder: (_) {
                  return Dialog(
                    elevation: 0,
                    backgroundColor: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(
                        12.0,
                      ),
                      child: Container(
                        child: Text(
                          'Lorem, ipsum dolor sit amet consectetur adipisicing elit. Tempore numquam repudiandae explicabo aut architecto laboriosam odio laudantium cumque ducimus cum nulla labore hic quam, beatae soluta debitis pariatur dicta consequatur.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                });
          },
          icon: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
          ),
          color: Colors.white,
        )
      ],
    );
  }
}
