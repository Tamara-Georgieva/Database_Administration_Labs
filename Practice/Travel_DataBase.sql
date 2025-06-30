Релационата база е дефинирана преку следните релации:

Korisnik(kor_ime, ime, prezime, pol, data_rag, data_reg)
Korisnik_email(kor_ime*, email)
Mesto(id, ime)
Poseta(kor_ime*, id_mesto*, datum)
Grad(id_mesto*, drzava)
Objekt(id_mesto*, adresa, geo_shirina, geo_dolzina, id_grad*)
Sosedi(grad1*, grad2*, rastojanie)

Да се напише DML израз со кој ќе се вратат името и презимето на корисниците кои во ист ден посетиле објекти кои се наоѓаат во соседни градови.
SELECT DISTINCT k.ime, k.prezime
FROM Poseta p1
JOIN Poseta p2 ON p1.kor_ime = p2.kor_ime AND p1.datum = p2.datum AND p1.id_mesto <> p2.id_mesto
JOIN Objekt o1 ON p1.id_mesto = o1.id_mesto
JOIN Objekt o2 ON p2.id_mesto = o2.id_mesto
JOIN Sosedi s ON (s.grad1 = o1.id_grad AND s.grad2 = o2.id_grad) OR (s.grad2 = o1.id_grad AND s.grad1 = o2.id_grad)
JOIN Korisnik k ON k.kor_ime = p1.kor_ime;


Да се напише DML израз со кој ќе се вратат името и презимето на корисниците кои посетиле објекти кои се наоѓаат во соседни градови чие растојание е помало од 300 km.
SELECT DISTINCT k.ime, k.prezime
FROM Poseta p1
JOIN Poseta p2 ON p2.kor_ime = p1.kor_ime AND p1.id_mesto <> p2.id_mesto
JOIN Objekt o1 ON p1.id_mesto = o1.id_mesto
JOIN Objekt o2 ON p2.id_mesto = o2.id_mesto
JOIN Sosedi s ON (o1.id_grad = s.grad1 AND o2.id_grad = s.grad2) OR (o1.id_grad = s.grad2 AND o2.id_grad = s.grad1)
JOIN Korisnik k ON p1.kor_ime = k.kor_ime
WHERE s.rastojanie < 300;


Да се напише DML израз со кој ќе се врати името на градот во кој се наоѓа објектот што бил посетен најголем број пати.
WITH posbrpat AS (
    SELECT p.id_mesto, COUNT(*) AS Kaunt
    FROM Poseta p
    JOIN Objekt o ON p.id_mesto = o.id_mesto
    GROUP BY p.id_mesto
)
SELECT m.ime
FROM posbrpat ppbr
JOIN Objekt o ON ppbr.id_mesto = o.id_mesto
JOIN Mesto m ON m.id = o.id_grad
WHERE ppbr.Kaunt = (SELECT MAX(Kaunt) FROM posbrpat);


Да се напише DML израз со кој ќе се вратат имињата на објектите кои се наоѓаат во градот што бил посетен најголем број пати. За посети на градови се сметаат посетите на места што претставуваат градови. Во ова не се вклучени посетите на објекти во тие градови.
WITH MVC AS (
    SELECT g.id_mesto, COUNT(*) as Most_Visit_city
    FROM Grad g
    JOIN Poseta p ON p.id_mesto = g.id_mesto
    GROUP BY g.id_mesto
),
Maximum AS (
    SELECT MAX(Most_Visit_city) AS maxi
    FROM MVC
)
SELECT M.ime
FROM MVC mvcc
JOIN Maximum maxim ON mvcc.Most_Visit_city = maxim.maxi
JOIN Objekt O ON mvcc.id_mesto = O.id_grad
JOIN Mesto M ON M.id = O.id_mesto
ORDER BY 1 DESC;
