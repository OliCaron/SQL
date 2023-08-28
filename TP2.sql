drop table TP2_ALIMENT cascade constraints;
drop table TP2_CAMION cascade constraints;
drop table TP2_CUEILLEUR cascade constraints;
drop table TP2_CUEILLEUR_TYPE_ACTIVITE cascade constraints;
drop table TP2_CUEILLEUR_DISPONIBILITE cascade constraints;
drop table TP2_EMPLOYE cascade constraints;
drop table TP2_EMPLOYE_TYPE cascade constraints;
drop table TP2_ENTREPOT cascade constraints;
drop table TP2_LIVRAISON cascade constraints;
drop table TP2_PRODUCTEUR cascade constraints;
drop table TP2_PRODUCTEUR_ALIMENT cascade constraints;
drop table TP2_PROPRIETAIRE cascade constraints;
drop table TP2_ROUTE cascade constraints;
drop table TP2_RESSOURCE_AIDE cascade constraints;
drop table TP2_SORTIE cascade constraints;
drop table TP2_SORTIE_CUEILLEUR cascade constraints;
drop table TP2_SORTIE_RECOLTE cascade constraints;
drop table TP2_TYPE_ACTIVITE cascade constraints;
drop table SORTIE_ARCHIVE;
drop table SORTIE_CUEILLEUR_ARCHIVE;
drop table SORTIE_RECOLTE_ARCHIVE;

drop sequence TP2_SEQUENCE_CUEILLEUR;
drop sequence TP2_SEQUENCE_EMPLOYE;
drop sequence TP2_SEQUENCE_SORTIE;

drop view VUE_CUEILLEUR_HIERARCHIE;

create sequence TP2_SEQUENCE_CUEILLEUR
start with 5
increment by 5;

create sequence TP2_SEQUENCE_EMPLOYE
start with 5000
increment by 10;

create sequence TP2_SEQUENCE_SORTIE
start with 1000
increment by 1;

--2c)
create or replace function FCT_GENERER_MOT_DE_PASSE (P_LONGUEUR in number)
return varchar2
is
    V_CARACTERES varchar2(70) := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!?&$/|#';
    V_MOT_DE_PASSE varchar2(16);
    V_LONGUEUR_MDP number(2) := P_LONGUEUR;
    V_I number(2) := 0;
    E_LONGUEUR_INVALIDE exception;
begin
    
    if (V_LONGUEUR_MDP < 8) then
        raise E_LONGUEUR_INVALIDE;
    else
    
        if (V_LONGUEUR_MDP > 16) then
            V_LONGUEUR_MDP := 16;
        end if;
    
        V_MOT_DE_PASSE := '';

        for V_I in 1..V_LONGUEUR_MDP
            loop
                V_MOT_DE_PASSE := V_MOT_DE_PASSE || substr(V_CARACTERES, ceil(dbms_random.value(1, length(V_CARACTERES))), 1);
            end loop;
        
        return V_MOT_DE_PASSE;    
    end if;
    
exception
    when E_LONGUEUR_INVALIDE then
        return 'Erreur : La longueur du mot de passe doit être entre 8 et 16 caractères.';
end FCT_GENERER_MOT_DE_PASSE;
/

create table TP2_TYPE_ACTIVITE(
NO_TYPE_ACTIVITE number(4) not null,
DESC_TYPE_ACT varchar2(40) not null,
constraint PK_TYPE_ACT primary key (NO_TYPE_ACTIVITE),
constraint CT_NO_TYPE_ACTIVITE check(NO_TYPE_ACTIVITE >= 0));

create table TP2_RESSOURCE_AIDE(
CODE_RESSOURCE_AIDE char(4) not null,
NOM_RES varchar2(40) not null,
NO_TEL_RES char(13) not null,
ADRESSE_RES varchar2(40) not null,
VILLE_RES varchar2(40) not null,
CODE_POSTAL_RES char(7) not null,
COURRIEL_RES varchar(40) not null,
constraint PK_RESSOURCE_AIDE primary key(CODE_RESSOURCE_AIDE));

create table TP2_ALIMENT(
NOM_ALIMENT varchar2(40) not null,
TYPE_ALI varchar2(6) not null,
constraint PK_ALIMENT primary key (NOM_ALIMENT),
constraint CT_TYPE_ALI_OPTION_UN check(TYPE_ALI = 'Fruit' OR TYPE_ALI = 'Legume' ));

create table TP2_CAMION(
NO_CAMION number(4) not null,
EST_REFRIGERE_CAM number(1) not null,
constraint PK_CAMION primary key (NO_CAMION),
constraint CT_EST_REFRIGERE check(EST_REFRIGERE_CAM in (0,1)),
constraint CT_NO_CAMION check(NO_CAMION >= 0));

create table TP2_CUEILLEUR(
NO_CUEILLEUR number(4) not null,
UTILISATEUR_CUE varchar2(30) not null,
MOT_DE_PASSE_CUE varchar2(16) not null,
NOM_CUE varchar2(30) not null,
PRENOM_CUE varchar2(30) not null,
ADRESSE_CUE varchar2(30) not null,
CODE_POSTAL_CUE char(7) not null,
VILLE_CUE varchar2(30) not null,
TEL_CUE char(13) not null,
COURRIEL_CUE varchar2(40) not null,
DATE_NAISSANCE_CUE date not null,
BOOL_A_UN_COMPTE_FB number(1) not null,
ENFANT_EST_INSCRIT_CSP number(1) not null,
constraint PK_CUEILLEUR primary key (NO_CUEILLEUR),
constraint AK_CUEILLEUR_UN unique(COURRIEL_CUE),
constraint AK_CUEILLEUR_DEUX unique(UTILISATEUR_CUE),
constraint AK_CUEILLEUR_TROIS unique(PRENOM_CUE, NOM_CUE, ADRESSE_CUE, CODE_POSTAL_CUE),
constraint CT_BOOL_COMPTE_FB check(BOOL_A_UN_COMPTE_FB in (0,1)),
constraint CT_ENFANT_INSCRIT check(ENFANT_EST_INSCRIT_CSP in (0,1)));

alter table TP2_CUEILLEUR
add NO_CUEILLEUR_RESPONSABLE number(4);

with TOUS_RESPONSABLE(NO_CUEILLEUR, NO_CUEILLEUR_RESPONSABLE) as
(select NO_CUEILLEUR, NO_CUEILLEUR_RESPONSABLE from TP2_CUEILLEUR
    union all
 select ENFANT.NO_CUEILLEUR, ENFANT.NO_CUEILLEUR_RESPONSABLE
 from TOUS_RESPONSABLE PERE, TP2_CUEILLEUR ENFANT
 where PERE.NO_CUEILLEUR = ENFANT.NO_CUEILLEUR)
 
 select * from TOUS_RESPONSABLE;

create table TP2_CUEILLEUR_TYPE_ACTIVITE(
NO_CUEILLEUR number(4) not null,
NO_TYPE_ACTIVITE number(4) not null,
constraint PK_CUEILLEUR_TYPE_ACTIVITE primary key (NO_CUEILLEUR, NO_TYPE_ACTIVITE),
constraint FK_CUEILLEUR_TYPE_ACTIVITE_UN foreign key(NO_CUEILLEUR) references TP2_CUEILLEUR(NO_CUEILLEUR),
constraint FK_CUEILLEUR_TYPE_ACTIVITE_DEUX foreign key(NO_TYPE_ACTIVITE) references TP2_TYPE_ACTIVITE(NO_TYPE_ACTIVITE));

