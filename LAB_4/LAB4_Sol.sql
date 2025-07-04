SELECT v.ime, v.prezime
FROM Vraboten v
JOIN Transakcija_shalter ts ON v.ID=ts.ID_v
JOIN Smetka sm ON ts.MBR_k=sm.MBR_k
WHERE suma>1000 and valuta='EUR'
ORDER BY v.ime



SELECT k.ime, k.prezime
FROM Klient k
JOIN Transakcija_bankomat tb ON k.MBR_k=tb.MBR_k_s
JOIN Smetka sm ON k.MBR_k=sm.MBR_k
WHERE suma>400 and valuta='USD'
ORDER BY k.ime


SELECT s.broj
FROM Smetka s
JOIN Transakcija_bankomat tb ON s.broj=tb.broj
JOIN Transakcija_shalter ts ON s.broj=ts.broj
WHERE s.valuta='MKD' 
AND tb.datum >= '2021-01-01' AND tb.datum <= '2021-12-31'
AND ts.datum >= '2021-01-01' AND ts.datum <= '2021-12-31'
GROUP BY s.broj
HAVING count(tb.ID)>=1 and count(ts.ID)>=1




////////////////////////////////////////////////////////////////////
SELECT s.broj
FROM Smetka s
JOIN Transakcija_bankomat tb ON s.broj = tb.broj
JOIN Transakcija_shalter ts ON s.broj = ts.broj
WHERE s.valuta = 'MKD'
  AND tb.datum >= '2021-01-01' AND tb.datum <= '2021-12-31'
  AND ts.datum >= '2021-01-01' AND ts.datum <= '2021-12-31'
GROUP BY s.broj
HAVING 
  SUM(CASE WHEN tb.ID IS NOT NULL THEN 1 ELSE 0 END) > 1 OR
  SUM(CASE WHEN ts.ID IS NOT NULL THEN 1 ELSE 0 END) > 1;
////////////////////////////////////////////////////////////////////



4.
SELECT k.ime
FROM Klient k
JOIN Smetka s ON k.MBR_k=s.MBR_k
JOIN Transakcija_bankomat tb ON s.broj=tb.broj
LEFT JOIN Transakcija_shalter ts ON s.broj=ts.broj
WHERE s.valuta='EUR' 
GROUP BY k.ime
HAVING count(tb.ID)>=1 and count(ts.ID)=0
ORDER BY k.ime



5.
WITH BrTransakcii AS (
    SELECT v.ID, ts.datum, COUNT(ts.ID) AS br_tr
    FROM Vraboten v
    JOIN Transakcija_shalter ts ON v.ID = ts.ID_v
    GROUP BY v.ID
),
MaxTransakcii AS (
    SELECT b.ID, MAX(br_tr) AS max_br_tr
    FROM BrTransakcii b
    GROUP BY b.ID
)
SELECT b.ID, b.datum, b.br_tr
FROM BrTransakcii b
JOIN MaxTransakcii m ON b.ID = m.ID 
ORDER BY b.ID;


///////////////////////////////////////////////
WITH BrTransakcii AS (
    SELECT v.ID, ts.datum, COUNT(ts.ID) AS broj_transakcii
    FROM Vraboten v
    JOIN Transakcija_shalter ts ON v.ID = ts.ID_v
    GROUP BY v.ID
),
MaxTransakcii AS (
    SELECT b.ID, MAX(broj_transakcii) AS max_br_tr
    FROM BrTransakcii b
    GROUP BY b.ID
)
SELECT b.ID as vraboten, b.datum, b.broj_transakcii
FROM BrTransakcii b
JOIN MaxTransakcii m ON b.ID = m.ID 
ORDER BY b.ID;
///////////////////////////////////////////////////////


6.
WITH TransakciiShalter AS (
    SELECT s.broj, AVG(ts.suma) AS prosek_shalter
    FROM Smetka s
    LEFT JOIN Transakcija_shalter ts ON s.broj = ts.broj
        AND ts.datum >= '2021-01-01' 
        AND ts.datum <= '2021-12-31'
    WHERE (s.valuta = 'EUR' OR s.valuta = 'USD')
    GROUP BY s.broj
),
TransakciiBankomat AS (
    SELECT s.broj, AVG(tb.suma) AS prosek_bankomat
    FROM Smetka s
    LEFT JOIN Transakcija_bankomat tb ON s.broj = tb.broj
        AND tb.datum >= '2021-01-01' 
        AND tb.datum <= '2021-12-31'
    WHERE (s.valuta = 'EUR' OR s.valuta = 'USD')
    GROUP BY s.broj
)
SELECT s.broj, ts.prosek_shalter, tb.prosek_bankomat
FROM Smetka s
LEFT JOIN TransakciiShalter ts ON s.broj = ts.broj
LEFT JOIN TransakciiBankomat tb ON s.broj = tb.broj
WHERE (s.valuta = 'EUR' OR s.valuta = 'USD')
ORDER BY s.broj;
ta = 'USD')
ORDER BY s.broj;


