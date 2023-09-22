import 'config.dart' as config;
import 'package:http/http.dart' as http;

Future<String> getTamamlandiCount(int id,DateTime bastar,DateTime bittar) async {
  try {
    final response = await http.get(
      Uri.parse(config.getApiUrl() + '/Log/TamamlandiCount?userID=$id&baslangic=$bastar&bitis=$bittar'),
    );

    if (response.statusCode == 200) {
      return response.body.toString();

    } else {
      throw Exception('HTTP İsteği Başarısız: ${response.statusCode}');
    }
  } catch (e) {
    print('Hata Oluştu: $e');
    return '';
  }
}

Future<String> getToplamAtanmisCount(int id,DateTime bastar,DateTime bittar) async {
  try {
    final response = await http.get(
      Uri.parse(config.getApiUrl() + '/Log/ToplamAtanmisCount?userID=$id&baslangic=$bastar&bitis=$bittar'),
    );

    if (response.statusCode == 200) {
      return response.body.toString();

    } else {
      throw Exception('HTTP İsteği Başarısız: ${response.statusCode}');
    }
  } catch (e) {
    print('Hata Oluştu: $e');
    return '';
  }
}

Future<String> getCevapSayisi(int id,DateTime bastar,DateTime bittar) async {
  try {
    final response = await http.get(
      Uri.parse(config.getApiUrl() + '/Log/CevapSayisi?userID=$id&baslangic=$bastar&bitis=$bittar'),
    );

    if (response.statusCode == 200) {
      return response.body.toString();

    } else {
      throw Exception('HTTP İsteği Başarısız: ${response.statusCode}');
    }
  } catch (e) {
    print('Hata Oluştu: $e');
    return '';
  }
}

Future<String> getYardimSayisi(int id,DateTime bastar,DateTime bittar) async {
  try {
    final response = await http.get(
      Uri.parse(config.getApiUrl() + '/Log/YardimSayisi?userID=$id&baslangic=$bastar&bitis=$bittar'),
    );

    if (response.statusCode == 200) {
      return response.body.toString();

    } else {
      throw Exception('HTTP İsteği Başarısız: ${response.statusCode}');
    }
  } catch (e) {
    print('Hata Oluştu: $e');
    return '';
  }
}

Future<String> getYardimIstemeSayisi(int id,DateTime bastar,DateTime bittar) async {
  try {
    final response = await http.get(
      Uri.parse(config.getApiUrl() + '/Log/YardimIstemeSayisi?userID=$id&baslangic=$bastar&bitis=$bittar'),
    );

    if (response.statusCode == 200) {
      return response.body.toString();

    } else {
      throw Exception('HTTP İsteği Başarısız: ${response.statusCode}');
    }
  } catch (e) {
    print('Hata Oluştu: $e');
    return '';
  }
}

Future<String> getMudaheleSuresiOrt(int id,DateTime bastar,DateTime bittar) async {
  try {
    final response = await http.get(
      Uri.parse(config.getApiUrl() + '/Log/MudaheleSuresiOrt?userID=$id&baslangic=$bastar&bitis=$bittar'),
    );

    if (response.statusCode == 200) {
      return response.body.toString();

    } else {
      throw Exception('HTTP İsteği Başarısız: ${response.statusCode}');
    }
  } catch (e) {
    print('Hata Oluştu: $e');
    return '';
  }
}