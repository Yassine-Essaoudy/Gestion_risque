  Smart Contract pour la Gestion des Risques de Contrepartie

Smart Contract pour la Gestion des Risques de Contrepartie
==========================================================

Ce projet met en œuvre un système de gestion des risques de contrepartie sur la blockchain Ethereum. Il utilise un smart contract écrit en Solidity pour gérer les contreparties, suivre l'exposition aux risques et fournir des mécanismes d'évaluation des risques de crédit. Le projet inclut des scripts Python pour compiler, déployer et interagir avec le smart contract, ainsi qu'une application Streamlit pour faciliter son utilisation.

Fonctionnalités
---------------

*   **Ajout de Contreparties** : Ajouter et gérer les données des contreparties, y compris les scores de crédit et les limites d'exposition.
*   **Gestion des Positions** : Enregistrer les positions avec des montants, des garanties (collaterals), et calculer les ratios de couverture.
*   **Calcul du Risque** : Évaluer les risques à l'aide de scores basés sur l'exposition courante et les limites d'exposition.
*   **Alertes Automatiques** : Détecter et notifier lorsque l'exposition dépasse les limites définies.
*   **Interaction avec Streamlit** : Une interface utilisateur simple pour interagir avec le smart contract.

Structure du Projet
-------------------

        ├── contracts/
        │   └── GestionnaireRisqueContrepartie.sol  # Le smart contract en Solidity
        ├── scripts/
        │   ├── compile\_contract.py                # Script pour compiler le smart contract
        │   ├── deploy\_contract.py                 # Script pour déployer le smart contract
        │   ├── contract\_address.json              # Fichier contenant l'adresse du contrat déployé
        │   ├── abi.json                           # ABI généré du contrat
        │   ├── bytecode.json                      # Bytecode généré du contrat
        │   └── streamlit\_app.py                   # Application Streamlit pour interagir avec le contrat
        ├── .env                                   # Fichier contenant les variables d'environnement
        └── README.md                              # Ce fichier
    

Pré-requis
----------

Avant de commencer, assurez-vous d'avoir les outils suivants installés sur votre machine :

*   Python 3.8+
*   Streamlit (installé via `pip install streamlit`)
*   Un compte Infura (pour interagir avec Ethereum)

Installation
------------

Clonez le dépôt GitHub :

    git clone <url-du-repo>
    cd <nom-du-repo>

Installez les dépendances Python :

    pip install -r requirements.txt

Configurez les variables d'environnement dans un fichier `.env` (à la racine du projet) :

    INFURA_URL=https://<votre-url-infura>
    PRIVATE_KEY=<votre-cle-privee>
    ACCOUNT_ADDRESS=<votre-adresse-ethereum>

Utilisation
-----------

### Étape 1 : Compiler le contrat

Exécutez le script `compile_contract.py` pour compiler le contrat et générer les fichiers `abi.json` et `bytecode.json`.

    python scripts/compile_contract.py

Les fichiers `abi.json` et `bytecode.json` seront générés dans le répertoire `scripts/`.

### Étape 2 : Déployer le contrat

Une fois le contrat compilé, déployez-le sur le réseau Ethereum via Infura en exécutant le script `deploy_contract.py` :

    python scripts/deploy_contract.py

L'adresse du contrat déployé sera enregistrée dans `scripts/contract_address.json`.

### Étape 3 : Lancer l'application Streamlit

L'application Streamlit permet d'interagir avec le smart contract via une interface utilisateur.

    streamlit run scripts/streamlit_app.py

Une fois lancée, l'application sera accessible dans votre navigateur.

Fonctionnalités via Streamlit
-----------------------------

*   **Ajouter une contrepartie** : Fournir un score de crédit, une limite d'exposition, et activer une nouvelle contrepartie.
*   **Ajouter une position** : Enregistrer des transactions incluant un montant et une garantie.
*   **Afficher les détails des contreparties** : Visualiser les scores de crédit, les expositions courantes et nettes.
*   **Calculer le risque** : Obtenir un score de risque basé sur l'exposition.
*   **Afficher les positions** : Consulter les données des positions pour un initiateur.

Structure des Fichiers Importants
---------------------------------

*   **GestionnaireRisqueContrepartie.sol** : Le smart contract écrit en Solidity gère les fonctionnalités principales, telles que l'ajout de contreparties, l'enregistrement des positions, et l'évaluation des risques.
*   **compile\_contract.py** : Ce script compile le contrat en utilisant solcx et génère deux fichiers JSON :
    *   `abi.json` : Interface pour interagir avec le contrat.
    *   `bytecode.json` : Code exécutable pour déployer le contrat.
*   **deploy\_contract.py** : Ce script utilise l'ABI et le bytecode pour déployer le contrat sur un réseau Ethereum via Infura. L'adresse du contrat déployé est sauvegardée dans `contract_address.json`.
*   **streamlit\_app.py** : Une interface utilisateur interactive qui permet de consommer les fonctionnalités du contrat directement depuis votre navigateur.

Contribution
------------

Les contributions sont les bienvenues ! Veuillez ouvrir une issue ou soumettre une pull request pour toute amélioration ou fonctionnalité supplémentaire.

Avertissement
-------------

Ce projet est fourni à titre éducatif uniquement. Assurez-vous de bien comprendre les implications de l'utilisation de smart contracts sur une blockchain publique avant de déployer des contrats contenant des données sensibles.