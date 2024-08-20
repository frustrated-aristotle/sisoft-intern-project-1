import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
// ignore: unused_import
//import 'package:http/http.dart' as http;
//import 'package:xml/xml.dart' as xml;
// ignore: unused_import
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage2(),
    );
  }
}

class Becktestcontent {
  List<String> degerleri = [
    "Hiç",
    "Hafif Düzeyde Beni pek Etkilemedi",
    "Orta Düzeyde Hoş değildi ama Katlanabildim",
    "Ciddi Düzeyde Dayanmakta çok zorlandım"
  ];
  List<String> olcutler = [
    "Bedeninizin herhangi bir yerinde uyuşma veya karıncalanma",
    "Sıcak/ateş basmaları",
    "Bacaklarda halsizlik, titreme",
    "Gevşeyememe",
    "Çok kötü şeyler olacak korkusu",
    "Baş dönmesi veya sersemlik",
    "Kalp çarpıntısı",
    "Dengeyi kaybetme duygusu",
    "Dehşete kapılma",
    "Sinirlilik",
    "Boğuluyormuş gibi olma duygusu",
    "Ellerde titreme",
    "Titreklik",
    "Kontrolü kaybetme korkuşu",
    "Nefes almada güçlük",
    "Ölüm korkuşu",
    "Korkuya kapılma",
    "Midede hazımsızlık ya da rahatsızlık hissi",
    "Baygınlık",
    "Yüzün kızarması",
    "Terleme (sıcaklığa bağlı olmayan)"
  ];
  Map<String, int> tableData = {};

  Becktestcontent() {
    for (int i = 0; i < this.olcutler.length; i++) {
      olcutekle(olcutler[i]);
    }
  }

  void olcutekle(String s) {
    this.tableData[s] = 0;
  }
}

class BeckTestScreen extends StatefulWidget {
  @override
  _BeckTestScreenState createState() => _BeckTestScreenState();
}

class _BeckTestScreenState extends State<BeckTestScreen> {
  Becktestcontent test = Becktestcontent();
  Map<String, int> answers = {};

  @override
  void initState() {
    super.initState();
    for (var item in test.olcutler) {
      answers[item] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BECK ANKSIYETE OLCEGI'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: test.olcutler.map((question) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<int>(
                    value: answers[question],
                    onChanged: (int? newValue) {
                      setState(() {
                        answers[question] = newValue!;
                      });
                    },
                    items: test.degerleri.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String val = entry.value;
                      return DropdownMenuItem<int>(
                        value: idx,
                        child: Text(val),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int sum = answers.values.reduce((a, b) => a + b);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Test Sonucu"),
                content: Text("Toplam Puan: $sum"),
                actions: <Widget>[
                  TextButton(
                    child: Text("Tamam"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<Hasta> bekleyenYaslilar = [];
  static List<Hasta> bekleyenhastalar = [];
  static List<Hasta> bakilanHastalar = [];

  static void muayeneEt(Hasta h) {
    final yas = h.yas;
    if (yas >= 65) {
      bekleyenYaslilar.remove(h);
    }
    for (int i = 0; i < bekleyenhastalar.length; i++) {
      bekleyenhastalar[i].siraNO = i;
    }
    h.hastaMuayenedeMi = true;
    bakilanHastalar.add(h);
  }

  static void muayeneEtSirayaGore() {
    if (bekleyenhastalar.isNotEmpty) {
      Hasta muayenedilen = bekleyenhastalar.removeAt(0);
      final yas = muayenedilen.yas;
      if (yas >= 65) {
        bekleyenYaslilar.remove(muayenedilen);
      }
      bakilanHastalar.add(muayenedilen);
    }
  }

  static void hastaSil(Hasta h) {
    final yas = h.yas;
    if (yas >= 65) {
      bekleyenYaslilar.remove(h);
    }
    bekleyenhastalar.remove(h);
    for (int i = 0; i < bekleyenhastalar.length; i++) {
      bekleyenhastalar[i].siraNO = i;
    }
  }

  static void hastaEkleKuyruga(Hasta h) {
    final int yas = h.yas ?? 0;
    if (yas >= 65) {
      for (int i = 0; i < bekleyenYaslilar.length; i++) {
        bekleyenhastalar.removeAt(i);
      }
      bekleyenYaslilar.add(h);
      bekleyenhastalar = bekleyenYaslilar + bekleyenhastalar;
    } else {
      bekleyenhastalar.add(h);
    }
  }

  static void hastaListesi(List<Hasta> ll) {
    for (int i = 0; i < ll.length; i++) {
      print(ll[i].getInfo());
    }
  }

  static void _addPatient(Hasta patient) {
    bekleyenhastalar.add(patient);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomePage'),
        ),
        body: Stack(
          children: [],
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'İşlemler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Update the state of the app
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_box_outlined),
              title: Text('Hasta Kayıt'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HastaEklePage(
                      onPatientAdded: hastaEkleKuyruga,
                    ),
                  ),
                );
                // Update the state of the app
              },
            ),
            ListTile(
              leading: Icon(Icons.account_box_outlined),
              title: Text('Bekleyen Hastalar'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  bilgiPageBekleyen bpage = bilgiPageBekleyen();
                  return bpage.build(context);
                }));
                // Update the state of the app
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle_rounded),
              title: Text('Muayene Et'),
              onTap: () {
                _HomePageState.muayeneEtSirayaGore();

                // Update the state of the app
              },
            ),
            ListTile(
              leading: Icon(Icons.account_box_outlined),
              title: Text('Bakılan Hastalar'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  bilgiPageBakilan bpage = bilgiPageBakilan();
                  return bpage.build(context);
                }));
                // Update the state of the app
              },
            ),
            ListTile(
              leading: Icon(Icons.account_box_outlined),
              title: Text('Beck Anksiyete Testi'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    _BeckTestScreenState beck = _BeckTestScreenState();
                    return beck.build(context);
                  }),
                );
                // Update the state of the app
              },
            )
          ],
        )));
  }
}

