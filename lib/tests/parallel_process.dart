void main() async {
  try {
    final results = await Future.wait([
      fetchData1(),
      fetchData2(),
      fetchData3(),
    ]);
    // Sonuçlara erişim:
    final result1 = results[0];
    final result2 = results[1];
    final result3 = results[2];

    print('Result 1: $result1');
    print('Result 2: $result2');
    print('Result 3: $result3');
  } catch (e) {
    print(e.toString());
  }
}

Future<String> fetchData1() async {
  await Future.delayed(Duration(seconds: 3));
  return "3 Seconds";
}

Future<String> fetchData2() async {
  await Future.delayed(Duration(seconds: 2));
  return "2 Seconds";
}

Future<String> fetchData3() async {
  await Future.delayed(Duration(seconds: 4));
  return "4 Seconds";
}