1.SELECT v.ime, v.prezime
FROM Vraboten v
JOIN Transakcija_shalter ts ON v.ID=ts.ID_v
JOIN Smetka sm ON ts.MBR_k=sm.MBR_k and ts.broj=sm.broj
JOIN Shalterski_rabotnik sr on sr.ID=ts.ID_v
WHERE suma>1000 and valuta='EUR' and tip = 'isplata'
ORDER BY v.ime
2.
SELECT k.ime, k.prezime
FROM Klient k
JOIN Transakcija_bankomat tb ON k.MBR_k=tb.MBR_k_s
JOIN Smetka sm ON k.MBR_k=sm.MBR_k
WHERE suma>400 and valuta='USD'
ORDER BY k.ime
3.
SELECT s.MBR_k, s.broj, s.valuta, s.saldo
FROM Smetka s
JOIN Transakcija_bankomat tb ON s.broj=tb.broj and s.MBR_k=tb.MBR_k_s
JOIN Transakcija_shalter ts ON s.broj=ts.broj and s.MBR_k=ts.MBR_k_s
WHERE s.valuta='MKD' and tip='isplata'
AND tb.datum >= '2021-01-01' AND tb.datum <= '2021-12-31'
AND ts.datum >= '2021-01-01' AND ts.datum <= '2021-12-31'
GROUP BY s.broj
HAVING count(tb.ID)>=1 and count(ts.ID)>=1
4.
SELECT k.MBR_k, k.ime, k.prezime, k.adresa, k.datum
FROM Klient k
JOIN Smetka s ON k.MBR_k=s.MBR_k
JOIN Transakcija_bankomat tb ON s.broj=tb.broj
LEFT JOIN Transakcija_shalter ts ON s.broj=ts.broj
WHERE s.valuta='EUR' 
GROUP BY k.ime
HAVING count(tb.ID)>=1 and count(ts.ID)=0
ORDER BY k.ime

5.
WITH BrTransakcii AS (
    SELECT v.ID, ts.datum, COUNT(ts.ID) AS broj_transakcii
    FROM Vraboten v
    JOIN Transakcija_shalter ts ON v.ID = ts.ID_v
    GROUP BY v.ID, ts.datum
),
MaxTransakcii AS (
    SELECT b.ID, MAX(broj_transakcii) AS max_br_tr
    FROM BrTransakcii b
    GROUP BY b.ID
)
SELECT b.ID as vraboten, b.datum, b.broj_transakcii
FROM BrTransakcii b
JOIN MaxTransakcii m ON b.ID = m.ID 
ORDER BY b.ID;

6.WITH TransakciiShalter AS (
    SELECT s.broj, ts.tip, s.MBR_k, AVG(ts.suma) AS prosek_shalter
    FROM Smetka s
    JOIN Transakcija_shalter ts ON s.broj = ts.broj and s.MBR_k=ts.MBR_k
        AND ts.datum >= '2021-01-01' 
        AND ts.datum <= '2021-12-31'
    WHERE ts.tip='isplata'
    and s.valuta = 'EUR' OR s.valuta = 'USD'
    GROUP BY s.broj
),
TransakciiBankomat AS (
    SELECT s.broj, s.MBR_k, AVG(tb.suma) AS prosek_bankomat
    FROM Smetka s
    JOIN Transakcija_bankomat tb ON s.broj = tb.broj and s.MBR_k=tb.MBR_k_s
        AND tb.datum >= '2021-01-01' 
        AND tb.datum <= '2021-12-31'
    WHERE s.valuta = 'EUR' OR s.valuta = 'USD'
    GROUP BY s.broj
)
SELECT s.MBR_k, s.broj, tb.prosek_bankomat as prosechna_isplata_bankomat, ts.prosek_shalter as prosechna_isplata_shalter
FROM Smetka s
JOIN TransakciiShalter ts ON s.broj = ts.broj 
JOIN TransakciiBankomat tb ON s.broj = tb.broj
WHERE ts.tip='isplata'
And s.valuta = 'EUR' OR s.valuta = 'USD'
ORDER BY s.broj;

7.
WITH TransakciiShalter AS (
    SELECT s.broj, s.MBR_k, AVG(ts.suma) AS prosek_shalter
    FROM Smetka s
    JOIN Transakcija_shalter ts ON s.broj = ts.broj and s.MBR_k=ts.MBR_k
    GROUP BY s.broj, s.MBR_k
),
TransMin AS
(
    SELECT MIN(prosek_shalter) as min_trans
    FROM TransakciiShalter tss
)
SELECT distinct k.MBR_k ,ime, prezime
FROM TransakciiShalter tss
JOIN TransMin m ON tss.prosek_shalter = m.min_trans
join Klient k on tss.MBR_k=k.MBR_k;



























