# FoodTrack Backend API

Documentatie API pentru integrarea frontend (Flutter).

## 1) Base URL si autentificare

- Base URL local: `http://localhost:8083`
- Header pentru endpointurile protejate:

```http
Authorization: Bearer <jwt_token>
```

### Endpointuri publice
- `POST /foodtrack/auth/register`
- `POST /foodtrack/auth/login`
- `POST /foodtrack/auth/register/test`

Conform `SecurityConfig`, toate rutele in afara de `/foodtrack/auth/**` sunt protejate.

## 2) Formate standard de raspuns

### `ApiResponse<T>`
Folosit pe majoritatea endpointurilor write (POST/PUT/PATCH/DELETE):

```json
{
  "status": 200,
  "message": "text",
  "data": {},
  "errors": null,
  "timestamp": "2026-04-30T12:00:00"
}
```

Campuri:
- `status` (int)
- `message` (string)
- `data` (T)
- `errors` (map, optional)
- `timestamp` (datetime, optional)

### `ApiErrorResponse`
Format de eroare (poate varia usor in functie de handler):

```json
{
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "path": "/foodtrack/auth/register",
  "timestamp": "2026-04-30T12:00:00",
  "fieldErrors": [
    {
      "field": "email",
      "rejectedValue": "abc",
      "message": "email should be valid"
    }
  ]
}
```

### Token expirat (`TOKEN_EXPIRED`)
Cand JWT-ul a expirat, backend-ul intoarce `401 Unauthorized`:

```json
{
  "status": 401,
  "error": "TOKEN_EXPIRED",
  "message": "Your session has expired. Please log in again.",
  "timestamp": "2026-05-05T12:00:00"
}
```

### Resursa nu gasita (`404 Not Found`)
Cand o resursa (aliment, masa etc.) nu exista in baza de date, backend-ul intoarce `404 Not Found`:

```json
{
  "status": 404,
  "error": "NOT_FOUND",
  "message": "Nu s-a putut recunoaște mâncarea din imagine.",
  "path": "/foodtrack/aliment/99999",
  "timestamp": "2026-05-05T12:00:00"
}
```

## 3) Valori enum (importante pentru Flutter)

### `GenUtilizator`
- `M`
- `F`
- `ALTUL`

### `NivelActivitate`
- `SEDENTAR`
- `MAI_PUTIN_ACTIV`
- `ACTIV`
- `FOARTE_ACTIV`

### `CategorieAliment`
- `ALTELE`, `BUTURI`, `BRANZETURI`, `CARNE`, `CEREALE`, `CONDIMENTE`, `DULCIURI`, `FAST_FOOD`, `FRUCTE`, `GRASIMI`, `LACTATE`, `LEGUME`, `MANCARE_GATITA`, `MEZELURI`, `OUA`, `PAINE`, `PERSONAL`, `PESTE`, `SEMINTE`, `SNACKURI`, `SOSURI`, `SUPLIMENTE`

### `NutritionScore`
- `A`, `B`, `C`, `D`, `E`, `UNKNOWN`

### `TipInregistrare`
- `MANUAL`
- `CATALOG`

## 4) Endpointuri pe controllere

## AuthenticationController
Base path: `/foodtrack/auth`

### `POST /foodtrack/auth/register`
- Auth: public
- Request: `RegisterRequest`
- Response: `AuthenticationResponse`

### `POST /foodtrack/auth/login`
- Auth: public
- Request: `AuthenticationRequest`
- Response: `AuthenticationResponse`

### `POST /foodtrack/auth/register/test`
- Auth: public
- Request: `RegisterRequest`
- Response: `RegisterRequest`

## AlimentController
Base path: `/foodtrack/aliment`

### `GET /foodtrack/aliment/search-by-name-mock`
- Auth: required
- Query: `name` (string)
- Response: `List<Aliment>`

### `GET /foodtrack/aliment/search-by-name`
- Auth: required
- Query: `name` (string)
- Response: `List<AlimentDto>`