create table TP2_CUEILLEUR_DISPONIBILITE(
NO_CUEILLEUR number(4) not null,
DATE_HEURE_DEBUT_DIS date not null,
DATE_HEURE_FIN_DIS date not null,
EST_DISPONIBLE number(1) not null,
constraint PK_CUEILLEUR_DISPO primary key (NO_CUEILLEUR, DATE_HEURE_DEBUT_DIS),
constraint FK_CUEILLEUR_DISPO foreign key(NO_CUEILLEUR) references TP2_CUEILLEUR(NO_CUEILLEUR),
constraint CT_EST_DISPONIBLE check(EST_DISPONIBLE in (0,1)));

create table TP2_EMPLOYE_TYPE(
CODE_TYPE_EMPLOYE char(4) not null,
DESC_TYPE_EMP varchar2(40) not null,
constraint PK_EMPLOYE_TYPE primary key(CODE_TYPE_EMPLOYE));

create table TP2_EMPLOYE(
NO_EMPLOYE number(4) not null,
UTILISATEUR_EMP varchar2(30) not null,
MOT_DE_PASSE_EMP varchar2(16) not null,
NOM_EMP varchar2(40) not null,
PRENOM_EMP varchar2(40) not null,
ADRESSE_EMP varchar2(40) not null,
CODE_POSTAL_EMP char(7) not null,
TEL_EMP char(13) not null,
COURRIEL_EMP varchar2(40) not null,
NAS_EMP char(9) not null,
CODE_TYPE_EMPLOYE char(4) not null,
constraint PK_EMPLOYE primary key(NO_EMPLOYE),
constraint AK_EMPLOYE unique(NAS_EMP),
constraint FK_EMPLOYE foreign key(CODE_TYPE_EMPLOYE) references TP2_EMPLOYE_TYPE(CODE_TYPE_EMPLOYE));

create table TP2_ENTREPOT(
NOM_ENTREPOT varchar2(40) not null,
ADRESSE_ENT varchar(40) not null,
VILLE_ENT varchar2(40) not null,
CODE_POSTAL_ENT char(7) not null,
constraint PK_ENTREPOT primary key(NOM_ENTREPOT));

create table TP2_ROUTE(
NO_ROUTE number(4) not null,
DESCRIPTION_ROU varchar2(40) not null,
JOUR_LIVRAISON_ROU varchar(20) not null,
constraint PK_ROUTE primary key (NO_ROUTE),
constraint CT_NO_ROUTE check(NO_ROUTE >= 0));

create table TP2_LIVRAISON(
NO_CAMION number(4) not null,
NO_ROUTE number(4) not null,
NO_EMPLOYE number(4) not null,
NOM_ENTREPOT varchar2(40) not null,
CODE_RESSOURCE_AIDE char(4) not null,
DATE_LIV date not null,
constraint PK_LIVRAISON primary key(NO_CAMION, NO_ROUTE, NO_EMPLOYE, NOM_ENTREPOT, CODE_RESSOURCE_AIDE, DATE_LIV),
constraint FK_LIVRAISON_CAM foreign key(NO_CAMION) references TP2_CAMION(NO_CAMION),
constraint FK_LIVRAISON_ROU foreign key(NO_ROUTE) references TP2_ROUTE(NO_ROUTE),
constraint FK_LIVRAISON_EMP foreign key(NO_EMPLOYE) references TP2_EMPLOYE(NO_EMPLOYE),
constraint FK_LIVRAISON_ENT foreign key(NOM_ENTREPOT) references TP2_ENTREPOT(NOM_ENTREPOT),
constraint FK_LIVRAISON_AIDE foreign key(CODE_RESSOURCE_AIDE) references TP2_RESSOURCE_AIDE(CODE_RESSOURCE_AIDE));

create table TP2_PRODUCTEUR(
CODE_PRODUCTEUR number(4) not null,
UTILISATEUR_PROD varchar2(40) not null,
MOT_DE_PASSE_PROD varchar2(40) not null,
NOM_ENTREPRISE_PROD varchar2(40) not null,
NOM_PROD varchar2(40) not null,
PRENOM_PROD varchar2(40) not null,
ADRESSE_PROD varchar2(40) not null,
CODE_POSTAL_PROD char(7) not null,
VILLE_PROD varchar2(40) not null,
TEL_PROD char(13) not null,
COURRIEL_PROD varchar2(40) not null,
NOM_FICHIER_PHOTO_PROD varchar2(200) not null,
BOOL_A_DES_FRUITS_PROD number(1) not null,
BOOL_A_DES_LEGUMES_PROD number(1) not null,
BOOL_A_DES_PLANTES_AROM_PROD number(1) not null,
MOMENT_ADEQUAT_PROD varchar2(40) not null,
constraint PK_PRODUCTEUR primary key(CODE_PRODUCTEUR),
constraint AK_PRODUCTEUR unique(NOM_ENTREPRISE_PROD));

create table TP2_PRODUCTEUR_ALIMENT(
CODE_PRODUCTEUR number(4) not null,
NOM_ALIMENT varchar2(40) not null,
constraint PK_PRODUCTEUR_ALIMENT primary key (CODE_PRODUCTEUR, NOM_ALIMENT),
constraint FK_PRODUCTEUR_ALIMENT_UN foreign key(CODE_PRODUCTEUR) references TP2_PRODUCTEUR(CODE_PRODUCTEUR),
constraint FK_PRODUCTEUR_ALIMENT_DEUX foreign key(NOM_ALIMENT) references TP2_ALIMENT(NOM_ALIMENT));

create table TP2_PROPRIETAIRE(
NO_PROPRIETAIRE number(4) not null,
UTILISATEUR_PROP varchar2(40) not null,
MOT_DE_PASSE_PROP varchar2(40) not null,
NOM_PROP varchar2(40) not null,
PRENOM_PROP varchar2(40) not null,
ADRESSE_PROP varchar2(40) not null,
CODE_POSTAL_PROP char(7) not null,
TEL_PROP char(13) not null,
COURRIEL_PROP varchar2(40) not null,
constraint PK_PROPRIETAIRE primary key(NO_PROPRIETAIRE));

