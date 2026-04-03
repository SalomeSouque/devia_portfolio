COMMENT UTILISER LES AGENTS
════════════════════════════

DÉMARRER UNE SESSION
─────────────────────  
Si tu reprends après une pause, commence par :  

  [SYNC] Voici mon progress.txt : [colle le contenu]  
  On a fait X lors de la dernière session. Mets-le à jour  
  et génère le contexte pour continuer.  

Claude te rend un progress.txt mis à jour + un résumé  
à copier en début de prochaine conversation.  


PENDANT LE DÉVELOPPEMENT
─────────────────────────  
Utilise le préfixe selon ce que tu veux faire :  
  
  [ARCH]    → "Comment je dois organiser mes types TypeScript ?"  
  [FRONT]   → "Crée le composant ProjectCard avec filtres"
  [BACK]    → "Écris la requête pour récupérer les projets par locale et catégorie"
  [INFRA]   → "Génère le docker-compose complet avec volumes et healthchecks"  
  [CI]      → "Crée le pipeline GitHub Actions pour déployer en SSH"  
  [QA]      → "Comment je teste ce Server Action ?"  
  [GIT]     → "Génère le message de commit pour ce que je viens de faire"  
  [DOC]     → "Transforme ce qu'on vient de faire en note de cours"  
  [CONTENT] → "Rédige la description du projet X en FR et EN"  
  [SEED]    → "Génère le script add-project.js"  
  [UX]      → "Ce composant respecte-t-il le design Figma ?"  

Sans préfixe → Claude choisit le bon angle tout seul.  
C'est bien pour les questions générales.  


FIN DE SESSION
───────────────  
  [SYNC] On vient de faire [résumé]. Mets à jour le progress.txt  
  [GIT]  Génère le message de commit pour cette session  


COMBINER LES AGENTS
────────────────────  
Tu peux en appeler plusieurs dans un même message :  

  [BACK] puis [QA] : écris la requête ET son test unitaire  
  [FRONT] puis [DOC] : crée le composant ET la note de cours  


CONSEIL
────────  
Au début, appelle [DOC] souvent. Ça crée des notes  
personnalisées sur ce que tu viens d'apprendre.  
C'est ton meilleur outil pour vraiment progresser.  