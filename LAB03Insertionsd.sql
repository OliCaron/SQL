insert into LAB_CLIENT (NO_CLIENT, NOM_CLI, TEL_CLI, COURRIEL_CLI) values (NO_CLIENT_SEQ.nextval,  'Louis Tremblay', '4185557887', 'lt@moncourriel.com');
insert into LAB_CLIENT (NO_CLIENT, NOM_CLI, TEL_CLI, COURRIEL_CLI) values (NO_CLIENT_SEQ.nextval,  'Lucie Gamache', '4185556582', 'luga23@hotmail.ch');
insert into LAB_CLIENT (NO_CLIENT, NOM_CLI, TEL_CLI, COURRIEL_CLI) values (NO_CLIENT_SEQ.nextval,  'Julie Simard', '5804125456', 'julie@juliesimard.com');
insert into LAB_CLIENT (NO_CLIENT, NOM_CLI, TEL_CLI, COURRIEL_CLI) values (NO_CLIENT_SEQ.nextval,  'Jean Paré', '5147894552', 'info@info.ca');
insert into LAB_CLIENT (NO_CLIENT, NOM_CLI, TEL_CLI, COURRIEL_CLI) values (NO_CLIENT_SEQ.nextval,  'Thomas voyer',  '5145213599',  'voyert@outlook.uk');	

insert into LAB_LIVRE (NO_LIVRE,TITRE_LIV,NB_INVENTAIRE_LIV,MNT_PRIX_VENTE_LIV) values (894,'Un très bon livre',45,19.99);
insert into LAB_LIVRE (NO_LIVRE,TITRE_LIV,NB_INVENTAIRE_LIV,MNT_PRIX_VENTE_LIV) values (654,'Le meilleur du possible',54,1.66);
insert into LAB_LIVRE (NO_LIVRE,TITRE_LIV,NB_INVENTAIRE_LIV,MNT_PRIX_VENTE_LIV) values (321,'La coupe est pleine',12,31.54);
insert into LAB_LIVRE (NO_LIVRE,TITRE_LIV,NB_INVENTAIRE_LIV,MNT_PRIX_VENTE_LIV) values (123,'Les étoiles sont lumineuses',152,47.95);



insert into LAB_MAISON_EDITION (NOM_MAI,TEL_MAI,COURRIEL_MAI) values ('Maison du livre','4185554569','info@maisonlivre.com');
insert into LAB_MAISON_EDITION (NOM_MAI,TEL_MAI,COURRIEL_MAI) values ('Wisley','4185554452','wisley@wisley.com');
insert into LAB_MAISON_EDITION (NOM_MAI,TEL_MAI,COURRIEL_MAI) values ('Livre pro','5805557788','livre@livrepro.com');
insert into LAB_MAISON_EDITION (NOM_MAI,TEL_MAI,COURRIEL_MAI) values ('Les revendicateurs','6135559987','admin@lesrevendicateurs.com');
insert into LAB_MAISON_EDITION (NOM_MAI,TEL_MAI,COURRIEL_MAI) values ('Les inconfus','6135559932','zinconfus@lesinconfus.com');




insert into LAB_ACHAT (NO_MAISON,NO_LIVRE,MNT_PRIX_ACH,DATE_ACH) values (120,321,3.79,to_date('15-01-01','RR-MM-DD'));
insert into LAB_ACHAT (NO_MAISON,NO_LIVRE,MNT_PRIX_ACH,DATE_ACH) values (33333,551,20,to_date('15-06-25','RR-MM-DD'));
insert into LAB_ACHAT (NO_MAISON,NO_LIVRE,MNT_PRIX_ACH,DATE_ACH) values (33335,654,3.99,to_date('15-07-01','RR-MM-DD'));
insert into LAB_ACHAT (NO_MAISON,NO_LIVRE,MNT_PRIX_ACH,DATE_ACH) values (33335,894,8.99,to_date('14-09-30','RR-MM-DD'));
insert into LAB_ACHAT (NO_MAISON,NO_LIVRE,MNT_PRIX_ACH,DATE_ACH) values (33333,654,8.99,to_date('15-07-09','RR-MM-DD'));
insert into LAB_ACHAT (NO_MAISON,NO_LIVRE,MNT_PRIX_ACH,DATE_ACH) values (33337,321,8.99,to_date('15-07-09','RR-MM-DD'));
insert into LAB_ACHAT (NO_MAISON,NO_LIVRE,MNT_PRIX_ACH,DATE_ACH) values (33339,321,12.25,to_date('15-07-09','RR-MM-DD'));
insert into LAB_ACHAT (NO_MAISON,NO_LIVRE,MNT_PRIX_ACH,DATE_ACH) values (33341,123,25,to_date('15-06-15','RR-MM-DD'));
insert into LAB_ACHAT (NO_MAISON,NO_LIVRE,MNT_PRIX_ACH,DATE_ACH) values (33339,654,29.99,to_date('15-06-15','RR-MM-DD'));