create table TP2_SORTIE (
NO_SORTIE number(4) not null,
NO_EMPLOYE number(4) not null,
CODE_PRODUCTEUR number(4) not null,
NO_PROPRIETAIRE number(4) not null,
DATE_SOR date not null,
DUREE_SOR varchar2(40) not null,
PART_PROD_SOR number(4) not null,
PART_SAP_SOR  number(4) not null,
NOMBRE_ARBRE_SOR number(4) not null,
EMPLACEMENT_PROP_SOR varchar2(40) not null,
ACCES_ARBRE_SOR varchar2(40) not null,
NOMBRE_CUEILLEUR_SOR number(4) not null,
BOOL_AVANT_MIDI_SEMAINE_SOR number(1) not null,
BOOL_APRES_MIDI_SEMAINE_SOR number(1) not null,
BOOL_AVANT_MIDI_FIN_SEMAINE_SOR number(1) not null,
BOOL_APRES_MIDI_FIN_SEMAINE_SOR number(1) not null,
COMMENTAIRE_SOR varchar2(1000) not null,
HAUTEUR_MINIMAL_SOR DECIMAL(5, 2) not null, 
LATITUDE_SOR DECIMAL(6, 4) not null, 
LONGITUDE_SOR DECIMAL(6, 4) not null, 
constraint PK_SORTIE primary key(NO_SORTIE),
constraint FK_SORTIE_EMPLOYE foreign key (NO_EMPLOYE) references TP2_EMPLOYE (NO_EMPLOYE),
constraint FK_SORTIE_PRODUCTEUR  foreign key  (CODE_PRODUCTEUR) references TP2_PRODUCTEUR (CODE_PRODUCTEUR),
constraint FK_SORTIE_PROPRIETAIRE foreign key (NO_PROPRIETAIRE) references TP2_PROPRIETAIRE (NO_PROPRIETAIRE),
constraint AK_SORTIE unique(NO_EMPLOYE,CODE_PRODUCTEUR,NO_PROPRIETAIRE,DATE_SOR));

create table TP2_SORTIE_CUEILLEUR (
NO_SORTIE number(4) not null,
NO_CUEILLEUR  number(4) not null,
PART_SORTIE_CUE varchar2(40) not null,
constraint PK_SORTIE_CUEILLEUR primary key (NO_SORTIE,NO_CUEILLEUR),
constraint FK_SORTIE_CUEILLEUR_UN foreign key(NO_SORTIE) references TP2_SORTIE(NO_SORTIE),
constraint FK_SORTIE_CUEILLEUR_DEUX foreign key(NO_CUEILLEUR) references TP2_CUEILLEUR(NO_CUEILLEUR));

create table TP2_SORTIE_RECOLTE (
NO_SORTIE number(4) not null,
NOM_ALIMENT varchar2(40) not null,
constraint PK_SORTIE_RECOLTE primary key (NO_SORTIE,NOM_ALIMENT),
constraint FK_SORTIE_RECOLTE_UN foreign key(NO_SORTIE) references TP2_SORTIE(NO_SORTIE),
constraint FK_SORTIE_RECOLTE_DEUX foreign key(NOM_ALIMENT) references TP2_ALIMENT(NOM_ALIMENT));

insert into TP2_ALIMENT (NOM_ALIMENT,TYPE_ALI) values ('Pommes', 'Fruit');
insert into TP2_ALIMENT (NOM_ALIMENT,TYPE_ALI) values ('Fraises', 'Fruit');
insert into TP2_ALIMENT (NOM_ALIMENT,TYPE_ALI) values ('Patates', 'Legume');
insert into TP2_ALIMENT (NOM_ALIMENT,TYPE_ALI) values ('Concombres', 'Legume');

insert into TP2_CAMION (NO_CAMION, EST_REFRIGERE_CAM) values (1234, 1);
insert into TP2_CAMION (NO_CAMION, EST_REFRIGERE_CAM) values (1235, 0);
insert into TP2_CAMION (NO_CAMION, EST_REFRIGERE_CAM) values (1236, 0);
insert into TP2_CAMION (NO_CAMION, EST_REFRIGERE_CAM) values (3432, 1);

insert into TP2_TYPE_ACTIVITE(NO_TYPE_ACTIVITE, DESC_TYPE_ACT) values (1847, 'Cueillette pomme');
insert into TP2_TYPE_ACTIVITE(NO_TYPE_ACTIVITE, DESC_TYPE_ACT) values (1333, 'Cueillette fraise');
insert into TP2_TYPE_ACTIVITE(NO_TYPE_ACTIVITE, DESC_TYPE_ACT) values (1791, 'Cueillette patate');
insert into TP2_TYPE_ACTIVITE(NO_TYPE_ACTIVITE, DESC_TYPE_ACT) values (4, 'Cueillette concombre');

insert into TP2_RESSOURCE_AIDE(CODE_RESSOURCE_AIDE, NOM_RES, NO_TEL_RES, ADRESSE_RES, VILLE_RES, CODE_POSTAL_RES, COURRIEL_RES) values ('CRA1','Carrefour F.M. Portneuf', '(418)337-3704', '759 rue Saint-Cyrille', 'Saint-Raymond', 'G3L 1X1', 'info@carrefourfmportneuf.com');
insert into TP2_RESSOURCE_AIDE(CODE_RESSOURCE_AIDE, NOM_RES, NO_TEL_RES, ADRESSE_RES, VILLE_RES, CODE_POSTAL_RES, COURRIEL_RES) values ('CRA2','CERF Volant de Portneuf', '(418)873-4557', '189 rue Dupont local 171', 'Pont-Rouge', 'G3H 1N4', 'info@cerfvolantdeportneuf.org');
insert into TP2_RESSOURCE_AIDE(CODE_RESSOURCE_AIDE, NOM_RES, NO_TEL_RES, ADRESSE_RES, VILLE_RES, CODE_POSTAL_RES, COURRIEL_RES) values ('CRA3','Saint-Roy de Portneuf', '(418)834-4247', '189 rue Arnaud', 'Pont-Rouge', 'G3H 1N4', 'info@cerfvolantdeportneuf.ca');

insert into TP2_CUEILLEUR (NO_CUEILLEUR, UTILISATEUR_CUE, MOT_DE_PASSE_CUE, NOM_CUE, PRENOM_CUE,
ADRESSE_CUE, CODE_POSTAL_CUE, VILLE_CUE, TEL_CUE, COURRIEL_CUE, DATE_NAISSANCE_CUE, BOOL_A_UN_COMPTE_FB, ENFANT_EST_INSCRIT_CSP) values (TP2_SEQUENCE_CUEILLEUR.nextval, 'ABarbeau', FCT_GENERER_MOT_DE_PASSE(10), 'Barbeau', 'Alcide', '2020 rue du Finfin', 'H2M 1V9', 'Montreal', '(514)382-3404', 'alcidebarbeau@gmail.com', to_date('1962-01-15', 'RRRR-MM-DD'), 0, 0); -- récursivité
insert into TP2_CUEILLEUR (NO_CUEILLEUR, UTILISATEUR_CUE, MOT_DE_PASSE_CUE, NOM_CUE, PRENOM_CUE,
ADRESSE_CUE, CODE_POSTAL_CUE, VILLE_CUE, TEL_CUE, COURRIEL_CUE, DATE_NAISSANCE_CUE, BOOL_A_UN_COMPTE_FB, ENFANT_EST_INSCRIT_CSP) values (TP2_SEQUENCE_CUEILLEUR.nextval, 'LPFafardAllard', FCT_GENERER_MOT_DE_PASSE(14), 'Fafard-Allard', 'Louis-Paul', '415 avenue CédéCassé', 'H7P 2W8', 'Laval', '(514)407-8472', 'lpfafardallard@gmail.com', to_date('1975-06-23', 'RRRR-MM-DD'), 1, 1); --  récursivité