### `GET /foodtrack/aliment/search-by-barcode`
- Auth: required
- Query: `barcode` (string)
- Response: `AlimentDto`

### `GET /foodtrack/aliment/detalii`
- Auth: required
- Method: `GET` (nota: endpoint-ul primeste un body JSON, desi este GET)
- Request body: `AlimentDto`
- Response: `DetaliiAlimentResponse`
- Descriere: calculeaza detaliile nutritionale pentru alimentul trimis in body (densitate calorica si procentele pentru proteine, carbohidrati si grasimi)

Example request:
```json
{
  "id": 10,
  "product_name": "Iaurt grecesc",
  "brands": "Brand X",
  "code": "5940000000000",
  "is_validated": true,
  "energy_kcal_100g": 120,
  "energy_kj_100g": 502,
  "fat_100g": 8.5,
  "saturated_fat_100g": 5.0,
  "carbohydrates_100g": 4.2,
  "sugars_100g": 4.1,
  "fiber_100g": 0.0,
  "protein_100g": 7.8,
  "salt_100g": 0.12,
  "nutrition_score": "B",
  "categorie": "LACTATE"
}
```

Example response (`DetaliiAlimentResponse`):
```json
{
  "densitate_calorica": 1.2,
  "protein_percent": 26.0,
  "carbohydrates_percent": 14.0,
  "fat_percent": 60.0
}
```

### `POST /foodtrack/aliment`
- Auth: required
- Request: `CreateAlimentRequest`
- Response: `ApiResponse<AlimentDto>`

### `PUT /foodtrack/aliment?id={id}`
- Auth: required
- Query: `id` (long)
- Request: `CreateAlimentRequest`
- Response: `ApiResponse<AlimentDto>`

### `PATCH /foodtrack/aliment/validate?id={id}`
- Auth: required, ADMIN only
- Query: `id` (long)
- Response: `ApiResponse<AlimentDto>`

### `GET /foodtrack/aliment/alimente-utilizator`
- Auth: required
- Response: `List<AlimentDto>`
- Descriere: returneaza alimentele create de utilizatorul autentificat

### `GET /foodtrack/aliment/alimente-nevalidate`
- Auth: required, ADMIN only
- Response: `List<AlimentDto>`
- Descriere: returneaza toate alimentele nevalidate

## FoodRecognitionController
Base path: `/foodtrack/model`

### `GET /foodtrack/model/predict`
- Auth: required
- Request: multipart/form-data cu `file` (imagine JPG/PNG/WEBP)
- Response: `AlimentDto`
- Descriere: trimite o imagine (JPG, PNG sau WEBP) catre modelul de AI pentru a recogniza alimentul. Intoarce detaliile alimentului detectat sub forma `AlimentDto`.

Example curl request:
```bash
curl -v -X GET \
  -H "Authorization: Bearer <JWT>" \
  -F "file=@/path/to/image.jpg" \
  http://localhost:8083/foodtrack/model/predict
```

Example response (`AlimentDto`):
```json
{
  "id": 42,
  "product_name": "Măr roșu",
  "brands": "Cultivat local",
  "code": "0000000000000",
  "is_validated": true,
  "energy_kcal_100g": 52,
  "energy_kj_100g": 218,
  "fat_100g": 0.2,
  "saturated_fat_100g": 0.0,
  "carbohydrates_100g": 13.8,
  "sugars_100g": 10.4,
  "fiber_100g": 2.4,
  "protein_100g": 0.3,
  "salt_100g": 0.0,
  "nutrition_score": "A",
  "categorie": "FRUCTE"
}
```

Note: Maxim 5MB per imagine. Doar multipart/form-data se acceptă.

## MasaController
Base path: `/foodtrack/masa`

### `GET /foodtrack/masa/mese`
- Auth: required
- Query optional:
  - `startingDate` (`yyyy-MM-dd`)
  - `endingDate` (`yyyy-MM-dd`)
