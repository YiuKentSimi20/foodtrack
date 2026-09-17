Adresa repository-ului gitlab.upt.ro: https://gitlab.upt.ro/alexandru.ilia/foodtrack

Pentru compilarea și rularea proiectului este nevoie de:
- Docker Desktop pornit
- Flutter SDK instalat și adăugat in variabilele de mediu (PATH)
- Android Studio cu un emulator Android virtual sau un dispozitiv fizic Android conectat cu "USB Debugging" activat

Pașii de rulare:
- Se rulează comanda "docker-compose up -d --build" într-un terminal deschis în directorul root al proiectului, care conține fișierul "docker-compose.yml"
- Se navighează către directorul aplicației mobile: "cd frontend-flutter"
- Se descarcă și actualizează dependențele proiectului rulând comanda "flutter pub get"
- Se pornește emulatorul sau se conectează dispozitivul fizic
- Se rulează aplicația, aici există două posibilități:
1. Dacă folosiți un emulator:
Se rulează comanda "flutter run" sau se deschide directorul "frontend-flutter" direct din Android Studio și se apasă butonul de play cu dispozitivul dorit selectat.
2. Dacă folosiți un telefon mobil fizic:
Telefonul trebuie conectat la aceeași rețea Wi-Fi ca și dispozitivul pe care rulează containerele Docker. Pentru a redirecționa aplicația către serverul local, se transmite în linia de comandă variabila de mediu "BASE_URL" ca fiind adresa IPv4 a computerului dumneavoastră pe rețeaua locală cu portul 8083. De exemplu, pentru adresa 192.168.1.6, comanda devine: "flutter run --dart-define=BASE_URL=http://192.168.1.6:8083". Alternativ, se poate adăuga variabila de mediu BASE_URL în configurația din meniul de rulare al Android Studio.

Pentru a opri containerele Docker se deschide un terminal în directorul root al proiectului și se rulează comanda "docker-compose down".