insert into TP2_CUEILLEUR_TYPE_ACTIVITE(NO_CUEILLEUR, NO_TYPE_ACTIVITE) values ((select NO_CUEILLEUR from TP2_CUEILLEUR where NOM_CUE = 'Barbeau'), (select NO_TYPE_ACTIVITE from TP2_TYPE_ACTIVITE where DESC_TYPE_ACT = 'Cueillette pomme') );
insert into TP2_CUEILLEUR_TYPE_ACTIVITE(NO_CUEILLEUR, NO_TYPE_ACTIVITE) values ((select NO_CUEILLEUR from TP2_CUEILLEUR where NOM_CUE = 'Fafard-Allard'), (select NO_TYPE_ACTIVITE from TP2_TYPE_ACTIVITE where DESC_TYPE_ACT = 'Cueillette patate') );

insert into TP2_CUEILLEUR_DISPONIBILITE(NO_CUEILLEUR, DATE_HEURE_DEBUT_DIS, DATE_HEURE_FIN_DIS, EST_DISPONIBLE) values ((select NO_CUEILLEUR from TP2_CUEILLEUR where NOM_CUE = 'Barbeau'), to_date('2023/05/15 8:30', 'YYYY/MM/DD HH:MI'), to_date('2023/05/15 12:30', 'YYYY/MM/DD HH:MI'), 1);
insert into TP2_CUEILLEUR_DISPONIBILITE(NO_CUEILLEUR, DATE_HEURE_DEBUT_DIS, DATE_HEURE_FIN_DIS, EST_DISPONIBLE) values ((select NO_CUEILLEUR from TP2_CUEILLEUR where NOM_CUE = 'Fafard-Allard'), to_date('2023/05/15 9:30', 'YYYY/MM/DD HH:MI'), to_date('2023/05/15 11:30', 'YYYY/MM/DD HH:MI'), 1);

insert into TP2_EMPLOYE_TYPE(CODE_TYPE_EMPLOYE, DESC_TYPE_EMP) values ('CTE1', 'Livreur');
insert into TP2_EMPLOYE_TYPE(CODE_TYPE_EMPLOYE, DESC_TYPE_EMP) values ('CTE2', 'Gérant');
insert into TP2_EMPLOYE_TYPE(CODE_TYPE_EMPLOYE, DESC_TYPE_EMP) values ('CTE3', 'Responsabl;e de sortie');

insert into TP2_EMPLOYE(NO_EMPLOYE, UTILISATEUR_EMP, MOT_DE_PASSE_EMP, NOM_EMP,  PRENOM_EMP, ADRESSE_EMP, CODE_POSTAL_EMP, TEL_EMP, COURRIEL_EMP, NAS_EMP, CODE_TYPE_EMPLOYE)
values (TP2_SEQUENCE_EMPLOYE.nextval, 'JDespins', FCT_GENERER_MOT_DE_PASSE(13), 'Despins', 'Julie', '1212 rue Clairette', 'H7P 1W6', '(450)662-6662', 'jdespins23@gmail.ca', '185492167', 'CTE1');
insert into TP2_EMPLOYE(NO_EMPLOYE, UTILISATEUR_EMP, MOT_DE_PASSE_EMP, NOM_EMP,  PRENOM_EMP, ADRESSE_EMP, CODE_POSTAL_EMP, TEL_EMP, COURRIEL_EMP, NAS_EMP, CODE_TYPE_EMPLOYE)
values (TP2_SEQUENCE_EMPLOYE.nextval, 'JZawinul', FCT_GENERER_MOT_DE_PASSE(12), 'Zawinul', 'Joe', '450 rue Gilles', 'H7P 5F8', '(450)226-4726', 'joe@weatherreport.com', '846715063', 'CTE3');
insert into TP2_EMPLOYE(NO_EMPLOYE, UTILISATEUR_EMP, MOT_DE_PASSE_EMP, NOM_EMP,  PRENOM_EMP, ADRESSE_EMP, CODE_POSTAL_EMP, TEL_EMP, COURRIEL_EMP, NAS_EMP, CODE_TYPE_EMPLOYE)
values (TP2_SEQUENCE_EMPLOYE.nextval, 'WShorter', FCT_GENERER_MOT_DE_PASSE(11), 'Shorter', 'Wayne', '452 rue Gilles', 'H7P 5F8', '(450)714-5294', 'wayne@weatherreport.com', '456123789', 'CTE1');
insert into TP2_EMPLOYE(NO_EMPLOYE, UTILISATEUR_EMP, MOT_DE_PASSE_EMP, NOM_EMP,  PRENOM_EMP, ADRESSE_EMP, CODE_POSTAL_EMP, TEL_EMP, COURRIEL_EMP, NAS_EMP, CODE_TYPE_EMPLOYE)
values (TP2_SEQUENCE_EMPLOYE.nextval, 'JJean', FCT_GENERER_MOT_DE_PASSE(12), 'Jean', 'Julie', '324 rue Marois', 'P7P 5F2', '(514)714-5294', 'julie.jean@gmail.com', '425123789', 'CTE2');


insert into TP2_ENTREPOT(NOM_ENTREPOT, ADRESSE_ENT, VILLE_ENT, CODE_POSTAL_ENT) values('Entrepôt Gilles', '10175 rue Meunier', 'Montréal', 'H3L 2Z2');
insert into TP2_ENTREPOT(NOM_ENTREPOT, ADRESSE_ENT, VILLE_ENT, CODE_POSTAL_ENT) values('Entrepôt Nantel', '620 Rue Joseph-Garant', 'Lévis', 'G6W 1P8');
insert into TP2_ENTREPOT(NOM_ENTREPOT, ADRESSE_ENT, VILLE_ENT, CODE_POSTAL_ENT) values('Entrepôt WestmountSquare', '1 Carr Westmount', 'Montréal', 'H3Z 2P9');

insert into TP2_ROUTE (NO_ROUTE, DESCRIPTION_ROU, JOUR_LIVRAISON_ROU)
values (21, 'Livraison de jour avec camion frigo', 'mardi');
insert into TP2_ROUTE (NO_ROUTE, DESCRIPTION_ROU, JOUR_LIVRAISON_ROU)
values (4, 'Livraison de jour avec camion normal', 'mercredi');

insert into TP2_LIVRAISON(NO_CAMION, NO_ROUTE, NO_EMPLOYE, NOM_ENTREPOT, CODE_RESSOURCE_AIDE, DATE_LIV) 
values(1234, 21, (select NO_EMPLOYE from TP2_EMPLOYE where NOM_EMP = 'Despins'), (select NOM_ENTREPOT from TP2_ENTREPOT where ADRESSE_ENT = '10175 rue Meunier'), 'CRA1', to_date('2023/03/17', 'YYYY/MM/DD'));
insert into TP2_LIVRAISON(NO_CAMION, NO_ROUTE, NO_EMPLOYE, NOM_ENTREPOT, CODE_RESSOURCE_AIDE, DATE_LIV) 
values(1234, 21, (select NO_EMPLOYE from TP2_EMPLOYE where NOM_EMP = 'Despins'), (select NOM_ENTREPOT from TP2_ENTREPOT where ADRESSE_ENT = '620 Rue Joseph-Garant'), 'CRA2', to_date('2023/06/05', 'YYYY/MM/DD'));