- Response: `List<MasaResponse>`

### `GET /foodtrack/masa/{id}`
- Auth: required
- Path: `id` (Long)
- Response: `MasaResponse`
- Descriere: returneaza detaliile unei mese specifice dupa ID

### `GET /foodtrack/masa/raport`
- Auth: required
- Query params (required):
  - `startingDate` (LocalDate, format `yyyy-MM-dd`) - startul intervalului de raport
  - `endingDate`   (LocalDate, format `yyyy-MM-dd`) - sfarsitul intervalului de raport
- Behavior: returneaza un `MesePeZiResponse` pentru fiecare zi din interval (inclusiv zile fara mese). Zilele fara mese apar cu `mese: []` si totaluri = 0, dar cu valorile `obiectiv_*` completate atunci cand exista obiectiv pentru acea data.
- Response: `List<MesePeZiResponse>`

### `POST /foodtrack/masa/adauga-inregistrare-aliment`
- Auth: required
- Request: `InregistrareAlimentRequest`
- Response: `ApiResponse<InregistrareAlimentResponse>`

### `POST /foodtrack/masa/inregistrare-manuala`
- Auth: required
- Request: `InregistrareManualaRequest`
- Response: `ApiResponse<InregistrareAlimentResponse>`

### `DELETE /foodtrack/masa/sterge-inregistrare-aliment/{id}`
- Auth: required
- Path: `id` (long)
- Response: `ApiResponse<Void>`

### `PATCH /foodtrack/masa/modifica-gramaj-inregistrare-aliment`
- Auth: required
- Request: `ModificareGramajInregistrareAlimentRequest`
- Response: `ApiResponse<InregistrareAlimentResponse>`

### `PATCH /foodtrack/masa/modifica-inregistrare-manuala`
- Auth: required
- Request: `ModificareInregistrareManualaRequest`
- Response: `ApiResponse<InregistrareAlimentResponse>`

### `GET /foodtrack/masa/categorie-masa`
- Auth: required
- Response: `List<CategorieMasaDto>`

### `PUT /foodtrack/masa/categorie-masa`
- Auth: required
- Request: `UpdateCategoriiMeseRequest`
- Response: `ApiResponse<List<CategorieMasaDto>>`

## MasuratoareController
Base path: `/foodtrack/masuratoare`

### GET
- `GET /masuratori-greutate` -> `List<MasuratoareGreutateDto>`
- `GET /masuratori-intaltime` -> `List<MasuratoareInaltimeDto>`
- `GET /masuratori-grasime-corporala` -> `List<MasuratoareGrasimeCorporalaDto>`
- `GET /obiective` -> `List<ObiectivResponse>`
- `GET /obiective/preview` -> `ObiectivResponse`

Toate necesita auth.

### `GET /foodtrack/masuratoare/obiective/preview`
- Auth: required
- Method: `GET` (nota: acest endpoint accepta un body JSON cu `ObiectivDto` pentru calculul preview-ului)
- Request body: `ObiectivDto` (exemplu mai jos)
- Response: `ObiectivResponse`
- Descriere: returneaza un preview calculat pentru obiectiv (procentele pentru macronutrienti, calorii nete estimate, modificare kg/saptamana etc.) pe baza valorilor trimise in `ObiectivDto`. Nu persista obiectivul in baza de date — este doar un calcul local.

Example request (body JSON):
```json
{
  "data": "2026-04-01",
  "obiectiv_calorii_zi": 2200,
  "obiectiv_proteine_zi": 140,
  "obiectiv_carbohidrati_zi": 250,
  "obiectiv_grasimi_zi": 70
}
```

