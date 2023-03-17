# Présentation des packages utilisé : 

## Synchronisation des calendriers :
Pour la partie synchronisation des calendrier j'ai utilisé :
- [Device Calendar](https://pub.dev/packages/device_calendar)
Pour cette exemple, c'est la page calendar Page qui est utilisé.

### Création d'un événement dans un calendrier personnel :
Pour l'utiliser nous avons besoin de l'autorisation d'accès au calendrier.
Dans mon exemple, je vérifie si il existe un calendrier LEO, si il n'existe pas je le crée.
Lors de la création du calendrier, je lui donne un nom, une couleur et un compte associé. Comme cela, si besoin on peut créer plusieurs calendrier LEO.
Ensuite, je crée un événement, il peut prendre plusieurs paramètres, cependant, pour l'exemple, j'ai mis un id de calendrier pour le lier au calendrier LEO, un titre, un date de départ sous le format TZDateTime qui a besoin d'une date ainsi qu'une localisation, une date de fin, une description et un lieu.
On peut mettre un id d'événement pour l'éditer si il existe déjà, mais si on met un id et qu'il n'existe pas il ne sera pas créé.
Pour finir, j'ai ajouter l'événement au calendrier personnel.

### Suppression d'un événement dans un calendrier personnel :
Pour supprimer un événement, il faut juste mettre l'id de l'événement à supprimer ainsi que l'id du calendrier.

### Suppression d'un calendrier :
Pour supprimer un calendrier, il faut juste mettre l'id du calendrier à supprimer.

### Récupération des événements d'un calendrier :
Pour récupérer les événements d'un calendrier, il faut juste mettre l'id du calendrier ainsi qu'un retriveEventsParams qui permet de filtrer les événements avec une date de début et une date de fin.

#### Autre package envisagé :
- [Add 2 calendar](https://pub.dev/packages/add_2_calendar)
- [Add 2 calendar exemple](https://morioh.com/p/7fcc4bfcc5bc)

## Tâches en arrière plan :
Pour la partie tâche en arrière plan j'ai utilisé :
- [Workmanager](https://pub.dev/packages/workmanager)

Premièrement, j'initialise ma tâche en arrière plan dans l'initState de mon MyHomePage.
Pour cela, j'ai besoin d'une fonction, ainsi que de spécifier si c'est en mode débug. Il permet de mettre des notifications quand il travail ainsi que son état.
Ensuite, on peut définir si c'est une tâche périodique avec un minimum de 15 minutes, ou si c'est une tâche unique.
Pour chaque tâche, on doit l'identifier par un nom unique, ce qui nous permet si on le veut de l'annuler avec ce nom unique.
On peut cancel toute les tâches en arrière plan avec la fonction cancelAll. 