insert into TP2_PRODUCTEUR (CODE_PRODUCTEUR, UTILISATEUR_PROD, MOT_DE_PASSE_PROD, NOM_ENTREPRISE_PROD, NOM_PROD, PRENOM_PROD, ADRESSE_PROD, CODE_POSTAL_PROD, VILLE_PROD, TEL_PROD, COURRIEL_PROD, NOM_FICHIER_PHOTO_PROD, BOOL_A_DES_FRUITS_PROD, BOOL_A_DES_LEGUMES_PROD, BOOL_A_DES_PLANTES_AROM_PROD, MOMENT_ADEQUAT_PROD)
values (0531, 'Ferme Caron', FCT_GENERER_MOT_DE_PASSE(20), 'Les merveilles', 'Caron', 'Louis', '123 rue St-Lac', 'H7P 0K3', 'Montréal', '450-096-7890', 'Louis.Caron@gmail.com', 'Les_merveilles_photo.jpg', 1, 0, 1, 'PM');
insert into TP2_PRODUCTEUR (CODE_PRODUCTEUR, UTILISATEUR_PROD, MOT_DE_PASSE_PROD, NOM_ENTREPRISE_PROD, NOM_PROD, PRENOM_PROD, ADRESSE_PROD, CODE_POSTAL_PROD, VILLE_PROD, TEL_PROD, COURRIEL_PROD, NOM_FICHIER_PHOTO_PROD, BOOL_A_DES_FRUITS_PROD, BOOL_A_DES_LEGUMES_PROD, BOOL_A_DES_PLANTES_AROM_PROD, MOMENT_ADEQUAT_PROD)
values (1030, 'Ferme Lee', FCT_GENERER_MOT_DE_PASSE(11), 'Les fruits divins', 'Lee', 'Marc', '90 rue Paul', 'H70 0L3', 'Laval', '450-456-7490', 'Marc.Lee@gmail.com', 'Les_fruits_divins_photo.jpg', 1, 1, 1, 'PM');
insert into TP2_PRODUCTEUR (CODE_PRODUCTEUR, UTILISATEUR_PROD, MOT_DE_PASSE_PROD, NOM_ENTREPRISE_PROD, NOM_PROD, PRENOM_PROD, ADRESSE_PROD, CODE_POSTAL_PROD, VILLE_PROD, TEL_PROD, COURRIEL_PROD, NOM_FICHIER_PHOTO_PROD, BOOL_A_DES_FRUITS_PROD, BOOL_A_DES_LEGUMES_PROD, BOOL_A_DES_PLANTES_AROM_PROD, MOMENT_ADEQUAT_PROD)
values (4872, 'FermeTremblay', FCT_GENERER_MOT_DE_PASSE(16), 'Ferme Tremblay', 'Tremblay', 'Jean', '162 Rue Principale', 'G0T 1P0', 'Portneuf', '(418)238-1207', 'info@fermetremblay.com', 'Ferme_Tremblay_photo.jpg', 1, 1, 0, 'AM');

insert into TP2_PRODUCTEUR_ALIMENT(CODE_PRODUCTEUR, NOM_ALIMENT)values((select CODE_PRODUCTEUR from TP2_PRODUCTEUR where CODE_PRODUCTEUR = 0531) ,(select NOM_ALIMENT from TP2_ALIMENT where NOM_ALIMENT = 'Pommes' ));
insert into TP2_PRODUCTEUR_ALIMENT(CODE_PRODUCTEUR, NOM_ALIMENT)values((select CODE_PRODUCTEUR from TP2_PRODUCTEUR where CODE_PRODUCTEUR = 1030) ,(select NOM_ALIMENT from TP2_ALIMENT where NOM_ALIMENT = 'Fraises' ));

insert into  TP2_PROPRIETAIRE (NO_PROPRIETAIRE, UTILISATEUR_PROP, MOT_DE_PASSE_PROP, NOM_PROP, PRENOM_PROP, ADRESSE_PROP, CODE_POSTAL_PROP, TEL_PROP, COURRIEL_PROP)
values (1, 'KellyMoris', FCT_GENERER_MOT_DE_PASSE(8), 'Moris', 'Kelly', '123 Rue Lemieux', 'H3X 0B9', '450-323-1243', 'KellyMoris@hotmail.ca');
insert into  TP2_PROPRIETAIRE (NO_PROPRIETAIRE, UTILISATEUR_PROP, MOT_DE_PASSE_PROP, NOM_PROP, PRENOM_PROP, ADRESSE_PROP, CODE_POSTAL_PROP, TEL_PROP, COURRIEL_PROP)
values (2, 'NancyDrew', FCT_GENERER_MOT_DE_PASSE(9), 'Drew', 'Nancy', '30 Rue Riverdale', 'O3X 9W3', '450-342-0021', 'NancyDrew@hotmail.com');
insert into  TP2_PROPRIETAIRE (NO_PROPRIETAIRE, UTILISATEUR_PROP, MOT_DE_PASSE_PROP, NOM_PROP, PRENOM_PROP, ADRESSE_PROP, CODE_POSTAL_PROP, TEL_PROP, COURRIEL_PROP)
values (3, 'LucGiroux', FCT_GENERER_MOT_DE_PASSE(9), 'Giroux', 'Luc', '424 Rue Dorvale', '2B5 9W3', '514-342-0021', 'LucGiroux@hotmail.com');


insert into TP2_SORTIE (NO_SORTIE, NO_EMPLOYE, CODE_PRODUCTEUR, NO_PROPRIETAIRE, DATE_SOR, DUREE_SOR, PART_PROD_SOR, PART_SAP_SOR, NOMBRE_ARBRE_SOR, EMPLACEMENT_PROP_SOR, ACCES_ARBRE_SOR, NOMBRE_CUEILLEUR_SOR, BOOL_AVANT_MIDI_SEMAINE_SOR, BOOL_APRES_MIDI_SEMAINE_SOR, BOOL_AVANT_MIDI_FIN_SEMAINE_SOR, BOOL_APRES_MIDI_FIN_SEMAINE_SOR, COMMENTAIRE_SOR, HAUTEUR_MINIMAL_SOR, LATITUDE_SOR, LONGITUDE_SOR)
values (TP2_SEQUENCE_SORTIE.nextval,(select NO_EMPLOYE from TP2_EMPLOYE where UTILISATEUR_EMP = 'JDespins'), 0531, 1, to_date ('2000/03/16 8:30', 'YYYY/MM/DD HH:MI'), '4 heures', '40', '50', 30, 'cour avant', 'Accès par le trottoir', '10', 1, 0, 1, 0, 'Il faut une échelle', 120, 46.7817, 71.2747);
insert into TP2_SORTIE (NO_SORTIE, NO_EMPLOYE, CODE_PRODUCTEUR, NO_PROPRIETAIRE, DATE_SOR, DUREE_SOR, PART_PROD_SOR, PART_SAP_SOR, NOMBRE_ARBRE_SOR, EMPLACEMENT_PROP_SOR, ACCES_ARBRE_SOR, NOMBRE_CUEILLEUR_SOR, BOOL_AVANT_MIDI_SEMAINE_SOR, BOOL_APRES_MIDI_SEMAINE_SOR, BOOL_AVANT_MIDI_FIN_SEMAINE_SOR, BOOL_APRES_MIDI_FIN_SEMAINE_SOR, COMMENTAIRE_SOR, HAUTEUR_MINIMAL_SOR, LATITUDE_SOR, LONGITUDE_SOR)
values (TP2_SEQUENCE_SORTIE.nextval,(select NO_EMPLOYE from TP2_EMPLOYE where UTILISATEUR_EMP = 'JZawinul'), 1030, 2, to_date ('2023/06/10 9:30', 'YYYY/MM/DD HH:MI'), '2 heures', '60', '50', 50, 'cour arrière', 'Accès par la porte principale', '20', 1, 1, 1, 1, 'Pas besoin de échelle', 20, 40.3141, 61.1314);

