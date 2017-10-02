# Docker pour déploiement d'un serveur [PMB ludoTECH](https://github.com/cocof-cirb/pmb_ludoTech) minimal


Ce répository contient l'ensemble des fichiers nécessaires à la mise en place d'un serveur LAMP pour le logiciel
[PMB ludoTECH](https://github.com/cocof-cirb/pmb_ludoTech).

Parmis ces fichiers, il y a une base données minimale contenant 5 notices et 2 emprunteurs. 


_Attention_: 
* Etant donné qu'il s'agit d'un fork du logiciel PMB Biblio, l'installation PMB traditionnelle "sans base de données" ne fonctionne plus et vous **devez** utiliser la base de données minimale fournie ici.
* Ce Docker n'est probablement pas suffisant pour aller en production tel quel, il n'inclut par exemple pas le setup HTTPS et les mots de passe sont codés en dur.



## Utilisation

NB: le port 32888 est pré-configuré dans le logiciel, ne le changez pas sans adapter la config de PMB LudoTech et de la DB.

Pour récupérer et lancer l'image docker:
```sh
$ docker pull cocofcirb/pmb-ludotech-distribution-internet
$ docker run -itd -p32888:80 --name pmbludotechdistributioninternet_pmb_1 cocofcirb/pmb-ludotech-distribution-internet
```

ou bien, si vous avez cloné le répository pour le modifier ou que vous voulez travailler avec docker-compose:

```sh
$ docker-compose build
$ docker-compose up --force-recreate
```

Une fois démarré, pour accéder au serveur, pointez votre browser sur l'url suivante:
    http://localhost:32888/pmb


Les comptes suivants sont tous actifs (et disposent de tous les droits):

| Login  | Passwords |
| ----   | ------    |
| admin  | admin     |
| pmb    | pmb       |
| ludo   | ludo      |


Si vos ludothécaires veulent tester le logiciel, mieux vaut utiliser le nom (dns) public pré-configuré suivant afin que les vignettes des jeux et les documents numériques présents dans l'image docker soient accessibles.
    http://docker:32888/pmb

L'alternative consiste à modifier le paramètre PMB appellé "base_url" via le menu "Administration" > "Outils" > "Paramètres". Celui-ci inclus le nom et le port par lequel l'application est contactée par le browser. Après changement de ce paramètre, il faut réimporter les documents numériques et les vignettes pour que la nouvelle URL prenne effet.


Pour tester le catalogue en ligne, visitez:
    http://localhost:32888/pmb/opac_css/
ou
    http://docker:32888/pmb/opac_css/


## Contenu
L'image de base est Ubuntu à laquelle sont rajoutés: 
* apache
* mysql
* php

##### Setup mysql

Base de données: `ludoDB`
Login mysql:    `ludo`
Password mysql: `ludo`

Pour examiner / modifier la base de données d'un container, vous pouvez exécuter:
```sh
$ docker exec -it pmbludotechdistributioninternet_pmb_1 mysql -u ludo -pludo ludoDB
```

Ou pour extraire les données de la base:
```sh
$ docker exec -it pmbludotechdistributioninternet_pmb_1 mysqldump -u ludo -pludo --extended-insert=FALSE  ludoDB > resources/db/dump/ludoDB.sql
```

Une procédure CRON de backup quotidien est également fournie.

