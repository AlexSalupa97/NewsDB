create table categorii
(
id_categorie number(3) constraint pk_id_categorie PRIMARY KEY,
nume_categorie varchar2(20) constraint uq_nume_categorie UNIQUE
);


create table autori
(
id_autor number(3) constraint pk_id_autor PRIMARY KEY,
nume_autor varchar2(30) constraint uq_nume_autor UNIQUE,
email_autor varchar2(50) constraint ck_email_autor CHECK(email_autor like '%@%')
);

create table stiri
(
id_stire number(3) constraint pk_id_stire PRIMARY KEY,
titlu varchar2(100) constraint nn_titlu NOT NULL,
data_stire date default sysdate,
nr_afisari number(5) constraint nn_nr_afisari NOT NULL,
id_categorie number(3) constraint fk_id_categorie references categorii(id_categorie),
id_autor number(3) constraint fk_id_autor references autori(id_autor)
);



create table comentarii
(
id_comentariu number(3) constraint pk_id_comentariu PRIMARY KEY,
data_comentariu date default sysdate,
continut_comentariu varchar2(100)
);

create table rand_comentariu
(
id_rand_comentariu number(3) constraint pk_id_rand_comentariu PRIMARY KEY,
id_comentariu number(3) constraint fk_id_comentariu references comentarii(id_comentariu),
id_stire number(3) constraint fk_id_stire references stiri(id_stire)
);

create table useri
(
id_user number(3) constraint pk_id_user PRIMARY KEY,
nume_user varchar2(30) constraint uq_nume_user UNIQUE,
parola_user varchar2(30) constraint ck_parola_user CHECK (length(parola_user)>=5),
data_creare date default sysdate,
email_user varchar2(50) constraint ck_email_user CHECK(email_user like '%@%')
);

create table rand_useri
(
id_rand_user number(3) constraint pk_id_rand_user PRIMARY KEY,
id_comentariu number(3) constraint fk_id_comentariu_user references comentarii(id_comentariu),
id_user number(3) constraint fk_id_user references useri(id_user)
);


create table cuvinte_cheie
(
nume_cuvant_cheie varchar2(30) constraint pk_nume_cuvant_cheie PRIMARY KEY
);

create table rand_cuvinte_cheie
(
id_rand_cuvant_cheie number(3) constraint pk_rand_cuvant_cheie PRIMARY KEY,
nume_cuvant_cheie varchar2(30) constraint fk_nume_cuvant_cheie references cuvinte_cheie(nume_cuvant_cheie),
id_stire number(3) constraint fk_id_stire_cuvinte_cheie references stiri(id_stire)
);

drop table rand_comentariu purge;
drop table rand_useri purge;

describe useri;

alter table comentarii
add  id_user number(3);

alter table comentarii
add constraint fk_comentarii FOREIGN KEY (id_user) references useri(id_user);


alter table comentarii
add id_stire number(3);

alter table comentarii
add constraint fk_stiri_comentarii FOREIGN KEY (id_stire) references stiri(id_stire);


alter table comentarii
add stare_comentariu number(1) check (stare_comentariu in (0,1));

alter table stiri
add stare_stiri number(1) check (stare_stiri in (0,1));

alter table useri
add stare_useri number(1) check (stare_useri in (0,1));

alter table useri
add ultima_activitate date;

alter table stiri
add continut_stire varchar2(4000);

create table poze
(
id_poza number(3) constraint pk_id_poza PRIMARY KEY,
link_poza blob constraint nn_link_poza NOT NULL,
id_stire number(3) constraint fk_stire_poze references stiri(id_stire)
);

alter table poze
add pozitie_poza varchar2(10) constraint ck_pozitie_poza CHECK (pozitie_poza in('Header','Footer','Centre','Center'));

describe useri;

insert into useri values(1,'user1','user1',sysdate,'user1@user1.com',1,sysdate);
insert into useri values(2,'user2','user2',sysdate,'user2@user2.com',1,sysdate);
insert into useri values(3,'user3','user3',sysdate,'user3@user3.com',0,sysdate);

describe categorii;

insert into categorii values(1,'sport');
insert into categorii values(2,'politica');
insert into categorii values(3,'diverse');

describe CUVINTE_CHEIE;

insert into cuvinte_cheie values('cuvant_cheie1');
insert into cuvinte_cheie values('cuvant_cheie2');

describe autori;

insert into autori values(1,'autor1','autor1@autor1.com');
insert into autori values(2,'autor2','autor2@autor2.com');
insert into autori values(3,'autor3','autor3@autor3.com');