insert into TP2_SORTIE_CUEILLEUR (NO_SORTIE, NO_CUEILLEUR, PART_SORTIE_CUE)
values ((select NO_SORTIE from TP2_SORTIE where CODE_PRODUCTEUR = 0531), (select NO_CUEILLEUR from TP2_CUEILLEUR where UTILISATEUR_CUE = 'ABarbeau'), '40');
insert into TP2_SORTIE_CUEILLEUR (NO_SORTIE, NO_CUEILLEUR, PART_SORTIE_CUE)
values ((select NO_SORTIE from TP2_SORTIE where CODE_PRODUCTEUR = 1030), (select NO_CUEILLEUR from TP2_CUEILLEUR where UTILISATEUR_CUE = 'LPFafardAllard'), '60');

insert into TP2_SORTIE_RECOLTE (NO_SORTIE, NOM_ALIMENT)
values ((select NO_SORTIE from TP2_SORTIE where CODE_PRODUCTEUR = 0531),(select NOM_ALIMENT from TP2_ALIMENT where NOM_ALIMENT = 'Pommes'));
insert into TP2_SORTIE_RECOLTE (NO_SORTIE, NOM_ALIMENT)
values ((select NO_SORTIE from TP2_SORTIE where CODE_PRODUCTEUR = 1030),(select NOM_ALIMENT from TP2_ALIMENT where NOM_ALIMENT = 'Fraises'));

-- 1) c)

insert into TP2_PROPRIETAIRE (NO_PROPRIETAIRE, UTILISATEUR_PROP, MOT_DE_PASSE_PROP, NOM_PROP, PRENOM_PROP, ADRESSE_PROP, CODE_POSTAL_PROP, TEL_PROP, COURRIEL_PROP)
values ((select CODE_PRODUCTEUR from TP2_PRODUCTEUR where NOM_ENTREPRISE_PROD = 'Ferme Tremblay'), (select UTILISATEUR_PROD from TP2_PRODUCTEUR where NOM_ENTREPRISE_PROD = 'Ferme Tremblay'),
(select MOT_DE_PASSE_PROD from TP2_PRODUCTEUR where NOM_ENTREPRISE_PROD = 'Ferme Tremblay'), (select NOM_PROD from TP2_PRODUCTEUR where NOM_ENTREPRISE_PROD = 'Ferme Tremblay'),
(select PRENOM_PROD from TP2_PRODUCTEUR where NOM_ENTREPRISE_PROD = 'Ferme Tremblay'), (select ADRESSE_PROD from TP2_PRODUCTEUR where NOM_ENTREPRISE_PROD = 'Ferme Tremblay'),
(select CODE_POSTAL_PROD from TP2_PRODUCTEUR where NOM_ENTREPRISE_PROD = 'Ferme Tremblay'), (select TEL_PROD from TP2_PRODUCTEUR where NOM_ENTREPRISE_PROD = 'Ferme Tremblay'),
(select COURRIEL_PROD from TP2_PRODUCTEUR where NOM_ENTREPRISE_PROD = 'Ferme Tremblay'));

-- 1) d)

delete from  TP2_SORTIE_CUEILLEUR 
where NO_SORTIE IN (select NO_SORTIE from TP2_SORTIE where DATE_SOR < SYSDATE - 1000);

-- 1) e) -- update marche pas

 update TP2_SORTIE
    set LATITUDE_SOR = 46.702267, LONGITUDE_SOR = -71.911809
    where DATE_SOR = to_date('2023-06-10', 'YYYY-MM-DD')
    AND NO_EMPLOYE = (select NO_EMPLOYE FROM TP2_EMPLOYE WHERE UTILISATEUR_EMP = 'JJean')
    AND NO_PROPRIETAIRE = (select NO_PROPRIETAIRE FROM TP2_PROPRIETAIRE WHERE UTILISATEUR_PROP = 'LucGiroux');

-- 1) f)

select NOM_RES, NO_TEL_RES
    from TP2_RESSOURCE_AIDE
    WHERE NOM_RES like 'Saint%';

-- 1) g)

select L.NOM_ENTREPOT, E.CODE_POSTAL_ENT 
    from TP2_LIVRAISON L
    join TP2_ENTREPOT E on L.NOM_ENTREPOT = E.NOM_ENTREPOT
    order by L.DATE_LIV desc;
    
-- 1) h) i)
select R.DESCRIPTION_ROU
    from TP2_ROUTE R, TP2_CAMION C
    where R.JOUR_LIVRAISON_ROU in ('mardi')
    and C.EST_REFRIGERE_CAM in (1);
    
-- 1) h) ii)

select R.DESCRIPTION_ROU
    from TP2_ROUTE R right join TP2_CAMION C
    on R.JOUR_LIVRAISON_ROU = ('mardi')
    and C.EST_REFRIGERE_CAM = 1;

-- 1) h) iii)

select R.DESCRIPTION_ROU
    from TP2_ROUTE R, TP2_CAMION C
    where exists (select * from TP2_ROUTE where R.JOUR_LIVRAISON_ROU = ('mardi')
    and C.EST_REFRIGERE_CAM = 0);
    
-- 1) i) 

select P.PRENOM_PROD || ' ' || P.NOM_PROD AS NOM_COMPLET, A.NOM_ALIMENT, count(SR.NO_SORTIE) AS NB_RECOLTES
    from TP2_PRODUCTEUR P
    join TP2_SORTIE S ON P.CODE_PRODUCTEUR = S.CODE_PRODUCTEUR
    join TP2_SORTIE_RECOLTE SR ON S.NO_SORTIE = SR.NO_SORTIE
    join TP2_ALIMENT A ON SR.NOM_ALIMENT = A.NOM_ALIMENT
    group by P.CODE_PRODUCTEUR, A.NOM_ALIMENT, P.PRENOM_PROD, P.NOM_PROD
    order by NB_RECOLTES desc;

-- 1) j) i)

select P.NOM_PROD, P.PRENOM_PROD
    from TP2_PRODUCTEUR P
    where P.CODE_PRODUCTEUR 
    NOT IN (
        select S.CODE_PRODUCTEUR
            from TP2_SORTIE S
            group by S.CODE_PRODUCTEUR
    having count(S.NO_SORTIE) >= 5
);

-- 1) j) ii)
select P.NOM_PROD, P.PRENOM_PROD
    from TP2_PRODUCTEUR P
    MINUS
        select P.NOM_PROD, P.PRENOM_PROD
            from TP2_PRODUCTEUR P
            join TP2_SORTIE S ON P.CODE_PRODUCTEUR = S.CODE_PRODUCTEUR
            group by P.NOM_PROD, P.PRENOM_PROD
    having count (S.NO_SORTIE) >= 5;
