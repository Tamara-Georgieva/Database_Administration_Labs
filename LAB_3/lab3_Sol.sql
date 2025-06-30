CREATE TABLE Vraboten (
    ID INTEGER PRIMARY KEY,
    ime VARCHAR(50),
    prezime VARCHAR(50),
    datum_r DATE,
    datum_v DATE,
    CONSTRAINT date_check CHECK (datum_r < datum_v), (6)
    obrazovanie VARCHAR(15),
    CONSTRAINT obrazovanie_check CHECK (obrazovanie IN ('PhD', 'MSc', 'High School', 'BSc'))  (3)
    plata INTEGER(15)
);



CREATE TABLE Shalterski_rabotnik (
    ID INTEGER PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES Vraboten(ID) ON DELETE SET NULL
);


CREATE TABLE Klient (
    MBR_k INTEGER PRIMARY KEY,
    ime VARCHAR(50),
    prezime VARCHAR(50),
    adresa VARCHAR(100) DEFAULT 'Ne e navedena', 
    datum DATE
);


CREATE TABLE Smetka (
    MBR_k INTEGER,    
    FOREIGN KEY (MBR_k) REFERENCES Klient(MBR_k)
    broj INTEGER PRIMARY KEY,
    valuta VARCHAR(10),
    saldo INTEGER (20),
);
CREATE TABLE Transakcija_shalter ( 
ID INTEGER PRIMARY KEY, 
ID_v INTEGER, 
FOREIGN KEY (ID_v) REFERENCES Vraboten(ID) ON DELETE SET NULL, (1)
MBR_k INTEGER, 
FOREIGN KEY (MBR_k) REFERENCES Klient(MBR_k),
MBR_k_s INTEGER, 
FOREIGN KEY (MBR_k_s) REFERENCES Smetka(MBR_k),
broj INTEGER,
FOREIGN KEY (broj) REFERENCES Smetka(broj),
datum DATE,
CONSTRAINT date_check CHECK (datum NOT BETWEEN '2020-12-30' AND '2021-01-14')
suma INTEGER, (4)
tip VARCHAR(10),
CONSTRAINT tip_check CHECK (tip IN ('uplata', 'isplata')) (5)
);


CREATE TABLE Bankomat (
    ID INTEGER PRIMARY KEY,
    lokacija VARCHAR(50) UNIQUE, (8)
    datum DATE,
    zaliha INTEGER(20),
    CONSTRAINT zaliha_check CHECK (zaliha >= 0) (5)
);


CREATE TABLE Transakcija_bankomat (
ID INTEGER PRIMARY KEY, 
MBR_k_s INTEGER, 
FOREIGN KEY (MBR_k_s) REFERENCES Smetka(MBR_k_s),
broj INTEGER,
FOREIGN KEY (broj) REFERENCES Smetka(broj),
ID_b INTEGER DEFAULT -1, (2)
FOREIGN KEY (ID_b) REFERENCES Bankomat(ID) ON DELETE SET DEFAULT, (2)
datum DATE,
suma INTEGER
