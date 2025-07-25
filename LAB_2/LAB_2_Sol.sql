σName='Sci-Fi'(Genres)
πGenre_ID(σName='Sci-Fi'(Genres))

1. πTitle(σName='Sci-Fi'(Genres)⨝Movies)


πMovie_ID(σRuntime>150∨Budget>200000000(Movies))
πFirstname,Lastname(πMovie_ID(σRuntime>150∨Budget>200000000(Movies))⨝Persons)

2. πFirstname,Lastname(πMovie_ID(σRuntime>150∨Budget>200000000(Movies))⨝PersonsMovies⨝Persons)


3. πTitle(σFirstname='James'∧Lastname='Cameron'(σRuntime<120∨Runtime>180(Movies)⨝PersonsMovies⨝Persons))
πTitle(σFirstname='James'∧Lastname='Cameron'(σRuntime<120 or Runtime>180(Movies)⨝(PersonsMovies)⨝Persons))

4.πTitle(σName='Action'∨SequelOf!=null(Genres⨝Movies))
R1 = πMovie_ID, Title(σName='Action'(Movies ⨝ Genres))
R2= πSequelOf(σSequelOf≠null(Movies))
R3 = πMovie_ID, Title(σSequelOf≠null(Movies))
R1 ∪ R3

5. σName='Action'(Genres)⨝Movies⨝σSequelOf>1(Movies)
или
σName='Action'(Genres)⨝Movies⨝σSequelOf≠null(Movies)
R1 = πMovie_ID, Title(σName='Action'(Movies ⨝ Genres))
R2= πSequelOf(σSequelOf≠null(Movies))
R3 = πMovie_ID, Title(σSequelOf≠null(Movies))
R1 ∩ R3

6. πTitle(σSequelOf=null(Movies))
R1 = πSequelOf(Movies)
R2 = πMovie_ID(Movies)
R2-R1

7) Најди ги сите личности кои учествувале на филмови направени од Universal Studios од жанрот Action.

πFirstname,Lastname(σName='Action'∧Distribution='20th Century Fox'(Genres⨝Movies⨝Persons))
R1 = πMovie_ID (σName='Action'(Movies ⋈ Genres))
R2 = πMovie_ID (σDistribution='Universal Studios'(Movies))
R3 = R1 ∩ R2
R4 = R3 ⨝ PersonsMovies
R5 = R4 ⨝ πPerson_ID,Firstname,Lastname(Persons)
πPersons.Firstname,Persons.Lastname(R5)

8) Најди ги сите личности кои не учествувале на филмови направени од 20th Century Fox.
R1 = πMovie_ID (σDistribution='20th Century Fox'(Movies))
R2 = R1 ⨝ PersonsMovies
R3 = πPerson_ID(PersonsMovies)
R4 = R3 - πPerson_ID(R2)
R4 ⨝ πPerson_ID, Firstname, Lastname(Persons)
