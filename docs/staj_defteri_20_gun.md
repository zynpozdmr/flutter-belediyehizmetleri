# 20 Günlük Staj Defteri – Flutter Belediye Hizmetleri Uygulaması (Anlatı Tarzı)

Bu defter, proje üzerinde geçirdiğim 20 günü, teknik kararlar, karşılaştığım sorunlar ve bunların arkasındaki neden–sonuç ilişkileriyle birlikte anlatı şeklinde aktarıyor. Her gün, yalnızca “ne yaptım” değil, “neden böyle yaptım ve başka ne seçenekler vardı?” sorularına da cevap veriyor.

---

## Gün 1 – Başlangıç, sınırların çizilmesi
Bugün öncelikle geliştirme ortamını ayağa kaldırdım: Flutter SDK kuruldu, `flutter doctor` ile bileşenlerin sağlığı kontrol edildi. Proje iskeletini oluşturarak pubspec.yaml’a temel bağımlılıkları (firebase_core, firebase_auth, cloud_firestore, geolocator, geocoding, provider, get_it) ekledim. İlk kurulumda amacım hızlıca “çalışır iskelet”e ulaşmaktı; çünkü üstüne kademeli iyileştirme ve refaktör yapmak, baştan mükemmel bir mimari kurmaya çalışmaktan çoğu zaman daha etkili.

## Gün 2 – Mimari çerçevenin netleştirilmesi
Klasör hiyerarşisini Clean Architecture’a yakın kurguladım: `domain` (kurallar ve sözleşmeler), `data` (harici sistemlerle konuşan implementasyonlar), `presentation` (UI ve state), `core` (temel sabitler/DI/hatalar). Bu ayrım, bağımlılık yönünü domain → presentation yerine tersi yönde kurulmasını engelleyerek DIP’yi (Dependency Inversion Principle) koruyor. Domain’i “saf” tutmak, test edilebilirliği ve ileride yapılacak refaktörlerin esnekliğini artırıyor.

## Gün 3 – Firebase ile ilk bağ
Firebase Console’da proje oluşturup “çoklu platform” opsiyonlarını değerlendirdim. `firebase_options.dart` üretildikten sonra `main.dart` içinde `Firebase.initializeApp(options: ...)` çağrısını uyguladım. Burada kritik tercih: asenkron başlatmayı `WidgetsFlutterBinding.ensureInitialized()` ardından yapmak ve hatayı yukarıya kabarcıklatmadan, anlamlı loglarla görünür kılmak. Böylece erken aşamada yapılandırma yanlışlarını yakalayabiliyorum.

## Gün 4 – Görsel kimliğin temeli
Tasarımın tutarlılığı için `core/constants/app_colors.dart` ve `app_text_styles.dart` dosyalarını oluşturup MaterialApp theme’e entegre ettim. AppBarTheme, TextTheme, ElevatedButtonTheme ve InputDecorationTheme ile kullanıcıya “aynı ürün” hissi veren bir dil sağlandı. Erken aşamada tema dili oturtmak, ekrana yeni bileşen eklendikçe fire verilmesini engelliyor.

## Gün 5 – Kimlik doğrulamada sözleşme önce
Önce interface, sonra implementasyon: `domain/repositories/auth_repository.dart` içinde login/register/forgot yapılarının sözleşmesini tanımladım. Hata politikası için `core/errors/auth_exception.dart` iskeleti açıldı. Buradaki amaç, UI’nin somut veri kaynağından habersiz kalması; Firebase kullanılmasa dahi kontrat bozulmadan farklı bir sağlayıcı takılabilsin.

## Gün 6 – Firebase Auth implementasyonu
`data/repositories/auth_repository_impl.dart` ile Firebase Auth’a bağlanan gerçeklemeyi yazdım. Burada kritik nokta, hataların kullanıcıya doğrudan sızması yerine domain seviyesinde anlamlı istisnalara çevrilmesi. Örneğin şifre zayıfsa veya kullanıcı bulunamazsa, bu durumlar UI’de hedefe yönelik geri bildirimlere dönüştü.