class bilgiPageBekleyen extends StatelessWidget {
  final List<Hasta> waitingPatients = _HomePageState.bekleyenhastalar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bekleyen Hasta Listesi'),
      ),
      body: ListView.builder(
        itemCount: waitingPatients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(waitingPatients[index].getInfo()),
          );
        },
      ),
    );
  }
}

class bilgiPageBakilan extends StatelessWidget {
  final List<Hasta> waitingPatients = _HomePageState.bakilanHastalar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bakılan Hasta Listesi'),
      ),
      body: ListView.builder(
        itemCount: waitingPatients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(waitingPatients[index].getInfo()),
          );
        },
      ),
    );
  }
}

abstract class Person {
  String? name;
  String? surname;
}

class Hasta extends Person {
  bool hastaMuayenedeMi;
  String? hastaID;
  int? siraNO;
  int yas;
  String? il;
  String? yupassNo;
  String? ahBirimNo;
  String? tcKimlikNo;
  String? isim;
  String? soyisim;
  String? selectedDogumYeri;
  String? anneAdi;
  String? babaAdi;
  String? evTel;
  String? isTel;
  String? cepTel;
  String? faxNo;
  String? email;
  DateTime? mernisDogumTarihi;
  DateTime? beyanDogumTarihi;
  String? selectedSGK;
  String? selectedMedeniHal;
  String? selectedCinsiyet;
  String? selectedKayitDurumu;
  String? selectedOncelikDurumu;
  String? selectedKanGrubu;
  String? selectedUyruk; // Yeni alan
  String? dogumSirasiNo; // Yeni alan
  String? anneKimlikNo;
  List<Doktor> hastaneGecmisi;

