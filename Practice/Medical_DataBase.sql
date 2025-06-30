Релационата база е дефинирана преку следните релации:

Lice(id, mbr, ime, prezime, data_r, vozrast, pol)
Med_lice(id*, staz)
Test(id*, shifra, tip, datum, rezultat, laboratorija)
Vakcina(shifra, ime, proizvoditel)
Vakcinacija(id_lice*, id_med_lice*, shifra_vakcina*)
Vakcinacija_datum(id_lice*, id_med_lice*, shifra_vakcina*, datum)

Да се напише DML израз со кој ќе се вратат матичните броеви на лицата (сортирани во растечки редослед) кои биле позитивни и потоа примиле барем една доза вакцина.
SELECT DISTINCT l.id
FROM Lice l
JOIN Test t ON l.id = t.id
JOIN Vakcinacija_datum vd ON l.id = vd.id_lice
WHERE t.rezultat = 'pozitiven'
AND t.datum < vd.datum
GROUP BY l.id
HAVING COUNT(vd.datum) >= 1
ORDER BY l.id ASC;