Example response (`ObiectivResponse`):
```json
{
  "data": "2026-04-01",
  "obiectiv_calorii_zi": 2200.0,
  "obiectiv_proteine_zi": 140.0,
  "obiectiv_proteine_procent": 25.0,
  "obiectiv_carbohidrati_zi": 250.0,
  "obiectiv_carbohidrati_procent": 45.0,
  "obiectiv_grasimi_zi": 70.0,
  "obiectiv_grasimi_procent": 30.0,
  "proteine_kg_corp": 1.8,
  "carbohidrati_kg_corp": 2.8,
  "grasimi_kg_corp": 0.9,
  "calorii_nete_zi": 350.0,
  "modificare_kg_saptamana": -0.5
}
```

### POST
- `POST /greutate` -> request `MasuratoareGreutateDto`, response `ApiResponse<MasuratoareGreutateResponse>`
- `POST /inaltime` -> request `MasuratoareInaltimeDto`, response `ApiResponse<MasuratoareInaltimeResponse>`
- `POST /grasime-corporala` -> request `MasuratoareGrasimeCorporalaDto`, response `ApiResponse<MasuratoareGrasimeCorporalaResponse>`
- `POST /obiective` -> request `ObiectivDto`, response `ApiResponse<ObiectivDto>`

Toate necesita auth.

## UtilizatorController
Base path: `/foodtrack/utilizator`

### `GET /foodtrack/utilizator/date-personale`
- Auth: required
- Response: `DatePersonaleResponse`

### `PATCH /foodtrack/utilizator/modifica-date-personale`
- Auth: required
- Request: `ModificaDatePersonaleRequest`
- Response: `ApiResponse<DatePersonaleResponse>`

### `GET /foodtrack/utilizator/alimente-utilizator`
- Eliminat din `UtilizatorController` si mutat in `AlimentController`.
- Vezi sectiunea `AlimentController`.

## 5) DTO-uri detaliate (contract pentru Flutter)

Mai jos sunt DTO-urile actuale din cod cu numele exacte de proprietăți JSON (foloseste aceste chei în Flutter).

### Auth DTO

`AuthenticationRequest`
```json
{
  "identifier": "email_sau_username",
  "password": "parola"
}
```

`AuthenticationResponse`
```json
{
  "token": "jwt"
}
```

`RegisterRequest` (exemplu)
```json
{
  "username": "john",
  "email": "john@mail.com",
  "password": "StrongPass1!",
  "data_nasterii": "2000-01-01",
  "gen": "M",
  "nivel_activitate": "ACTIV",
  "obiectiv": {
    "data_masuratoare": "2026-04-01",
    "obiectiv_calorii_zi": 2200,
    "obiectiv_proteine_zi": 140,
    "obiectiv_carbohidrati_zi": 250,
    "obiectiv_grasimi_zi": 70
  },
  "masuratoare_grasime_corporala": {
    "grasime_corporala_procent": 18.5,
    "data_masuratoare": "2026-04-01"
  },
  "masuratoare_greutate": {
    "greutate_kg": 75.0,
    "data_masuratoare": "2026-04-01"
  },
  "masuratoare_inaltime": {
    "inaltime_cm": 180.0,
    "data_masuratoare": "2026-04-01"
  }
}
```

Reguli importante (din DTO-uri):
- `username`: required, 3..20 chars
- `email`: required, email valid
- `password`: required, 8..64, litera mica + mare + cifra + caracter special
- `data_nasterii`: required, `yyyy-MM-dd`, trebuie sa fie in trecut
- `gen`: required, `M|F|ALTUL`
- `nivel_activitate`: required, `SEDENTAR|MAI_PUTIN_ACTIV|ACTIV|FOARTE_ACTIV`

### Aliment DTO

`CreateAlimentRequest` (exact proprietăți JSON din DTO)
```json
{
  "product_name": "Iaurt",
  "brands": "Brand",
  "code": "123456789",
  "energy_kcal_100g": 60,
  "fat_100g": 3.0,
  "saturated_fat_100g": 1.9,
  "carbohydrates_100g": 4.7,
  "sugars_100g": 4.7,
  "fiber_100g": 0.0,
  "protein_100g": 3.4,
  "salt_100g": 0.1,
  "categorie": "LACTATE"
}
```