  Hasta({
    required String name,
    required String surname,
    required this.hastaID,
    required this.yas,
    this.siraNO,
    this.il,
    this.yupassNo,
    this.ahBirimNo,
    this.tcKimlikNo,
    this.isim,
    this.soyisim,
    this.selectedDogumYeri,
    this.anneAdi,
    this.babaAdi,
    this.evTel,
    this.isTel,
    this.cepTel,
    this.faxNo,
    this.email,
    this.mernisDogumTarihi,
    this.beyanDogumTarihi,
    this.selectedSGK,
    this.selectedMedeniHal,
    this.selectedCinsiyet,
    this.selectedKayitDurumu,
    this.selectedOncelikDurumu,
    this.selectedKanGrubu,
    this.selectedUyruk,
    this.dogumSirasiNo,
    this.anneKimlikNo,
    this.hastaMuayenedeMi = false,
    List<Doktor>? hastaneGecmisi,
  }) : hastaneGecmisi = hastaneGecmisi ?? [] {
    this.name = name;
    this.surname = surname;
  } // Default empty list if null
  String getInfo() {
    return "${this.name}, ${this.surname}, ${this.yas}";
  }
}

class HastaEklePage extends StatefulWidget {
  final Function(Hasta) onPatientAdded;

  HastaEklePage({required this.onPatientAdded});

  @override
  _HastaEklePageState createState() => _HastaEklePageState();
}

