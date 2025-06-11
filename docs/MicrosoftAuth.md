# Authentification Microsoft

L'authentification avec Microsoft est entièrement prise en charge par Helios Launcher.

## Acquisition d'un identifiant client Entra

1. Accédez à https://portal.azure.com
2. Dans la barre de recherche, recherchez **ID Microsoft Entra**.
3. Dans Microsoft Entra ID, accédez à **Enregistrements d'applications** dans le volet de gauche (sous *Gérer*).
4. Cliquez sur **Nouvelle inscription**.
- Définissez **Nom** comme nom de votre lanceur.
- Définissez **Types de comptes pris en charge** sur *Comptes dans n'importe quel annuaire d'organisation (n'importe quel locataire Microsoft Entra ID - Multilocataire) et comptes Microsoft personnels (par exemple, Skype, Xbox)*.
- Laissez **URI de redirection** vide.
- Enregistrez l'application.
5. Vous devriez être sur la page de gestion de l'application. Sinon, revenez à **Enregistrements d'applications**. Sélectionnez l'application que vous venez d'enregistrer.
6. Cliquez sur **Authentification** dans le volet de gauche (sous *Gérer*).
7. Cliquez sur **Ajouter une plateforme**.
- Sélectionnez **Applications mobiles et de bureau**.
- Choisissez `https://login.microsoftonline.com/common/oauth2/nativeclient` comme **URI de redirection**.
- Sélectionnez **Configurer** pour terminer l'ajout de la plateforme.
8. Accédez à **Certificats et secrets**.
- Sélectionnez **Secrets clients**.
- Cliquez sur **Nouveau secret client**.
- Définissez une description.
- Cliquez sur **Ajouter**.
- Ne copiez pas le secret client ; son ajout est une exigence de Microsoft.
8. Revenez à **Aperçu**.
9. Copiez l'**ID d'application (client)**.

## Ajout de l'ID client Entra à Helios Launcher.

Dans app/assets/js/ipcconstants.js, vous trouverez **AZURE_CLIENT_ID**. Définissez-le avec l'identifiant de votre application.

Remarque : L'identifiant client Entra n'est PAS une valeur secrète et **peut** être stocké dans Git. Référence : https://stackoverflow.com/questions/57306964/are-azure-active-directorys-tenantid-and-clientid-considered-secrets

Relancez ensuite votre application et connectez-vous. Un message d'erreur s'affichera, car l'application n'est pas encore sur liste blanche. Microsoft a besoin d'une certaine activité sur l'application avant de l'ajouter à la liste blanche. __Il est obligatoire de se connecter avant de demander l'ajout à la liste blanche.__

## Demande d'ajout à la liste blanche auprès de Microsoft

1. Assurez-vous d'avoir suivi toutes les étapes de cette page de documentation.
2. Remplissez [ce formulaire](https://aka.ms/mce-reviewappid) avec les informations requises. N'oubliez pas qu'il s'agit d'un nouvel ID d'application à approuver. Vous trouverez l'ID client et l'ID locataire sur la page d'aperçu du portail Azure.
3. Laissez à Microsoft le temps d'examiner votre application.
4. Une fois l'approbation de Microsoft obtenue, prévoyez jusqu'à 24 heures pour que les modifications soient appliquées.

----

Vous pouvez désormais vous authentifier auprès de Microsoft via le lanceur.

Références :
- https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app
- https://help.minecraft.net/hc/en-us/articles/16254801392141