describe stiri;

insert into stiri values(1,'stire1',sysdate,0,1,1,1,'continut stire1');
insert into stiri values(2,'stire2',sysdate,0,1,2,1,'continut stire2');
insert into stiri values(3,'stire3',sysdate,0,2,2,1,'continut stire3');

describe comentarii;

insert into comentarii values(1,sysdate,'continut comentariu1 user1 stire1',1,1,1);
insert into comentarii values(2,sysdate,'continut comentariu2 user1 stire2',1,2,1);
insert into comentarii values(3,sysdate,'continut comentariu3 user2 stire3',2,3,1);

describe RAND_CUVINTE_CHEIE;

insert into rand_cuvinte_cheie values(1,'cuvant_cheie1',1);
insert into rand_cuvinte_cheie values(2,'cuvant_cheie1',2);
insert into rand_cuvinte_cheie values(3,'cuvant_cheie2',2);

describe poze;

insert into poze values(1,UTL_RAW.CAST_TO_RAW('http://storage0.dms.mpinteractiv.ro/media/401/581/7966/16926316/3/halep-ao.jpg?width=815;'),1,'Header');

select * from poze;

--pentru inserarea imaginii: https://www.thatjeffsmith.com/archive/2012/01/sql-developer-quick-tip-blobs-and-images/

alter table poze
drop constraint fk_stire_poze;

alter table poze
drop column id_stire;

describe poze;


create table poze_stiri
(
id_poza_stire number(3) constraint pk_id_poza_stire PRIMArY KEY,
id_poza number(3) constraint fk_id_poze references poze(id_poza),
id_stire number(3) constraint fk_id_stiri references stiri(id_stire)
);

insert into poze_stiri values(1,1,1);

describe stiri;

select link_poza, titlu from poze 
inner join poze_stiri using(id_poza)
inner join stiri using(id_stire);

describe useri;

alter table useri
add tip_user number(1);

alter table useri
add constraint ck_tip_user CHECK (tip_user in (0,1,2));

select * from useri;

update useri
set tip_user=2;

commit;

alter table poze
add stare_poza number(1);

alter table poze
add constraint ck_stare_poza CHECK(stare_poza in(0,1));

alter table autori
add adresa_autor varchar2(50);

update autori
set adresa_autor='adresa';

commit;

alter table autori
add constraint nn_adresa_autor NOT NULL;

alter table categorii
add stare_categorii number(1);

alter table categorii
add constraint ck_stare_categorii CHECK(stare_categorii in(0,1));

alter table autori
add stare_autor number(1);

alter table autori
add constraint ck_stare_autor CHECK(stare_autor in(0,1));

alter table autori
add prenume_autor varchar2(30);

update autori
set prenume_autor='prenume';

alter table autori
add constraint nn_adresa_autor check(adresa_autor is NOT NULL);

insert into poze values(2,UTL_RAW.CAST_TO_RAW('http://storage0.dms.mpinteractiv.ro/media/401/581/7966/16926316/3/halep-ao.jpg?width=815;'),'Header',1);
insert into poze values(3,UTL_RAW.CAST_TO_RAW('http://storage0.dms.mpinteractiv.ro/media/401/581/7966/16926316/3/halep-ao.jpg?width=815;'),'Header',1);

insert into poze_stiri values(6,2,1);
insert into poze_stiri values(2,1,3);
insert into poze_stiri values(7,2,3);
insert into poze_stiri values(5,1,3);
insert into poze_stiri values(3,2,2);
insert into poze_stiri values(4,3,1);


commit;


describe comentarii;

alter table comentarii
drop constraint FK_COMENTARII;

alter table comentarii
add id_guest varchar2(10);

update comentarii
set id_user=1;

alter table comentarii
add constraint ck_id_user_guest CHECK((id_user is not null and id_guest is null) or (id_user is null and id_guest is not null));

create table guests
(
  id_guest varchar2(10) PRIMARY KEY
);

alter table comentarii
add constraint fk_useri_comentarii FOREIGN KEY (id_user)  references useri(id_user);

alter table comentarii
add constraint fk_useri_guest FOREIGN KEY (id_guest)  references guests(id_guest);

insert into guests values('2f3414131');
insert into guests values('43hjf324d');

select * from COMENTARII;

insert into comentarii values(4,sysdate, 'continut comentariu4 guest stire1',null,1,1,'2f3414131');

alter table autori
add parola_autor varchar2(30);

update autori
set parola_autor='parola';

alter table autori
add constraint ck_parola_autori check (length(parola_autor)>5);