-- 1) j) iii)
select P.NOM_PROD, P.PRENOM_PROD
    from TP2_PRODUCTEUR P
    where 
    NOT EXISTS (
        select *
            from TP2_SORTIE S
            where P.CODE_PRODUCTEUR = S.CODE_PRODUCTEUR
            group by S.CODE_PRODUCTEUR
    having count(S.NO_SORTIE) >= 5
);  

    
-- 1) k)

select P.PRENOM_PROD, P.NOM_PROD
    from TP2_PRODUCTEUR P
    where P.CODE_PRODUCTEUR 
    NOT IN (
        select S.CODE_PRODUCTEUR
        from TP2_SORTIE S
        where S.DATE_SOR >= ADD_MONTHS(SYSDATE, -12)
)
    order by P.PRENOM_PROD, P.NOM_PROD;



-- 1) l) i)RIEN NAFFICHE A VOIR
-- 1) l) ii)RIEN NAFFICHE A VOIR
-- 1) l) iii) RIEN NAFFICHE A VOIR

select COURRIEL_PROP
    from TP2_PROPRIETAIRE
    where COURRIEL_PROP like '%.com'
    INTERSECT
    select COURRIEL_EMP
        from TP2_EMPLOYE
        where CODE_TYPE_EMPLOYE = 'CTE2';

select  COURRIEL_PROP
    from TP2_PROPRIETAIRE P
    where COURRIEL_PROP like '%.com'
    AND EXISTS (
        select 1
        from TP2_EMPLOYE E
        where E.COURRIEL_EMP = P.COURRIEL_PROP
    AND E.CODE_TYPE_EMPLOYE = 'CTE2'
);

select COURRIEL_PROP
    from TP2_PROPRIETAIRE
    where COURRIEL_PROP like '%.com'
    AND COURRIEL_PROP IN (
        select COURRIEL_EMP
        from TP2_EMPLOYE
        where CODE_TYPE_EMPLOYE = 'CTE2'
);


-- 1) m) i)

create or replace view VUE_CUEILLEUR_HIERARCHIE as
    select COURRIEL_CUE, NOM_CUE, PRENOM_CUE, TEL_CUE from TP2_CUEILLEUR;
    
-- 1) m) ii)    
    
select * from VUE_CUEILLEUR_HIERARCHIE;

-- 1) m) iii)
-- (1)
insert into VUE_CUEILLEUR_HIERARCHIE (COURRIEL_CUE, NOM_CUE, PRENOM_CUE, TEL_CUE)
values ('ocaronbdeb@gmail.com', 'Caron', 'Olivier', '(574)284-7431');
--(2)
/*
Ce n'est pas possible d'ajouter un enregitrement dans cette vue car elle ne contient pas tous les attributs de la table TP2_CUEILLEUR ayant comme contrainte not null.
Ceci est très clair en lisant le message d'erreur de la console suivante qui spécifie cannot insert NULL dans le champ NO_CUEILLEUR de la table TP2_CUEILLEUR :

Error starting at line : 386 in command -
insert into VUE_CUEILLEUR_HIERARCHIE (COURRIEL_CUE, NOM_CUE, PRENOM_CUE, TEL_CUE)
values ('ocaronbdeb@gmail.com', 'Caron', 'Olivier', '(574)284-7431')
Error report -
ORA-01400: cannot insert NULL into ("C##OLCAR40"."TP2_CUEILLEUR"."NO_CUEILLEUR")
*/

-- 1) n) i)  
    delete from TP2_PRODUCTEUR where NOM_ENTREPRISE_PROD = 'Ferme Tremblay'; 
    
    /*
    Cette requête est utile car comme spécifié plus tôt à la question 1) c) M. Tremblay prendra sa retraite et ne sera plus producteur officiellement. 
    Puisque ses données ont étées transférées dans la table TP2_PROPRIETAIRE, il est logique d'enlever ses informations de la table TP2_PRODUCTEUR 
    */
    
-- 1) n) ii)  

    update TP2_RESSOURCE_AIDE
        set ADRESSE_RES = '600 rue Benoît', VILLE_RES = 'St-Hyacinthe', CODE_POSTAL_RES = 'J2S 1L6', NO_TEL_RES = '(450)768-6995'
        where CODE_RESSOURCE_AIDE = 'CRA1';
        
    /*
    Cette requête est utile dans le cas où une ressource d'aide change d'adresse et de numéro de téléphone.
    */
    
-- 1) n) iii)      

    insert into TP2_PRODUCTEUR_ALIMENT(CODE_PRODUCTEUR, NOM_ALIMENT)
    values((select CODE_PRODUCTEUR from TP2_PRODUCTEUR where CODE_PRODUCTEUR = 1030) ,(select NOM_ALIMENT from TP2_ALIMENT where NOM_ALIMENT = 'Patates' ));
     
    /*
    Cette requête est utile dans le cas où on a un producteur qui rajoute un aliment à sa sélection.
    */

-- 1) n) iv)  

    alter table TP2_PROPRIETAIRE
    add BOOL_EST_PROCHE_DE_LA_RETRAITE number(1) null;

   /*
    Cette requête est utile dans le cas où on a un propriétaire proche de l'age de la retraite comme MR Tremblay, ce qui peut permettre à SAP de garder un suivi sur sa BD et s'assurer qu'elle sera à jour éventuellement.
    */
    
--2a)


create or replace trigger TRG_VERIFIER_PROP_PRODUCTEUR
before insert or update on TP2_SORTIE
for each row
declare
    producteur number;
    proprietaire number;
begin
    select count(*) into producteur
    from TP2_SORTIE
    where NO_SORTIE = :new.NO_SORTIE
    and CODE_PRODUCTEUR is not null;

    select count(*) into  proprietaire
    from TP2_SORTIE
    where NO_SORTIE = :new.NO_SORTIE
    and NO_PROPRIETAIRE is not null;

    IF ( producteur > 0 and  proprietaire > 0)or ( producteur = 0 and  proprietaire = 0) then

        RAISE_APPLICATION_ERROR(-20001, 'ERREUR : Une sortie doit avoir soit un producteur soit un propriétaire, mais pas les deux');
    end if;
end;
/
-- Test si jai proprio ET producteur - OK 
insert into TP2_SORTIE (NO_SORTIE, NO_EMPLOYE, CODE_PRODUCTEUR, NO_PROPRIETAIRE, DATE_SOR, DUREE_SOR, PART_PROD_SOR, PART_SAP_SOR, NOMBRE_ARBRE_SOR, EMPLACEMENT_PROP_SOR, ACCES_ARBRE_SOR, NOMBRE_CUEILLEUR_SOR, BOOL_AVANT_MIDI_SEMAINE_SOR, BOOL_APRES_MIDI_SEMAINE_SOR, BOOL_AVANT_MIDI_FIN_SEMAINE_SOR, BOOL_APRES_MIDI_FIN_SEMAINE_SOR, COMMENTAIRE_SOR, HAUTEUR_MINIMAL_SOR, LATITUDE_SOR, LONGITUDE_SOR)
values (TP2_SEQUENCE_SORTIE.nextval,(select NO_EMPLOYE from TP2_EMPLOYE where UTILISATEUR_EMP = 'JZawinul'), 1030, 2, to_date ('2023/06/10 9:30', 'YYYY/MM/DD HH:MI'), '2 heures', '40', '60', 50, 'cour arrière', 'Accès par la porte principale', '20', 1, 1, 1, 1, 'Pas besoin de échelle', 20, 40.3141, 61.1314);