Required + positive (din DTO): `energy_kcal_100g`, `fat_100g`, `carbohydrates_100g`, `protein_100g`.

`AlimentDto` (response) - proprietăți JSON exacte:
- `id`, `product_name`, `brands`, `code`, `is_validated`
- nutrienti: `energy_kcal_100g`, `energy_kj_100g`, `fat_100g`, `saturated_fat_100g`, `carbohydrates_100g`, `sugars_100g`, `fiber_100g`, `protein_100g`, `salt_100g`
- `nutrition_score`, `categorie`

`DetaliiAlimentResponse`:
```json
{
  "densitate_calorica": 1.2,
  "protein_percent": 26.0,
  "carbohydrates_percent": 14.0,
  "fat_percent": 60.0
}
```

### Endpoint-uri legate de aliment/validare
- `GET /foodtrack/aliment/alimente-utilizator` -> `List<AlimentDto>` (alimente create de utilizator)
- `GET /foodtrack/aliment/alimente-nevalidate` -> `List<AlimentDto>` (ADMIN only)

### Masa / Inregistrari DTO

`InregistrareAlimentRequest` (JSON properties from DTO)
```json
{
  "categorie_masa_id": 1,
  "data": "2026-04-30",
  "grams": 150,
  "id_aliment": 10
}
```

Validări (din DTO): `categorie_masa_id` required, `data` required (`yyyy-MM-dd`), `grams` required & positive, `id_aliment` required.

`InregistrareManualaRequest`
```json
{
  "nume_masa": 1,
  "data": "2026-04-30",
  "grams": 120,
  "energy_kcal": 300,
  "fat": 10,
  "carbohydrates": 30,
  "fiber": 3,
  "protein": 20
}
```

Notă: `nume_masa` este cheia JSON, dar reprezintă `categorieMasaId` (Long) în DTO.

`ModificareGramajInregistrareAlimentRequest`
```json
{
  "id_inregistrare": 123,
  "grams": 180
}
```

`ModificareInregistrareManualaRequest`
```json
{
  "id": 123,
  "grams": 180,
  "calories": 250,
  "fat": 8,
  "carbohydrates": 28,
  "fiber": 2,
  "protein": 18
}
```

`InregistrareAlimentResponse` (response DTO) con proprietăți importante (exemple):
- `id`, `grams`, `product_name`, `brands`, `code`
- `energy_kcal_100g`, `energy_kcal_total`, `energy_kj_100g`, `energy_kj_total`
- `fat_100g`, `fat_total`, `fat_percent`, `saturated_fat_total`
- `carbohydrates_100g`, `carbohydrates_total`, `carbohydrates_percent`
- `sugars_100g`, `sugars_total`, `fiber_100g`, `fiber_total`
- `protein_100g`, `protein_total`, `protein_percent`
- `salt_100g`, `salt_total`, `nutritionScore`, `categorie`, `tip_inregistrare`, `masa_id`

`MasaResponse` (proprietăți JSON exacte):
- `id`, `categorie_masa_id`, `data`, `ora`, `notite`
- `grams_total`, `energy_kcal_total`, `energy_kj_total`, `fat_total`, `fat_percent`, `saturated_fat_total`, `carbohydrates_total`, `carbohydrates_percent`, `sugars_total`, `fiber_total`, `protein_total`, `protein_percent`, `salt_total`, `alimente` (listă de `InregistrareAlimentResponse`)

`MesePeZiResponse` (exemplu complet)
```json
{
  "data": "2026-05-02",
  "mese": [],
  "obiectiv_calorii": 2200.0,
  "obiectiv_proteine": 150.0,
  "obiectiv_carbohidrati": 250.0,
  "obiectiv_grasimi": 70.0,
  "energy_kcal_total": 1800.0,
  "energy_kj_total": 7536.0,
  "fat_total": 55.0,
  "fat_percent": 27.5,
  "saturated_fat_total": 18.0,
  "carbohidrati_total": 210.0,
  "carbohydrates_percent": 46.0,
  "sugars_total": 60.0,
  "fiber_total": 20.0,
  "proteine_total": 95.0,
  "protein_percent": 21.0,
  "salt_total": 4.5,
  "calorii_nete": 400.0
}
```

