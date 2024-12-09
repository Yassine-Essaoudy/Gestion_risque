// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GestionnaireRisqueContrepartie {
    struct Position {
        address contrepartie;
        uint256 amount;
        uint256 collateral;
        uint256 ratioDeCouverture; // Coverage ratio (collateral / amount)
    }

    struct Contrepartie {
        uint256 scoreCredit; // Credit score for risk evaluation
        uint256 limiteExposition; // Maximum exposure allowed
        uint256 expositionCourante; // Current exposure
        uint256 expositionNette; // Net exposure
        bool estActif; // Status of the counterparty (active/inactive)
    }

    // Mappings
    mapping(address => Position[]) private positions; // History of positions for each initiater
    mapping(address => Contrepartie) private contreparties;

    // Events
    event PositionAjoutee(address indexed initiater, address indexed contrepartie, uint256 amount, uint256 collateral);
    event ExpositionNetteMiseAJour(address indexed portefeuille, uint256 nouvelleExpositionNette);
    event AlerteExpositionCourante(address indexed portefeuille, uint256 expositionCourante, uint256 limiteExposition);

    // Add a new counterparty
    function ajouterContrepartie(
        address _portefeuille,
        uint256 _scoreCredit,
        uint256 _limiteExposition
    ) public {
        require(_portefeuille != address(0), "Adresse invalide");
        require(!contreparties[_portefeuille].estActif, "Contrepartie deja active");

        contreparties[_portefeuille] = Contrepartie({
            scoreCredit: _scoreCredit,
            limiteExposition: _limiteExposition,
            expositionCourante: 0,
            expositionNette: 0,
            estActif: true
        });

        emit ExpositionNetteMiseAJour(_portefeuille, 0);
    }

    // Add a new position
    function ajouterPosition(
        address initiater,
        address contrepartie,
        uint256 amount,
        uint256 collateral
    ) public {
        Contrepartie storage initiaterData = contreparties[initiater];
        Contrepartie storage contrepartieData = contreparties[contrepartie];

        require(initiaterData.estActif, "Initiater inactif");
        require(contrepartieData.estActif, "Contrepartie inactive");
        require(amount > 0, "Le montant doit etre superieur a zero");

        // Calculate ratio de couverture
        uint256 ratioDeCouverture = (collateral ) / amount;

        // Calculate deltaExpositionNette and nouvelleExpositionNette
        uint256 deltaExpositionNette = amount > collateral ? amount - collateral : 0;
        uint256 nouvelleExpositionNette = initiaterData.expositionNette + deltaExpositionNette;

        require(
            nouvelleExpositionNette <= initiaterData.limiteExposition,
            "Limite d'exposition depassee"
        );

        // Update expositional data
        initiaterData.expositionNette = nouvelleExpositionNette;
        initiaterData.expositionCourante += amount;

        contrepartieData.expositionNette = contrepartieData.expositionNette > amount
            ? contrepartieData.expositionNette - amount
            : 0;

        // Raise alert if expositionCourante surpasses the limit
        if (initiaterData.expositionCourante > initiaterData.limiteExposition) {
            emit AlerteExpositionCourante(
                initiater,
                initiaterData.expositionCourante,
                initiaterData.limiteExposition
            );
        }

        // Store the position
        positions[initiater].push(Position({
            contrepartie: contrepartie,
            amount: amount,
            collateral: collateral,
            ratioDeCouverture: ratioDeCouverture
        }));

        // Emit events
        emit PositionAjoutee(initiater, contrepartie, amount, collateral);
        emit ExpositionNetteMiseAJour(initiater, nouvelleExpositionNette);
    }

    // Calculate risk score for a counterparty
    function calculerScoreRisque(address portefeuille) public view returns (uint256) {
        Contrepartie storage contrepartie = contreparties[portefeuille];
        require(contrepartie.estActif, "Contrepartie inactive");
        require(contrepartie.limiteExposition > 0, "LimiteExposition invalide");
        require(contrepartie.scoreCredit > 0, "ScoreCredit invalide");

        // Return the calculated risk score
        return (contrepartie.expositionCourante * 10000) /
            (contrepartie.limiteExposition * contrepartie.scoreCredit);
    }

    // View function to get counterparty details
    function obtenirDetailsContrepartie(address portefeuille)
        public
        view
        returns (
            uint256 scoreCredit,
            uint256 limiteExposition,
            uint256 expositionCourante,
            uint256 expositionNette,
            bool estActif
        )
    {
        Contrepartie storage contrepartie = contreparties[portefeuille];
        return (
            contrepartie.scoreCredit,
            contrepartie.limiteExposition,
            contrepartie.expositionCourante,
            contrepartie.expositionNette,
            contrepartie.estActif
        );
    }

    // View function to get positions of an initiater
    function obtenirPositions(address initiater)
        public
        view
        returns (
            address[] memory contrepartiesArray,
            uint256[] memory amounts,
            uint256[] memory collaterals,
            uint256[] memory ratiosDeCouverture
        )
    {
        require(initiater != address(0), "Adresse initiater invalide");
        Position[] storage initiaterPositions = positions[initiater];
        uint256 length = initiaterPositions.length;
        require(length > 0, "Aucune position trouvee pour cet initiater");

        // Allocate memory for result arrays
        contrepartiesArray = new address[](length);
        amounts = new uint256[](length);
        collaterals = new uint256[](length);
        ratiosDeCouverture = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            Position storage position = initiaterPositions[i];
            contrepartiesArray[i] = position.contrepartie;
            amounts[i] = position.amount;
            collaterals[i] = position.collateral;
            ratiosDeCouverture[i] = position.ratioDeCouverture;
        }
    }
}