## Gün 7 – Provider ile durumun merkezileştirilmesi
`presentation/providers/auth_provider.dart` ile oturum akışını yöneten basit ama genişlemeye uygun bir state makinesi kurdum. LoginPage, RegisterPage ve ForgotPasswordPage formlarını bağlarken, form doğrulama ve “yükleniyor/başarısız/başarılı” durumlarını tek merkezden yönetmek işleri büyük ölçüde sadeleştirdi. Rotaları MaterialApp içine alarak akışı konsolide ettim.

## Gün 8 – Splash’te karar: nereye gideceğiz?
Splash ekranı yalnızca bir bekleme değil, yönlendirme kararının alındığı yerdir. Auth durumunu kontrol edip kullanıcıyı `/login` ya da `/main` rotasına taşıyacak mekanizmayı tasarladım. Burada asıl mesele “yarı başlatılmış oturum” gibi köşe durumlarıdır; bu yüzden Splash’i olası kenar durumları için genişletilebilir bıraktım.

## Gün 9 – Hizmet veri modelinin (ServiceModel) keskinleştirilmesi
`ServiceModel`’i id, name, description, opsiyonel imageUrl ve category alanlarıyla tanımladım. `fromMap/toMap` dönüşümleri sayesinde Firestore ile kayıpsız iletişim kuruyoruz. Burada tip güvenliği önemli: UI’nin beklediği alanların türleri ile veritabanı belgelerinin alan tipleri bire bir eşlenmek zorunda.

## Gün 10 – Firestore erişimi ve sorgu ergonomisi
`ServiceRepository` ile domain sözleşmesini, `ServiceRepositoryImpl` ile Firestore sorgularını yazdım. Şehir bazlı filtrelemede `city` alanını lower-case standardize ettim; böylece “İzmir/izmir/İZMİR” varyasyonları tek normda eşleşiyor. Bu tür normalizasyonlar, sonradan veri kalitesiyle boğuşmamak için erken aşamada hayati.

## Gün 11 – Konum servisinde soyutlama
Konum erişimi platforma ve izinlere sıkı sıkıya bağlıdır. `domain/services/location_service.dart` ile arayüzü belirleyip UI ve repository katmanlarını bu sözleşmeye bağladım. Böylece Geolocator yerine alternatif bir sağlayıcıya geçmek veya testlerde sahte (fake) konum vermek çok kolaylaştı.

## Gün 12 – İzinler, hatalar ve timeout’lar
`LocationServiceImpl` içinde önce servis açık mı (isLocationServiceEnabled), ardından izinler (checkPermission/requestPermission) kontrol edildi. Konum alma çağrısını `timeout(Duration(seconds: 20))` ile sardım; bu, sahada rastlayabildiğimiz “beklenmedik şekilde uzun süren” GPS sorunlarını kullanıcı deneyimini kilitlemeden çözmemizi sağlıyor. Hataları açıklayıcı mesajlarla sarmalayarak üst katmana taşıdım.

## Gün 13 – ServiceProvider: akışların buluşma noktası
`fetchServicesForCurrentCity` akışında önce konum alınıyor, sonra geocoding ile şehir tespit ediliyor ve nihayet Firestore’dan ilgili hizmetler çekiliyor. `_isLoading` ve `_errorMessage` gibi durum alanları UI’nin sade ve doğru tepki vermesini sağlıyor. Buradaki ana risk, zincirin herhangi bir halkasında başarısızlık tüm akışı düşürebilir; bu nedenle her adımda koruyucu kontroller uyguladım.

