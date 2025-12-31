import '../../domain/models/blog_article.dart';

List<BlogArticle> blogArticles = [
  // 1. Featured Article (Hero)
  BlogArticle(
    id: '1',
    category: 'Santé',
    readTime: '6 min',
    title: '5 Conseils pour booster votre métabolisme',
    subtitle:
        'Découvrez les clés physiologiques pour transformer votre corps durablement.',
    author: 'Dr. Amine',
    date: '15 Déc 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=2070&auto=format&fit=crop',
    content: [
      BlogContentBlock(
        type: BlogBlockType.paragraph,
        text:
            "Le métabolisme est le moteur de votre corps. Comprendre son fonctionnement est la première étape vers une transformation physique efficace et durable. Beaucoup de mythes circulent, mais voici ce que la science nous dit réellement.",
      ),
      BlogContentBlock(
        type: BlogBlockType.heading,
        text: "Pourquoi c'est important",
      ),
      BlogContentBlock(
        type: BlogBlockType.paragraph,
        text:
            "Un métabolisme optimisé signifie plus d'énergie au quotidien, une meilleure récupération après l'effort et une plus grande facilité à maintenir un poids de forme sante.",
      ),
      BlogContentBlock(type: BlogBlockType.heading, text: "Les 5 piliers"),
      BlogContentBlock(
        type: BlogBlockType.list,
        structuredListItems: [
          {
            'title': 'Protéines à chaque repas',
            'desc':
                'Indispensables pour la construction musculaire et la satiété.',
          },
          {
            'title': 'Sommeil de qualité',
            'desc':
                '7 à 8 heures sont nécessaires pour la régulation hormonale.',
          },
          {
            'title': 'Hydratation constante',
            'desc':
                'L\'eau est le vecteur de toutes les réactions chimiques du corps.',
          },
          {
            'title': 'Activité physique variée',
            'desc': 'Combinez cardio et renforcement musculaire.',
          },
          {
            'title': 'Gestion du stress',
            'desc': 'Le cortisol chronique ralentit le métabolisme.',
          },
        ],
      ),
      BlogContentBlock(
        type: BlogBlockType.quoteWithAuthor,
        text:
            "Votre corps est une machine incroyable, donnez-lui le bon carburant et il vous le rendra.",
        secondaryText: "- Dr. Amine, Spécialiste Nutrition",
      ),
    ],
  ),

  // 2. Nutrition
  BlogArticle(
    id: '2',
    category: 'Nutrition',
    readTime: '8 min',
    title: 'Les Meilleurs Aliments pour la Prise de Masse',
    subtitle: 'Optimisez votre alimentation pour gagner du muscle sainement.',
    author: 'Coach Mehdi',
    date: '12 Déc 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=2070&auto=format&fit=crop',
    content: [
      BlogContentBlock(
        type: BlogBlockType.paragraph,
        text:
            "La prise de masse ne signifie pas manger n'importe quoi. Pour construire du muscle de qualité sans prendre trop de gras, le choix des aliments est crucial.",
      ),
      BlogContentBlock(
        type: BlogBlockType.heading,
        text: "La sainte trinité : Protéines, Glucides, Lipides",
      ),
      BlogContentBlock(
        type: BlogBlockType.paragraph,
        text:
            "L'équilibre des macronutriments est la clé. Il ne suffit pas de manger beaucoup, il faut manger bien.",
      ),
      BlogContentBlock(
        type: BlogBlockType.list,
        structuredListItems: [
          {
            'title': 'Œufs entiers',
            'desc': 'Source parfaite de protéines et de bonnes graisses.',
          },
          {
            'title': 'Flocons d\'avoine',
            'desc': 'Glucides complexes pour l\'énergie longue durée.',
          },
          {
            'title': 'Poulet et Dinde',
            'desc': 'Protéines maigres essentielles.',
          },
          {
            'title': 'Avocat et Oléagineux',
            'desc': 'Lipides sains pour la production hormonale.',
          },
        ],
      ),
      BlogContentBlock(
        type: BlogBlockType.quoteWithAuthor,
        text:
            "On ne construit pas un temple avec des briques fragiles. Votre corps mérite des matériaux de qualité.",
        secondaryText: "- Coach Mehdi",
      ),
    ],
  ),

  // 3. Entraînement
  BlogArticle(
    id: '3',
    category: 'Entraînement',
    readTime: '5 min',
    title: 'Programme Full Body : Efficacité Maximale',
    subtitle:
        'Un programme complet pour ceux qui manquent de temps mais veulent des résultats.',
    author: 'Coach Sarah',
    date: '10 Déc 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=2070&auto=format&fit=crop',
    content: [
      BlogContentBlock(
        type: BlogBlockType.paragraph,
        text:
            "Le Full Body est idéal pour les débutants comme pour les confirmés qui ont un emploi du temps chargé. Il permet de solliciter chaque groupe musculaire plusieurs fois par semaine.",
      ),
      BlogContentBlock(
        type: BlogBlockType.heading,
        text: "Avantages du Full Body",
      ),
      BlogContentBlock(
        type: BlogBlockType.list,
        listItems: [
          "Fréquence d'entraînement élevée par muscle",
          "Consommation calorique importante",
          "Gain de temps (3 séances par semaine suffisent)",
          "Récupération optimisée",
        ],
      ),
      BlogContentBlock(type: BlogBlockType.heading, text: "Séance Type"),
      BlogContentBlock(
        type: BlogBlockType.list,
        structuredListItems: [
          {'title': 'Squats', 'desc': '3 séries de 10-12 répétitions'},
          {'title': 'Développé Couché', 'desc': '3 séries de 8-10 répétitions'},
          {'title': 'Tirage Vertical', 'desc': '3 séries de 10-12 répétitions'},
          {
            'title': 'Développé Militaire',
            'desc': '3 séries de 10-12 répétitions',
          },
        ],
      ),
    ],
  ),

  // 4. Arts Martiaux - The Specific User Request Content
  BlogArticle(
    id: '4',
    category: 'Arts Martiaux',
    readTime: '12 min',
    title: 'Interview : Coach Karim, Champion d\'Algérie MMA',
    subtitle:
        'Pourquoi combiner Boxe et Musculation ? Les avantages d\'un entraînement hybride.',
    author: 'Coach Karim',
    date: '05 Décembre 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1544367563-12123d8965cd?q=80&w=2070&auto=format&fit=crop', // Matches existing card image
    content: [
      BlogContentBlock(type: BlogBlockType.heading, text: "Introduction"),
      BlogContentBlock(
        type: BlogBlockType.paragraph,
        text:
            "Coach Karim nous raconte son parcours, de ses débuts dans les rues d'Alger jusqu'à devenir champion national et formateur de talents...\n\nLa pratique régulière du sport et une bonne nutrition sont essentielles pour atteindre vos objectifs de fitness. Chez Gym Élysée DZ, nous croyons que chaque personne mérite d'avoir accès aux meilleures informations pour transformer son corps et sa vie.",
      ),
      BlogContentBlock(
        type: BlogBlockType.heading,
        text: "Les bases à maîtriser",
      ),
      BlogContentBlock(
        type: BlogBlockType.paragraph,
        text:
            "Avant de vous lancer dans des programmes avancés, il est crucial de maîtriser les fondamentaux. Nos coaches certifiés sont là pour vous guider à chaque étape de votre parcours.",
      ),
      BlogContentBlock(
        type: BlogBlockType.list,
        structuredListItems: [
          {
            'title': 'Technique avant tout',
            'desc':
                'La forme correcte prévient les blessures et maximise les résultats',
          },
          {
            'title': 'Progression graduelle',
            'desc':
                'Augmentez l\'intensité progressivement pour des gains durables',
          },
          {
            'title': 'Récupération',
            'desc': 'Le repos est aussi important que l\'entraînement lui-même',
          },
          {
            'title': 'Nutrition adaptée',
            'desc': 'Carburant de qualité pour des performances optimales',
          },
        ],
      ),
      BlogContentBlock(type: BlogBlockType.heading, text: "Conseils pratiques"),
      BlogContentBlock(
        type: BlogBlockType.paragraph,
        text:
            "Pour appliquer ces principes dans votre routine quotidienne, voici nos recommandations :",
      ),
      BlogContentBlock(
        type: BlogBlockType.list,
        listItems: [
          "Commencez chaque séance par un échauffement de 10-15 minutes",
          "Hydratez-vous régulièrement (minimum 2L d'eau par jour)",
          "Dormez 7-8 heures par nuit pour une récupération optimale",
          "Consultez nos coaches pour un programme personnalisé",
        ],
      ),
      BlogContentBlock(
        type: BlogBlockType.heading,
        text: "Le mot de nos experts",
      ),
      BlogContentBlock(
        type: BlogBlockType.quoteWithAuthor,
        text:
            "La constance bat l'intensité. Mieux vaut s'entraîner 3 fois par semaine pendant des années que 7 fois par semaine pendant un mois.",
        secondaryText: "- Coach Karim Bensalah, Gym Élysée DZ",
      ),
      BlogContentBlock(type: BlogBlockType.heading, text: "Conclusion"),
      BlogContentBlock(
        type: BlogBlockType.paragraph,
        text:
            "Que vous soyez débutant ou athlète confirmé, les principes fondamentaux restent les mêmes. Chez Gym Élysée DZ, notre équipe de professionnels est prête à vous accompagner vers l'excellence.\n\nPrenez rendez-vous pour un essai gratuit d'une semaine et découvrez pourquoi nous sommes la référence du fitness premium en Algérie.",
      ),
    ],
  ),

  // 5. Équipement
  BlogArticle(
    id: '5',
    category: 'Équipement',
    readTime: '6 min',
    title: 'Bien choisir ses gants de boxe',
    subtitle: 'Guide complet pour débutants et confirmés.',
    author: 'Coach Ali',
    date: '05 Déc 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?q=80&w=2069&auto=format&fit=crop',
    content: [
      BlogContentBlock(
        type: BlogBlockType.paragraph,
        text:
            "Les gants sont l'outil principal du boxeur. Un mauvais choix peut mener à des blessures ou à une mauvaise technique.",
      ),
      BlogContentBlock(type: BlogBlockType.heading, text: "Critères de choix"),
      BlogContentBlock(
        type: BlogBlockType.list,
        structuredListItems: [
          {
            'title': 'Le Poids (Oz)',
            'desc': '10oz pour la compétition, 14-16oz pour l\'entraînement.',
          },
          {
            'title': 'La Matière',
            'desc':
                'Cuir véritable pour la durabilité, synthétique pour débuter.',
          },
          {
            'title': 'Le maintien',
            'desc': 'Une bonne protection du poignet est indispensable.',
          },
        ],
      ),
      BlogContentBlock(
        type: BlogBlockType.quoteWithAuthor,
        text:
            "Vos mains sont vos armes, protégez-les avec le meilleur équipement possible.",
        secondaryText: "- Coach Ali",
      ),
    ],
  ),

  // 6. Motivation
  BlogArticle(
    id: '6',
    category: 'Motivation',
    readTime: '4 min',
    title: 'Surmonter la baisse de motivation hivernale',
    subtitle: 'Astuces mentales pour rester constant quand il fait froid.',
    author: 'Coach Yasmine',
    date: '01 Déc 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1552674605-46d526d2e308?q=80&w=2069&auto=format&fit=crop',
    content: [
      BlogContentBlock(
        type: BlogBlockType.paragraph,
        text:
            "L'hiver est la période la plus difficile pour maintenir sa routine. Le froid et la nuit précoce sont des ennemis de la motivation.",
      ),
      BlogContentBlock(
        type: BlogBlockType.heading,
        text: "5 Astuces Anti-Froid",
      ),
      BlogContentBlock(
        type: BlogBlockType.list,
        listItems: [
          "Préparez votre sac la veille",
          "Trouvez un partenaire d'entraînement (gym buddy)",
          "Fixez-vous un objectif de printemps",
          "Achetez une nouvelle tenue de sport",
          "Rappelez-vous pourquoi vous avez commencé",
        ],
      ),
    ],
  ),
];
