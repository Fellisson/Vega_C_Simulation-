## 3. Methodologie

L'etude repose sur une simulation numerique sous MATLAB appliquee a un modele tridimensionnel de lanceur inspire de Vega-C. Le modele principal, implemente dans `modele_vega_PID_ok.m`, decrit la dynamique de translation et de rotation du vehicule, la variation de masse au cours des phases propulsees et une commande d'attitude par correcteur PID sur les axes de roulis, de tangage et de lacet.

Dans la version actualisee du travail, un modele de vent plus realiste a ete introduit. Le vent n'est plus represente comme une simple force additive arbitraire, mais a travers une vitesse d'air locale dependant de l'altitude et du temps. Les efforts aerodynamiques sont alors calcules a partir de la vitesse relative entre le lanceur et la masse d'air environnante. Cette formulation permet egalement de deduire des moments perturbateurs aerodynamiques, en plus des effets sur la trainee.

Afin d'evaluer l'apport de la commande, une comparaison entre la configuration avec PID et la configuration sans PID a ete effectuee a l'aide du script `compare_pid_vs_no_pid.m`. Les indicateurs retenus sont le temps de montee, le depassement maximal, le temps d'etablissement, l'erreur statique, la valeur RMS de l'erreur et l'effort de commande RMS. Des indicateurs globaux de mission sont egalement extraits, notamment le temps de vol, la portee, l'altitude maximale et le temps de separation du satellite.

L'ensemble des sorties est exporte sous forme de figures, de journaux texte, de tableaux CSV et d'un classeur Excel. Le dossier `docs/` contient les versions directement exploitables dans le memoire, tandis que le dossier `out/` regroupe les resultats bruts de simulation.

## 4. Resultats et discussion

Les resultats obtenus avec le modele de vent realiste montrent que la commande PID conserve un effet tres favorable sur le suivi en tangage. Le tableau comparatif des performances indique qu'avec PID, le temps de montee est de 131 s, le depassement maximal est limite a 0.127 % et le temps d'etablissement est de 152.5 s. Ces valeurs montrent que la reponse est a la fois amortie et stabilisee malgre les perturbations introduites par le vent.

L'erreur statique obtenue avec PID vaut -0.051 deg, ce qui signifie que la consigne de tangage est pratiquement atteinte sans biais final significatif. L'indicateur le plus representatif reste toutefois l'erreur RMS, qui passe de 34.737 deg sans PID a 1.999 deg avec PID. Cette reduction correspond a un gain d'environ 94.25 %, ce qui confirme l'efficacite du correcteur dans le nouveau contexte aerodynamique.

L'effort de commande RMS est de 84444 N.m avec PID. Cette valeur traduit une commande active bien reelle, mais elle reste compatible avec le cadre de simulation retenu. A l'inverse, la configuration sans PID presente un effort nul par construction, ce qui rend la comparaison en pourcentage peu interpretable sur cette seule grandeur.

Ces resultats montrent que le nouveau reglage du tangage est plus robuste que le precedent. Le depassement devient presque nul, l'erreur statique est pratiquement annulee et le temps d'etablissement devient defini, ce qui n'etait pas garanti avec les reglages anterieurs sous vent realiste. Le systeme en boucle fermee ne se contente donc plus de reduire l'erreur globale ; il fournit egalement une reponse mieux amortie et plus stable.

D'un point de vue scientifique, cette mise a jour renforce la credibilite du modele. L'introduction d'un vent formule a partir de la vitesse relative de l'air rapproche la simulation d'un cadre aerodynamique plus coherent, tout en montrant que la commande PID demeure performante dans un environnement de vol plus exigeant. Les figures et tableaux issus de cette nouvelle campagne de simulation constituent ainsi une base plus solide pour l'analyse presentee dans le memoire.

