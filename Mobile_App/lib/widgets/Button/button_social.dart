import 'package:flutter/material.dart';

class SocialButtonRow extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;

  const SocialButtonRow({
    Key? key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
                child: Text(
                  "Continue With Accounts",
                  style: TextStyle(color: Color.fromARGB(255, 150, 147, 147)),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: TextButton(
                        onPressed: onGooglePressed,
                        child: Text(
                          'GOOGLE',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 240, 186, 182),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Đặt bán kính góc
                          ),
                          minimumSize: Size.fromHeight(
                              50), // Đảm bảo chiều cao không thay đổi
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Khoảng cách giữa các nút
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: TextButton(
                        onPressed: onFacebookPressed,
                        child: Text(
                          'FACEBOOK',
                          style: TextStyle(color: Color(0xFF0082EC)),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 159, 201, 235),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Đặt bán kính góc
                          ),
                          minimumSize: Size.fromHeight(
                              50), // Đảm bảo chiều cao không thay đổi
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