-- Test si jai pas un des deux proprio et producteur   -- NULL DANS UN DES CHAMP PROD OU PROPRIO NE FONCTIONNE PAS CA ME DONNE UN ERREUR QUAND MEME   
insert into TP2_SORTIE (NO_SORTIE, NO_EMPLOYE, CODE_PRODUCTEUR, NO_PROPRIETAIRE, DATE_SOR, DUREE_SOR, PART_PROD_SOR, PART_SAP_SOR, NOMBRE_ARBRE_SOR, EMPLACEMENT_PROP_SOR, ACCES_ARBRE_SOR, NOMBRE_CUEILLEUR_SOR, BOOL_AVANT_MIDI_SEMAINE_SOR, BOOL_APRES_MIDI_SEMAINE_SOR, BOOL_AVANT_MIDI_FIN_SEMAINE_SOR, BOOL_APRES_MIDI_FIN_SEMAINE_SOR, COMMENTAIRE_SOR, HAUTEUR_MINIMAL_SOR, LATITUDE_SOR, LONGITUDE_SOR)
values (TP2_SEQUENCE_SORTIE.nextval,(select NO_EMPLOYE from TP2_EMPLOYE where UTILISATEUR_EMP = 'JZawinul'), 1030, NULL, to_date ('2023/06/10 9:30', 'YYYY/MM/DD HH:MI'), '2 heures', '40', '60', 50, 'cour arrière', 'Accès par la porte principale', '20', 1, 1, 1, 1, 'Pas besoin de échelle', 20, 40.3141, 61.1314);


--2b)

create table SORTIE_ARCHIVE as select * from TP2_SORTIE where 1 = 0;
create table SORTIE_CUEILLEUR_ARCHIVE as select * from TP2_SORTIE_CUEILLEUR where 1 = 0;
create table SORTIE_RECOLTE_ARCHIVE as select * from TP2_SORTIE_RECOLTE where 1 = 0;

create or replace procedure SP_ARCHIVER_SORTIE(p_date in date) as
    v_vieille_date date := ADD_MONTHS(trunc(SYSDATE), -60); 
begin
    if p_date <  v_vieille_date then
    
        insert into SORTIE_ARCHIVE
        select *
        from TP2_SORTIE
        where DATE_SOR < p_date;

        insert into SORTIE_CUEILLEUR_ARCHIVE
        select *
        from TP2_SORTIE_CUEILLEUR
        where NO_SORTIE in (select NO_SORTIE from TP2_SORTIE where DATE_SOR < p_date);

        insert into SORTIE_RECOLTE_ARCHIVE
        select *
        from TP2_SORTIE_RECOLTE
        where NO_SORTIE in (select NO_SORTIE from TP2_SORTIE where DATE_SOR < p_date);

        delete from TP2_SORTIE where DATE_SOR < p_date;
        delete from TP2_SORTIE_CUEILLEUR where NO_SORTIE in (select NO_SORTIE from TP2_SORTIE where DATE_SOR < p_date);
        delete from TP2_SORTIE_RECOLTE where NO_SORTIE in (select NO_SORTIE from TP2_SORTIE where DATE_SOR < p_date);
    
        DBMS_OUTPUT.PUT_LINE('Archivage terminé avec succès.');
    else
        DBMS_OUTPUT.PUT_LINE('ERREUR archivage non possible : La date doit être plus vieille qu''il y a 5 ans.');
    end if;
end;
/
--Test date plus de 5 ans - OK
delete from TP2_SORTIE_RECOLTE
where NO_SORTIE in (select NO_SORTIE from TP2_SORTIE where DATE_SOR < to_date('2016/06/20', 'YYYY/MM/DD'));
set serveroutput on;
execute SP_ARCHIVER_SORTIE(TO_DATE('2016/06/20', 'YYYY/MM/DD'));

--Test date moins de 5 ans - OK
delete from TP2_SORTIE_RECOLTE
where NO_SORTIE in (select NO_SORTIE from TP2_SORTIE where DATE_SOR < to_date('2020/06/20', 'YYYY/MM/DD'));
set serveroutput on;
execute SP_ARCHIVER_SORTIE(TO_DATE('2020/06/20', 'YYYY/MM/DD'));

--2c) voir mot de passe plus haut

--2d) on peut faire une fonction qui genere un code_producteur automatique un peu comme le mot de passe, car cest le seul quon a pas eu a créé une séquence et jai eu a les inventer du clavier.

--3a)i)
create index IDX_DATE_SORTIE
    on TP2_SORTIE(DATE_SOR);

--3a)ii)
    -- (1)
    -- Nous avons choisi d'indexer la date de sortie car non seulement il pourrait y avoir beaucoup d'entrées pour cet attribut mais également dû au fait que les résultats de recherche de sortie doivent 
    -- toujours être triés par date de sortie. Le fait d'indexer la date de sortie crée un pré-tri des résultats.
    
    --(2)
    -- Nous ne croyons pas qu'une indexation des noms des employés responsables permettrait d'améliorer les performance de manière significative puisqu'il y a forcément beaucoup de duplication dans cet attribut
    -- car un employé sera responsable de plusieurs sorties.

--3a)iii)
    --(1)
    /*Une indexation de l'attribut NOM_CUEILLEUR de la table TP2_CUEILLEUR serait pertinent car dans une situation réelle, le nombre de cueilleur pourrait être très grand ce qui allongerait le temps de recherche pour cet attribut*/
    
create index IDX_NOM_CUE
     on TP2_CUEILLEUR(NOM_CUE);
     
    --(2)
    /*Une indexation de l'attribut DATE_LIV de la table TP2_LIVRAISON serait pertinent car dans une situation réelle, le nombre de livraison pourrait être très grand sur une grande période de temps, ce qui allongerait le temps de recherche pour cet attribut*/
    
create index IDX_DATE_LIV
     on TP2_LIVRAISON(DATE_LIV);
    
    --(3)
    /*Une indexation de l'attribut VILLE_ENT de la table TP2_ENTREPOT serait pertinent car dans une situation réelle, le nombre d'entrepôt pourrait être très grand et répartis sur plusieurs villes différentes, ce qui allongerait le temps de recherche pour cet attribut*/
    
    create index IDX_VILLE_ENT
     on TP2_ENTREPOT(VILLE_ENT);

--3a)iv)

--3b)i)

-- J'ai dénormalisé la table TP2_EMPLOYE_TYPE en utilisant la méthode 7.3 en dupliquant les attributs clés étrangères ce qui réduit les jointures de la table TP2_EMPLOYE ainsi que la méthode 7.2.1 pour 
-- dupliquer les attributs non clés puisque la jointure entre les tables de la table TP2_EMPLOYE_TYPE et TP2_EMPLOYE n'est plus nécessaire.

--3b)ii)
alter table TP2_EMPLOYE
    add DESC_TYPE_EMP varchar2(40);
    
update TP2_EMPLOYE EMP
    set EMP.DESC_TYPE_EMP = (select EMPT.DESC_TYPE_EMP from TP2_EMPLOYE_TYPE EMPT where EMP.CODE_TYPE_EMPLOYE = EMPT.CODE_TYPE_EMPLOYE);
    
--3b)iii)
--3b)iv)