class _HastaEklePageState extends State<HastaEklePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _kimlikNoController = TextEditingController();
  final TextEditingController _yupassNoController = TextEditingController();
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _soyisimController = TextEditingController();
  final TextEditingController _dogumYeriController = TextEditingController();
  final TextEditingController _anneAdiController = TextEditingController();
  final TextEditingController _babaAdiController = TextEditingController();
  final TextEditingController _evTelController = TextEditingController();
  final TextEditingController _isTelController = TextEditingController();
  final TextEditingController _cepTelController = TextEditingController();
  final TextEditingController _faxNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mernisDogumTarihiController =
      TextEditingController();
  final TextEditingController _beyanDogumTarihiController =
      TextEditingController();
  final TextEditingController _anneKimlikController = TextEditingController();

  DateTime? _mernisDogumTarihi;
  DateTime? _beyanDogumTarihi;

  String? _selectedSGK;
  String? _selectedMedeniHal;
  String? _selectedCinsiyet;
  String? _selectedKayitDurumu;
  String? _selectedOncelikDurumu;
  String? _selectedKanGrubu;
  String? _selectedUyruk;
  String? _selectedDogumSirasi;
  String? _selectedDogumYeri;

  final List<String> sgkOptions = ['SSK', 'Bağkur', 'Emekli Sandığı', 'Diğer'];
  final List<String> medeniHalOptions = ['Bekar', 'Evli', 'Boşanmış', 'Dul'];
  final List<String> cinsiyetOptions = ['Erkek', 'Kadın', 'Diğer'];
  final List<String> kayitDurumuOptions = ['Aktif', 'Pasif', 'Dondurulmuş'];
  final List<String> oncelikDurumuOptions = ['Yok', 'Yüksek', 'Orta', 'Düşük'];
  final List<String> kanGrubuOptions = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    '0+',
    '0-'
  ];
  final List<String> uyruklar = ['Türkiye', 'Yabancı'];
  final List<String> dogumSiralari = ['1', '2', '3'];
  final List<Hasta> _hastaList = [];
  final List<String> tumSehirler = [
    "Adana",
    "Adıyaman",
    "Afyonkarahisar",
    "Ağrı",
    "Aksaray",
    "Amasya",
    "Ankara",
    "Antalya",
    "Ardahan",
    "Artvin",
    "Aydın",
    "Balıkesir",
    "Bartın",
    "Batman",
    "Bayburt",
    "Bilecik",
    "Bingöl",
    "Bitlis",
    "Bolu",
    "Burdur",
    "Bursa",
    "Çanakkale",
    "Çankırı",
    "Çorum",
    "Denizli",
    "Diyarbakır",
    "Edirne",
    "Elaziğ",
    "Erzincan",
    "Erzurum",
    "Eskişehir",
    "Gaziantep",
    "Giresun",
    "Gümüşhane",
    "Hakkari",
    "Hatay",
    "Iğdır",
    "Isparta",
    "İçel (Mersin)",
    "İstanbul",
    "İzmir",
    "Kahramanmaraş",
    "Karabük",
    "Karaman",
    "Kars",
    "Kastamonu",
    "Kayseri",
    "Kırıkkale",
    "Kırklareli",
    "Kırşehir",
    "Kocaeli",
    "Konya",
    "Kütahya",
    "Malatya",
    "Manisa",
    "Mardin",
    "Muğla",
    "Muş",
    "Nevşehir",
    "Niğde",
    "Ordu",
    "Osmaniye",
    "Rize",
    "Sakarya",
    "Samsun",
    "Siirt",
    "Sinop",
    "Sivas",
    "Tekirdağ",
    "Tokat",
    "Trabzon",
    "Tunceli",
    "Şanlıurfa",
    "Uşak",
    "Van",
    "Yalova",
    "Yozgat",
    "Zonguldak"
  ];
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  //the birthday's date

  void _submit() {

    if (_formKey.currentState!.validate()) {
      // Eğer doğum tarihlerinden biri seçilmemişse, uyarı mesajı göster
      if (_mernisDogumTarihi == null || _beyanDogumTarihi == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Doğum tarihlerinin her ikisini de seçmeniz gerekiyor.')),
        );
        return;
      }
      final date2 = DateTime.now();
      final difference = daysBetween(_mernisDogumTarihi!, date2);
      int age = (difference / 365).toInt();
      // Hasta instance'ını oluştur
      Hasta newPatient = Hasta(
        name: _isimController.text,
        surname: _soyisimController.text,
        hastaID: _kimlikNoController.text,
        yas: age,
        siraNO: null,
        il: _dogumYeriController.text,
        yupassNo: _yupassNoController.text,
        ahBirimNo: null,
        tcKimlikNo: _kimlikNoController.text,
        isim: _isimController.text,
        soyisim: _soyisimController.text,
        selectedDogumYeri: _selectedDogumYeri,
        anneAdi: _anneAdiController.text,
        babaAdi: _babaAdiController.text,
        evTel: _evTelController.text,
        isTel: _isTelController.text,
        cepTel: _cepTelController.text,
        faxNo: _faxNoController.text,
        email: _emailController.text,
        mernisDogumTarihi: _mernisDogumTarihi,
        beyanDogumTarihi: _beyanDogumTarihi,
        selectedSGK: _selectedSGK,
        selectedMedeniHal: _selectedMedeniHal,
        selectedCinsiyet: _selectedCinsiyet,
        selectedKayitDurumu: _selectedKayitDurumu,
        selectedOncelikDurumu: _selectedOncelikDurumu,
        selectedKanGrubu: _selectedKanGrubu,
        selectedUyruk: _selectedUyruk,
        dogumSirasiNo: _selectedDogumSirasi,
        anneKimlikNo: _anneKimlikController.text,
        hastaneGecmisi: [],
      );
      // Yeni hastayı listeye ekle
      setState(() {
        _hastaList.add(newPatient);
      });

      // Kayıtlı hastaları console'a yazdır
      print('Kayıtlı Hastalar:');
      for (var hasta in _hastaList) {
        print('İsim: ${hasta.isim}');
        print('Soyisim: ${hasta.soyisim}');
        print('Kimlik No: ${hasta.tcKimlikNo}');
        print('Yas: ${hasta.yas}');
        print('Doğum Yeri: ${hasta.selectedDogumYeri}');
        print('Anne Adı: ${hasta.anneAdi}');
        print('Baba Adı: ${hasta.babaAdi}');
        print('Ev Tel: ${hasta.evTel}');
        print('İş Tel: ${hasta.isTel}');
        print('Cep Tel: ${hasta.cepTel}');
        print('Fax No: ${hasta.faxNo}');
        print('E-posta: ${hasta.email}');
        print('Mernis Doğum Tarihi: ${hasta.mernisDogumTarihi}');
        print('Beyan Doğum Tarihi: ${hasta.beyanDogumTarihi}');
        print('SGK Durumu: ${hasta.selectedSGK}');
        print('Medeni Hal: ${hasta.selectedMedeniHal}');
        print('Cinsiyet: ${hasta.selectedCinsiyet}');
        print('Kayıt Durumu: ${hasta.selectedKayitDurumu}');
        print('Öncelik Durumu: ${hasta.selectedOncelikDurumu}');
        print('Kan Grubu: ${hasta.selectedKanGrubu}');
        print('------------------------------');
      }

      // Hasta instance'ını callback fonksiyonuna ilet
      widget.onPatientAdded(newPatient);

      // Sayfayı kapat
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, DateTime? currentDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toLocal().toString().split(' ')[0];
        if (controller == _mernisDogumTarihiController) {
          _mernisDogumTarihi = picked;
        } else if (controller == _beyanDogumTarihiController) {
          _beyanDogumTarihi = picked;
        }
      });
    }
  }

  Widget _buildRoundedTextField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10),
        ),
        validator: validator,
        onTap: () {
          if (label.contains('Tarihi')) {
            _selectDate(context, controller, null);
          }
        },
      ),
    );
  }

  Widget _buildRoundedDropdown(
    String? selectedValue,
    List<String> options,
    String label,
    void Function(String?)? onChanged, {
    String? Function(String?)? validator,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(10),
          ),
          validator: validator,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasta Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Kişisel Bilgiler Bölümü
                Text('Kişisel Bilgiler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                _buildRoundedTextField(_isimController, 'İsim',
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  }
                  return null;
                }),
                SizedBox(height: 10),
                _buildRoundedTextField(_soyisimController, 'Soyisim',
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  }
                  return null;
                }),
                SizedBox(height: 10),
                _buildRoundedTextField(_kimlikNoController, 'Kimlik No',
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  }
                  if (value.length != 11) {
                    return 'Kimlik No 11 haneli olmalıdır';
                  }
                  return null;
                }),
                SizedBox(height: 10),
                _buildRoundedTextField(_yupassNoController, 'Yupass No',
                    validator: (value) {
                  if(value==null || value.length == 0)
                    {
                      print("inside");
                      return null;
                    }
                  if (value!= null && value.length < 6) {
                    return 'Yupass No en az 6 haneli olmalıdır';
                  }
                  return null;
                }),
                SizedBox(height: 10),
                _buildRoundedDropdown(
                  _selectedUyruk,
                  uyruklar,
                  'Uyruk',
                  (newValue) {
                    setState(() {
                      _selectedUyruk = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                Divider(height: 30, thickness: 2),
                //Aile Bilgisi
                Text('Aile Bilgileri',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                SizedBox(height: 10),
                _buildRoundedTextField(_babaAdiController, 'Baba Adı',
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  }
                  return null;
                }),
                SizedBox(height: 10),
                _buildRoundedTextField(_anneAdiController, 'Anne Adı',
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  }
                  return null;
                }),
                SizedBox(height: 10),
                _buildRoundedTextField(_anneKimlikController, 'Anne Kimlik',
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  }
                  if (value!= null && value.length < 6) {
                    return 'TC 11 haneli olmalıdır';}
                  return null;
                }),
                SizedBox(height: 10),
                _buildRoundedDropdown(
                  _selectedDogumSirasi,
                  dogumSiralari,
                  'Doğum Sırası',
                  (newValue) {
                    setState(() {
                      _selectedDogumSirasi = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                Divider(height: 30, thickness: 2),
                // Diğer Bilgiler Bölümü
                Text('Diğer Bilgiler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                _buildRoundedTextField(
                  _mernisDogumTarihiController,
                  'Mernis Doğum Tarihi',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildRoundedTextField(
                  _beyanDogumTarihiController,
                  'Beyan Doğum Tarihi',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildRoundedDropdown(
                  _selectedDogumYeri,
                  tumSehirler,
                  'Doğum Yeri',
                      (newValue) {
                    setState(() {
                      _selectedDogumYeri = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                Divider(height: 30, thickness: 2),

                // İletişim Bilgileri Bölümü
                Text('İletişim Bilgileri',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                _buildRoundedTextField(_evTelController, 'Ev Telefonu',
                    validator:null),
                SizedBox(height: 10),
                _buildRoundedTextField(_isTelController, 'İş Telefonu',
                    validator: null),
                SizedBox(height: 10),
                _buildRoundedTextField(_cepTelController, 'Cep Telefonu',
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  }
                  if(value.length != 11)
                    {
                      return 'Telefon numaranız 11 haneli olmalıdır.';
                    }
                  return null;
                }),
                SizedBox(height: 10),
                _buildRoundedTextField(_faxNoController, 'Fax Numarası',
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  }
                  return null;
                }),
                SizedBox(height: 10),
                _buildRoundedTextField(_emailController, 'E-posta',
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  }
                  // E-posta için basit bir validasyon
                  if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Geçerli bir e-posta adresi girin';
                  }
                  return null;
                }),
                Divider(height: 30, thickness: 2),

                // Diğer Bilgiler Bölümü

                SizedBox(height: 10),
                Text('Diğer Bilgiler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                _buildRoundedDropdown(
                  _selectedSGK,
                  sgkOptions,
                  'SGK Durumu',
                  (newValue) {
                    setState(() {
                      _selectedSGK = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                _buildRoundedDropdown(
                  _selectedMedeniHal,
                  medeniHalOptions,
                  'Medeni Hal',
                  (newValue) {
                    setState(() {
                      _selectedMedeniHal = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildRoundedDropdown(
                  _selectedCinsiyet,
                  cinsiyetOptions,
                  'Cinsiyet',
                  (newValue) {
                    setState(() {
                      _selectedCinsiyet = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildRoundedDropdown(
                  _selectedKayitDurumu,
                  kayitDurumuOptions,
                  'Kayıt Durumu',
                  (newValue) {
                    setState(() {
                      _selectedKayitDurumu = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildRoundedDropdown(
                  _selectedOncelikDurumu,
                  oncelikDurumuOptions,
                  'Öncelik Durumu',
                  (newValue) {
                    setState(() {
                      _selectedOncelikDurumu = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _buildRoundedDropdown(
                  _selectedKanGrubu,
                  kanGrubuOptions,
                  'Kan Grubu',
                  (newValue) {
                    setState(() {
                      _selectedKanGrubu = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bu alan boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Kaydet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Kerem's code:

// Kerem Döleksöz

Widget iconandtext(IconData icon, String text) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: Colors.black),
      SizedBox(width: 8),
      Text(text),
    ],
  );
}

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  _HomePageState2 createState() => _HomePageState2();
}

class _HomePageState2 extends State<HomePage2> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    // Sunucuya göndereceğimiz URL
    final url = Uri.parse('https://ahbs.sisoft.com.tr/sisoft/LoginMan.do');

    // Gönderilecek veriler
    final data = {
      'uskod': _emailController.text,
      'pwd': _passwordController.text,
    };

    // POST isteği gönderme
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'czmfunction': 'doLogin',
        'Czmformno': '1608',
      },
      body: data,
    );

    // Gelen yanıtı işleme
    if (response.statusCode == 200) {
      // Yanıtı konsola yazdırma
      print('Yanıt: ${response.body}');

      // Yanıt gövdesini XML olarak ayrıştırma
      final document = xml.XmlDocument.parse(response.body);
      final codeElement = document.findAllElements('code').first;

      // Yanıtın içeriğine göre işlem yapma
      if (codeElement.text == '1') {
        // İstek başarılı olduysa giriş ekranına yönlendirme
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // Yanıttan hata mesajı alma
        final errorMessage = 'Hatalı kullanıcı adı veya parola';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } else {
      // Yanıtı konsola yazdırma
      print('Yanıt: ${response}');

      // Bir hata oluştuysa kullanıcıya bildirme
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Geçersiz e-posta veya şifre')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/sisofamily.png'),
        backgroundColor: Color.fromARGB(255, 236, 233, 233),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Aile Hekimliği Bilgi Sistemi',
              style: TextStyle(
                fontSize: 25,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Form(
              child: Row(
                children: [
                  Image.asset('assets/leftheader.png'),
                ],
              ),
            ),
            Form(
              child: Column(
                children: [
                  Text(
                      "Türkiye'nin en hızlı gelişen aile hekimliği bilgi sistemine hoşgeldiniz. Kullanıcı bilgileriniz ile sisteme giriş yapabilirsiniz"),
                ],
              ),
            ),
            Form(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-posta',
                      hintText: 'E-postanızı girin',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: 'Parola',
                      hintText: 'Parolanızı girin',
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    if (_emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Lütfen E-posta adresinizi giriniz')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Yeni Şifreniz SMS Olarak İletildi')),
                      );
                    }
                  },
                  icon: Icon(Icons.question_mark, color: Colors.grey),
                  label: Text(
                    'Şifremi Unuttum ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(10.0),
                    textStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => esign(),
                      ),
                    );
                  },
                  child: Text('E-İmza'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10.0),
                    fixedSize: Size(150, 65),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Giriş'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10.0),
                    fixedSize: Size(150, 65),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Image.asset('assets/line.png'),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.topRight,
              child: Image.asset('assets/rightheader.png'),
            ),
            Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.start,
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                iconandtext(Icons.check, 'İşletim sistemi bağımsızlığı'),
                iconandtext(Icons.check, 'İnternet tarayıcı bağımsızlığı'),
                iconandtext(Icons.check, 'Hızlı erişim sağlayan akıllı menü'),
                iconandtext(Icons.check, 'Anlık performans takip sistemi'),
                iconandtext(Icons.check, 'Aile bireylerini otomatik tanıma'),
                iconandtext(
                    Icons.check, 'İnsan modeli üzerinden bulgu ekleyebilme'),
              ],
            ),
            SizedBox(height: 20),
            Image.asset('assets/line.png'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Savedoctor(), // Use the imported Savedoctor class
                      ),
                    );
                  },
                  icon: Icon(Icons.account_box_outlined, color: Colors.grey),
                  label: Text(
                    'Yeni Hekim Kaydet ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(10.0),
                    textStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 35,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Savedoctor extends StatefulWidget {
  @override
  _SavedoctorState createState() => _SavedoctorState();
}

class _SavedoctorState extends State<Savedoctor> {
  bool _isChecked = false; // Checkbox'ın durumu
  bool _isIlceFilled =
      false; // İlçe alanının doldurulup doldurulmadığını kontrol

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/sisofamily.png'),
        backgroundColor: Color.fromARGB(255, 236, 233, 233),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.black),
                SizedBox(width: 8),
                Text('Kimlik Bilgileri', style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                Text('Aile Hekimi Değilim'),
              ],
            ),
            SizedBox(height: 15),
            textbar('Adı'),
            SizedBox(height: 10),
            textbar('Soyadı'),
            SizedBox(height: 10),
            textbar('TC Kimlik No'),
            SizedBox(height: 10),
            textbar('ÇKYS Kodu'),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'İlçe',
                      hintText: '...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isIlceFilled = value.isNotEmpty;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    enabled: _isIlceFilled,
                    decoration: InputDecoration(
                      labelText: 'İl',
                      hintText: '...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (_isChecked == false) ...[
              textbar('A.H. Birim Numarası'),
            ],
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '* Tüm alanların doldurulması zorunludur',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle save action
                },
                child: Text('Kaydet'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10.0),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textbar(String text) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: text,
        hintText: '...',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class esign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/sisofamily.png'),
        backgroundColor: Color.fromARGB(255, 236, 233, 233),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'PIN Numaranızı Giriniz',
                  hintText: '...',
                  prefixIcon: Icon(Icons.sms),
                  border: OutlineInputBorder()),
            ),
            ElevatedButton(onPressed: () {}, child: Text('Gönder'))
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _redirectToUrl();
  }

  Future<void> _redirectToUrl() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/sisofamily.png'),
        backgroundColor: Color.fromARGB(255, 236, 233, 233),
        centerTitle: true,
      ),
      body: HomePage(),
    );
  }
}

class Doktor extends Person {
  String? branch;
  List<Hasta> bakilmisHastalar = [];
  Doktor(String name, String surname, String branch) {
    this.name = name;
    this.surname = surname;
    this.branch = branch;
  }
  void hastaBak(Hasta hasta) {
    this.bakilmisHastalar.add(hasta);
    hasta.hastaneGecmisi.add(this);
  }
}