Observație: JSON-ul conține atât `carbohidrati_total` (română) cât și `carbohydrates_percent` (engleză) — folosește exact cheile din DTO.

### Categorii mese DTO

`CategorieMasaDto` (proprietăți JSON exacte)
```json
{
  "id": 1,
  "nume": "Mic Dejun",
  "numar_ordine": 1,
  "is_active": true
}
```

`UpdateCategoriiMeseRequest` (bulk update)
```json
{
  "categorii_mese": [
    { "id": 1, "nume": "Mic Dejun", "numar_ordine": 1, "is_active": true }
  ]
}
```

### Masuratori DTO (proprietăți JSON)
`MasuratoareGreutateDto`:
```json
{ "greutate_kg": 75.0, "data_masuratoare": "2026-04-01" }
```

`MasuratoareInaltimeDto`:
```json
{ "inaltime_cm": 180.0, "data_masuratoare": "2026-04-01" }
```

`MasuratoareGrasimeCorporalaDto`:
```json
{ "grasime_corporala_procent": 18.5, "data_masuratoare": "2026-04-01" }
```

`ObiectivDto`:
```json
{
  "data": "2026-04-01",
  "obiectiv_calorii_zi": 2200,
  "obiectiv_proteine_zi": 140,
  "obiectiv_carbohidrati_zi": 250,
  "obiectiv_grasimi_zi": 70
}
```

`ObiectivResponse` (folosit la GET `/obiective` - include și valori calculate/procentuale):
```json
{
  "data": "2026-04-01",
  "obiectiv_calorii_zi": 2200.0,
  "obiectiv_proteine_zi": 140.0,
  "obiectiv_proteine_procent": 25.0,
  "obiectiv_carbohidrati_zi": 250.0,
  "obiectiv_carbohidrati_procent": 45.0,
  "obiectiv_grasimi_zi": 70.0,
  "obiectiv_grasimi_procent": 30.0,
  "proteine_kg_corp": 1.8,
  "carbohidrati_kg_corp": 2.8,
  "grasimi_kg_corp": 0.9,
  "calorii_nete_zi": 350.0,
  "modificare_kg_saptamana": -0.5
}
```

## Utilizator DTO

`DatePersonaleResponse` (exemplu)
```json
{
  "username": "john",
  "email": "john@mail.com",
  "role": "USER",
  "data_nasterii": "2000-01-01",
  "varsta": 26,
  "gen": "M",
  "nivelActivitate": "ACTIV",
  "bmi": 23.1,
  "bmr": 1750.0,
  "tdee": 2600.0
}
```

`ModificaDatePersonaleRequest` (PATCH fields optional):
```json
{
  "username": "john_new",
  "data_nasterii": "2000-01-01",
  "gen": "M",
  "nivel_activitate": "ACTIV"
}
```


## 6) Status codes uzuale

- `200 OK` succes
- `400 Bad Request` validare/format invalid
- `401 Unauthorized` token lipsa/invalid
- `403 Forbidden` acces interzis
- `404 Not Found` resursa inexistenta
- `409 Conflict` conflict unicitate/constrangeri
- `500 Internal Server Error` eroare neasteptata

## 7) Rulare local (Windows)

```powershell
mvnw.cmd spring-boot:run
```

## 8) Observatii pentru frontend Flutter

- Respecta exact cheile JSON cu underscore (ex: `data_nasterii`, `greutate_kg`, `categorii_mese`).
- `LocalDate` se trimite in format `yyyy-MM-dd`.
- Pentru endpointurile cu `ApiResponse<T>`, datele utile sunt in `data`.
- Pentru validari, trateaza `ApiErrorResponse.fieldErrors` la afisarea mesajelor in UI.
