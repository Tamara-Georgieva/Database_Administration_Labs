Релационата база е дефинирана преку следните релации:

Muzicar(id, ime, prezime, datum_ragjanje)
Muzicar_instrument(id_muzicar*, instrument)
Bend(id, ime, godina_osnovanje)
Bend_zanr(id_bend*, zanr)
Nastan(id, cena, kapacitet)
Koncert(id*, datum, vreme)
Festival(id*, ime)
Festival_odrzuvanje(id*, datum_od, datum_do)
Muzicar_bend(id_muzicar*, id_bend*, datum_napustanje)
Festival_bend(id_festival*, datum_od*, id_bend*)
Koncert_muzicar_bend(id_koncert*, id_muzicar*, id_bend*)

Да се напише DML израз со кој ќе се вратат имињата и презимињата на гитаристите (музичарите кои свират на инструментот гитара) кои настапиле на концерт заедно со бенд откако го напуштиле. Датумот на настап на музичарот заедно со бендот е датумот на самиот концерт. Резултатите треба да се подредени според името во растечки редослед.
SELECT DISTINCT ime, prezime
FROM Muzicar m
JOIN Muzicar_bend mb ON m.id = mb.id_muzicar
JOIN Koncert_muzicar_bend kmb ON mb.id_bend = kmb.id_bend
JOIN Koncert k ON k.id = kmb.id_koncert
JOIN Muzicar_instrument mii ON m.id = mii.id_muzicar
WHERE k.datum > mb.datum_napustanje
AND instrument = 'gitara'
ORDER BY ime ASC;

Да се напише DML израз со кој за секој фестивал ќе се врати името, цената на билетите, капацитетот на посетители, бројот на одржувања и вкупниот број на различни бендови кои настапиле.
SELECT f.ime, n.cena, n.kapacitet, COUNT(DISTINCT fd.datum_od) AS broj_odrzuvanja, COUNT(DISTINCT fb.id_bend) AS broj_bendovi
FROM Festival f
JOIN Nastan n ON f.id = n.id
JOIN Festival_odrzuvanje fd ON fd.id = f.id
JOIN Festival_bend fb ON fb.id_festival = f.id
GROUP BY f.ime, n.cena, n.kapacitet
ORDER BY n.kapacitet DESC;

Да се напише DML израз со кој ќе се вратат сите парови на бендови (пар од имињата на бендовите) кои се основани во иста година.
SELECT B1.ime AS B1, B2.ime AS B2
FROM Bend B1
JOIN Bend B2 ON B1.id <> B2.id
AND B1.godina_osnovanje = B2.godina_osnovanje
AND B1.ime > B2.ime;