## Gün 14 – Geocoding gerçekleri ve sağlam bir geri plan
`placemarkFromCoordinates` çoğu zaman doğru sonuç verse de, sahada ağ/servis kısıtları nedeniyle başarısız olabilir. Bu yüzden basit bir koordinat aralığı fallback’i bıraktım; gerçek hayatta bu kısım daha sofistike bir yerelleştirme servisine devredilebilir. Amaç: “asla tamamen boş dönme”, her zaman kullanıcıya anlaşılır bir geri bildirim bırakma.

## Gün 15 – Listelemenin kullanıcıya yansıması
`main_page.dart` içinde Provider’dan gelen durumlar: yükleniyor, hata, boş ve veri var. Her birine özel UI şablonları kurguladım. Bu yaklaşım, sayfayı test ederken belirli senaryoları hızlıca simüle etmeme imkân verdi ve regressions’ı erken yakalamamı sağladı.

## Gün 16 – Hata deneyimi: semptom değil, neden
Bugün hata ekranlarını “bilgi verici” hale getirdim. Sadece “hata oluştu” demek yerine, örneğin konum izni reddedildiyse bunu açıkça söyleyip kullanıcının ayarlara gitmesi gerektiğini belirttim. Böylece çağrı merkezi yükünü azaltacak, kullanıcıyı yönlendiren bir dil elde ettim. Hataları merkezileştirmek, gelecekte analitik/raporlama entegrasyonuna da zemin hazırlıyor.

## Gün 17 – DI düzeni ve görünmez borular
GetIt ile `setupLocator()` düzenini sadeleştirip gereksiz importları temizledim. Provider’ları factory olarak kaydedip, repository ve servisleri lazy singleton yaptım. Bu, nesne yaşam döngüsünü kontrol etmeyi kolaylaştırdı ve bellekte gereksiz çoğaltmaları önledi. Kodun görünmez ama kritik borularını sağlamlaştırdım.

## Gün 18 – İzin akışında kararlılık
`denied` ve `deniedForever` durumlarına özel mesajlar ve alternatif akışlar kurguladım. Bu tür köşe durumları saha koşullarında sık görülür; kullanıcıyı doğru metinlerle yönlendirmek, ürüne dair algıyı doğrudan etkiler. İzin verilmese de uygulamanın “kibarca” çalışmaya devam etmesi hedeflendi.

## Gün 19 – Senaryo bazlı test ve duman testi
Konum açık/kapalı, izin var/yok, Firestore’da veri mevcut/yok senaryolarını tek tek gezdim. Loglarda hata izlerini takip ederek darboğazları belirledim. Burada amaç %100 otomasyon değil, yüksek riskli akışları manuel olarak doğrulayıp yayın öncesi sürprizleri minimize etmekti.

## Gün 20 – Belgeler, son dokunuşlar ve sürdürülebilirlik
Staj defterini (bu belgeyi) hazırlayıp README’yi güncelledim. Küçük refaktörler ve yorum satırlarıyla kodun gelecekteki geliştiriciler tarafından anlaşılmasını kolaylaştırdım. Proje, sürdürülebilir bir tabana kavuştu: bağımlılıklar net, sorumluluklar ayrık ve akışlar ölçümlenebilir hale geldi.

---

## Ek Teknik Yansımalar
- DI stratejisi: Interface üzerinden çözümleme, `registerLazySingleton` (kaynak paylaşımı) ve `registerFactory` (stateful provider’lar) ayrımı.
- Veri standardizasyonu: Firestore sorgularında `city` alanının lower-case normalize edilmesi; veri kalitesi problemlerini erken evrede bastırır.
- Konum güvenliği: Servis/izin kontrolü ve timeout ile kullanıcıyı bekletmeme; tüm hataları anlamlı Exception’lara dönüştürme.
- Geocoding sağlamlığı: Ağ sorunlarında fallback; “asla tamamen boş” ilkesine uygun kullanıcı mesajları.
- UI durumsallığı: `isLoading`, `errorMessage`, boş/veri var şablonları; test edilebilir ve genişletilebilir UI.

