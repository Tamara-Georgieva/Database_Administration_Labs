Релационата база е дефинирана преку следните релации:

Korisnik(k_ime, ime, prezime, tip, pretplata, datum_reg, tel_broj, email)
Premium_korisnik(k_ime*, datum, procent_popust)
Profil(k_ime*, ime, datum)
Video_zapis(naslov, jazik, vremetraenje, datum_d, datum_p)
Video_zapis_zanr(naslov*, zanr)
Lista_zelbi(naslov*, k_ime*, ime*)
Preporaka(ID, k_ime_od*, k_ime_na*, naslov*, datum, komentar, ocena)

Да се напише DML израз со кој ќе се вратат имињата и презимињата на сите премиум корисници кои препорачале видео запис со времетраење подолго од 2 часа и за кој оставиле оцена поголема или еднаква на 4, подредени според датумот на регистрација во растечки редослед (времетраењето се чува во минути).
SELECT DISTINCT k.ime, k.prezime
FROM Premium_korisnik pk
JOIN Korisnik k ON pk.k_ime = k.k_ime
JOIN Preporaka pr ON pr.k_ime_od = k.k_ime
JOIN Video_zapis vz ON vz.naslov = pr.naslov
WHERE vz.vremetraenje > 120
AND pr.ocena >= 4
ORDER BY k.datum_reg ASC;


Да се напише DML израз со кој ќе се вратат корисничките имиња и насловите на препорачаните видео записи за сите премиум корисници кои добиле препорака со оцена поголема од 3 за барем еден видео запис во 2021 година кој е дел од листата на желби во барем еден од нивните профили, подредени според корисничкото име.
SELECT DISTINCT pk.k_ime AS k_ime, p.naslov
FROM Premium_korisnik pk
JOIN Preporaka p ON p.k_ime_na = pk.k_ime
JOIN Video_zapis vz ON vz.naslov = p.naslov
JOIN Lista_zelbi lz ON lz.naslov = p.naslov AND lz.k_ime = pk.k_ime
WHERE p.ocena > 3
AND p.datum BETWEEN '2021-01-01' AND '2021-12-31'
ORDER BY pk.k_ime ASC;


Да се напише DML израз со кој ќе се вратат корисничкото име и бројот на видео записи кои му биле препорачани на корисникот кој дал најголем број на препораки.
WITH Counter AS (
    SELECT k_ime_od, COUNT(*) AS CNT
    FROM Preporaka
    GROUP BY k_ime_od
),
MAXX AS (
    SELECT MAX(CNT) AS MX
    FROM Counter
)
SELECT P.k_ime_na AS k_ime, COUNT(*) AS dobieni_preporaki
FROM Counter C
JOIN MAXX M ON C.CNT = M.MX
JOIN Preporaka P ON P.k_ime_na = C.k_ime_od
GROUP BY P.k_ime_na;


Да се напише DML израз со кој за секој корисник ќе се врати видео записот кој го препорачал најголем број пати.
WITH RecommendationCount AS (
    SELECT k_ime_od, naslov, COUNT(*) AS CNT
    FROM Preporaka
    GROUP BY k_ime_od, naslov
),
MaxRecommendationCount AS (
    SELECT k_ime_od, MAX(CNT) AS max_count
    FROM RecommendationCount
    GROUP BY k_ime_od
)
SELECT K.k_ime, RC.naslov, RC.CNT AS broj
FROM Korisnik K
JOIN RecommendationCount RC ON K.k_ime = RC.k_ime_od
JOIN MaxRecommendationCount MRC ON RC.k_ime_od = MRC.k_ime_od
WHERE RC.CNT = MRC.max_count
ORDER BY K.k_ime, RC.naslov;


Да се напише DML израз со кој за секој профил ќе се врати името на профилот и просечната оцена на видео записите во листата на желби асоцирана со тој профил. (Просечната оцена на секој видео запис се пресметува од сите оцени за тој видео запис).
WITH AvgMovieRating AS (
    SELECT naslov, AVG(ocena) AS ao
    FROM Preporaka
    GROUP BY naslov
)
SELECT p.ime, AVG(AMR.ao) AS po_profil
FROM Profil p
JOIN Lista_zelbi lz ON p.k_ime = lz.k_ime AND p.ime = lz.ime
JOIN AvgMovieRating AMR ON lz.naslov = AMR.naslov
GROUP BY p.ime
ORDER BY p.ime;
