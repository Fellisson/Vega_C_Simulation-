# Vega Simulations

## Cadre du travail

Le present dossier constitue une base structuree de simulation numerique et d'analyse consacree a l'etude du comportement dynamique d'un vehicule propulse en trois dimensions, dans un cadre inspire du lanceur Vega-C. Il integre un modele numerique avec regulation d'attitude par correcteur PID, un outil de comparaison entre les configurations avec et sans commande, ainsi qu'une prise en compte plus realiste du vent par la vitesse relative de l'air.

L'ensemble a ete organise dans une perspective academique afin de servir d'appui a la redaction d'un memoire, a l'exploitation de resultats quantitatifs et a la production de figures et tableaux directement mobilisables dans un document scientifique.

## Objet scientifique

Le travail vise principalement a etudier l'influence d'une commande en boucle fermee sur la stabilite et la precision du vol propulse. Dans cette perspective, deux dimensions complementaires sont prises en compte :

1. la modelisation du lanceur et de sa dynamique de vol ;
2. l'evaluation comparative des performances du systeme avec et sans correcteur PID.

Le modele retenu cherche ainsi a conserver un bon niveau de lisibilite tout en offrant une representation suffisamment riche pour analyser :
- l'evolution de l'attitude ;
- la variation de masse ;
- la trajectoire tridimensionnelle ;
- la phase de separation simplifiee de la charge utile ;
- l'effort de commande applique au lanceur ;
- l'effet de perturbations aerodynamiques plus realistes.

## Structure du dossier

```text
Vega Simulations/
|- src/
|  |- controle_pid/
|  |  `- modele_vega_PID_ok.m
|  `- comparaison/
|     |- compare_pid_vs_no_pid.m
|     `- sweep_pid_gains_to_excel.m
|- out/
|  |- blender/
|  |- images/
|  |- logs/
|  `- videos/
|- docs/
|  |- figures/
|  |- tableaux/
|  |- memoire_vega.docx
|  |- memoire_vega_v2.docx
|  `- legendes_memoire.txt
|- README.md
`- README_memoire_universitaire.md
```

## Fonction des composantes principales

### 1. Modele principal

Le fichier `src/controle_pid/modele_vega_PID_ok.m` constitue le noyau de la simulation. Il implemente un modele tridimensionnel de lanceur inspire du profil Vega-C avec :
- une dynamique simplifiee de translation et de rotation ;
- une evolution de la masse au cours des etages de vol ;
- une commande d'attitude par PID sur les axes de roulis, tangage et lacet ;
- une prise en compte du vent a travers la vitesse relative de l'air ;
- des fonctions d'export de diagnostics, de journaux et de fichiers annexes.

Ce modele n'a pas vocation a reproduire integralement le comportement industriel d'un systeme de lancement reel. Il s'inscrit dans une logique de modelisation scientifique simplifiee, permettant de mettre en evidence l'effet de la regulation sur la stabilite du vol.

### 2. Script de comparaison

Le fichier `src/comparaison/compare_pid_vs_no_pid.m` assure la comparaison entre une simulation avec PID actif et une simulation sans PID. Il produit des indicateurs quantitatifs relatifs :
- au temps de montee ;
- au depassement maximal ;
- au temps d'etablissement ;
- a l'erreur statique ;
- a la valeur RMS de l'erreur ;
- a l'effort de commande ;
- aux indicateurs globaux de mission.

Le script genere egalement des tableaux, des figures comparatives, une synthese textuelle et un classeur Excel contenant les donnees utiles a l'analyse.

### 3. Script de balayage des gains

Le fichier `src/comparaison/sweep_pid_gains_to_excel.m` automatise une etude de sensibilite des gains PID. Il lance plusieurs simulations avec des jeux de gains differents, puis exporte un tableau recapitulatif dans un fichier Excel exploitable pour l'analyse comparative.

## Figures de reference

Les figures de reference du projet correspondent directement aux sorties reelles generees dans `out/images/` par les scripts de simulation.

### 1. Figure de comparaison globale avec et sans PID

Fichier :
- `out/images/compare_pid_dashboard.png`

Cette figure offre une vue synthetique de la trajectoire, de l'altitude, du tangage, de l'erreur de suivi et de l'effort de commande. Elle permet d'apprecier rapidement l'effet du correcteur PID sur la dynamique globale du lanceur.

### 2. Figure de diagnostic PID

Fichier :
- `out/images/modele_vega_PID_ok_pid.png`

Cette figure presente les references d'attitude, les angles reels et les efforts de commande associes aux axes de roulis, de tangage et de lacet. Elle permet d'evaluer la qualite du suivi de consigne et le niveau de sollicitation du correcteur.

### 3. Figure de diagnostic du vent

Fichier :
- `out/images/modele_vega_PID_ok_wind.png`

Cette figure montre les composantes du vent et les moments aerodynamiques perturbateurs associes. Elle permet de relier la reponse du systeme aux perturbations appliquees dans le modele avec vent realiste.

### 4. Tableau image des performances en tangage

Fichier :
- `out/images/compare_pid_pitch_table.png`

Cette figure presente les indicateurs de performance du tangage sous forme directement inserable dans un memoire : temps de montee, depassement maximal, temps d'etablissement, erreur statique, erreur RMS et effort de commande RMS.

### 5. Tableau image des indicateurs de mission

Fichier :
- `out/images/compare_pid_mission_table.png`

Cette figure rassemble les grandeurs globales de mission, notamment le temps de vol, la portee, l'altitude maximale, la vitesse maximale et le temps de separation du satellite.

## Tableaux et sorties quantitatives

Les resultats quantitatifs de reference sont exportes dans `out/logs/`. Le dossier `docs/tableaux/` contient, quant a lui, des copies ou mises en forme utiles pour le memoire.

### Tableaux principaux

- `out/logs/compare_pid_pitch_table.csv`
- `out/logs/compare_pid_pitch_table.txt`
- `out/logs/compare_pid_mission_table.csv`
- `out/logs/compare_pid_mission_table.txt`
- `out/logs/compare_pid_vs_no_pid.xlsx`

Ces fichiers permettent de documenter quantitativement la comparaison entre la configuration avec PID et la configuration sans PID.

### Tableaux de reglage et de sweep PID

- `docs/tableaux/tableau_choix_gains_pid.xlsx`
- `docs/tableaux/tableau_choix_gains_pid.docx`
- `docs/tableaux/tableau_recap_sweep_pid.xlsx`
- `docs/tableaux/tableau_recap_sweep_pid.docx`
- `out/logs/pid_gain_sweep.xlsx`
- `out/logs/pid_gain_sweep_summary.csv`

Ces documents servent a justifier le choix final des gains et a comparer plusieurs reglages possibles.

## Resultats de reference avec vent realiste

Dans la version actuelle du modele, le vent est introduit par la vitesse relative entre le lanceur et l'air environnant. Avec cette formulation et avec le reglage PID final retenu, les performances principales obtenues sur l'axe de tangage sont les suivantes :

- temps de montee : `131 s` ;
- depassement maximal : `0.127 %` ;
- temps d'etablissement : `152.5 s` ;
- erreur statique : `-0.051 deg` ;
- erreur RMS en tangage avec PID : `1.999 deg` ;
- erreur RMS en tangage sans PID : `34.737 deg` ;
- gain sur la RMS : environ `94.25 %`.

Ces resultats montrent que le correcteur PID ameliore tres fortement la precision du suivi tout en conservant une reponse bien amortie, meme en presence de perturbations aerodynamiques plus realistes.

## Equations mathematiques et physiques du modele

Le modele repose sur un couplage entre la dynamique de translation, la dynamique de rotation, l'aerodynamique et la commande PID.

### 1. Equations de translation

La position du lanceur evolue a partir de la vitesse selon :

\[
\dot{x} = v_x,\qquad \dot{y} = v_y,\qquad \dot{z} = v_z
\]

L'acceleration du vehicule est calculee a partir de la poussee, de la trainee aerodynamique et de la gravite :

\[
\mathbf{a} = \frac{\mathbf{T}_{world} - \mathbf{D}}{m} - \begin{bmatrix}0\\0\\g\end{bmatrix}
\]

ou \(m\) est la masse instantanee, \(\mathbf{T}_{world}\) la poussee exprimee dans le repere inertiel, \(\mathbf{D}\) la trainee et \(g\) l'acceleration de la pesanteur.

La poussee est appliquee suivant l'axe longitudinal du lanceur puis projetee dans le repere inertiel :

\[
\mathbf{T}_{world} = R(\psi,\theta,\phi)\begin{bmatrix}0\\0\\T\end{bmatrix}
\]

### 2. Atmosphere, vent et trainee

La densite de l'air est modelisee par une loi exponentielle :

\[
\rho(z) = \rho_0 \exp\left(-\frac{z}{h_{scale}}\right)
\]

Le vent est introduit a travers la vitesse relative entre le lanceur et la masse d'air :

\[
\mathbf{V}_{rel} = \mathbf{V} - \mathbf{V}_{air}
\]

avec :

\[
\mathbf{V} = \begin{bmatrix}v_x\\v_y\\v_z\end{bmatrix}
\]

La trainee aerodynamique est alors calculee par :

\[
\mathbf{D} = \frac{1}{2}\rho C_d S \|\mathbf{V}_{rel}\| \mathbf{V}_{rel}
\]

ou \(C_d\) est le coefficient de trainee et \(S\) la surface de reference.

### 3. Equations de rotation

La dynamique rotationnelle est formulee a partir du vecteur vitesse angulaire :

\[
\boldsymbol{\omega} = \begin{bmatrix}p\\q\\r\end{bmatrix}
\]

L'equation d'Euler du solide rigide utilisee dans le modele s'ecrit :

\[
I\dot{\boldsymbol{\omega}} = \boldsymbol{\tau} - \boldsymbol{\omega}\times(I\boldsymbol{\omega}) - c_w\boldsymbol{\omega}
\]

ou \(I\) est la matrice d'inertie, \(\boldsymbol{\tau}\) le couple total applique et \(c_w\boldsymbol{\omega}\) un terme d'amortissement simplifie.

Le couple total comprend le couple de commande et le couple perturbateur du vent :

\[
\boldsymbol{\tau} =
\begin{bmatrix}
M_x\\
M_y\\
M_z
\end{bmatrix}
+ \boldsymbol{\tau}_{wind}
\]

Le couple de vent est modelise par :

\[
\boldsymbol{\tau}_{wind} = \mathbf{r}_{cp}\times\mathbf{F}_{lat}
\]

La pression dynamique associee vaut :

\[
q_{dyn} = \frac{1}{2}\rho \|\mathbf{V}_{rel}\|^2
\]

### 4. Cinematique d'attitude

L'attitude est decrite par les angles d'Euler \((\phi,\theta,\psi)\), correspondant respectivement au roulis, au tangage et au lacet. Leur evolution est obtenue a partir des vitesses angulaires :

\[
\dot{\mathbf{eul}} = T(\phi,\theta)\boldsymbol{\omega}
\]

avec :

\[
\mathbf{eul} = \begin{bmatrix}\phi\\\theta\\\psi\end{bmatrix}
\]

### 5. Loi de commande PID

Pour un axe donne, l'erreur de suivi est definie par :

\[
e(t) = \theta_{ref}(t) - \theta(t)
\]

La loi PID generale s'ecrit :

\[
u(t) = k_p e(t) + k_i \int e(t)\,dt + k_d \frac{de(t)}{dt}
\]

Dans l'implementation retenue, le terme derive est applique sur une mesure filtree, ce qui conduit a une expression du type :

\[
M = k_p e + k_i I - k_d \dot{\theta}_{filtre}
\]

La commande est ensuite soumise a saturation :

\[
M_{sat} = \mathrm{clamp}(M, -M_{max}, M_{max})
\]

### 6. Integration numerique

L'ensemble du modele est integre au moyen d'un schema d'Euler explicite :

\[
x_{k+1} = x_k + \dot{x}_k \Delta t
\]

Ce choix numerique permet de conserver une formulation lisible et suffisante pour l'analyse comparative du comportement du lanceur avec et sans commande PID.

## Portee scientifique et limites

Les resultats issus de ce dossier doivent etre compris comme des resultats de simulation numerique a finalite analytique et pedagogique. Ils permettent d'evaluer l'influence du correcteur PID sur la qualite du suivi d'attitude, en particulier sur l'axe de tangage, tout en conservant une representation interpretable du systeme.

Plusieurs simplifications ont ete retenues dans la construction du modele :
- atmosphere simplifiee ;
- trainee aerodynamique modelisee globalement ;
- absence de mecanique orbitale detaillee ;
- commande exprimee sous forme de moments equivalents ;
- absence de modele d'actionneur complet ;
- guidage d'attitude simplifie.

Ces choix permettent de conserver un cadre d'analyse lisible, mais imposent de limiter l'interpretation des resultats a une logique d'ordre de grandeur et non de prediction operationnelle.

## Utilisation recommandee

Dans MATLAB, il est recommande d'ajouter les chemins suivants :

```matlab
cd('D:\MATLAB\Vega Simulations')
addpath(fullfile(pwd,'src','controle_pid'))
addpath(fullfile(pwd,'src','comparaison'))
```

Executer ensuite :

```matlab
[data, metrics] = modele_vega_PID_ok('no_render');
results = compare_pid_vs_no_pid('no_render');
results = sweep_pid_gains_to_excel('no_render');
```

## Conclusion

Le dossier `Vega Simulations` constitue ainsi une base de travail organisee pour l'analyse du controle d'attitude d'un lanceur simplifie inspire de Vega-C. Par sa structuration, il facilite a la fois l'exploitation numerique, la comparaison des performances avec et sans PID, l'analyse de robustesse face au vent realiste et l'integration des resultats dans un cadre de redaction universitaire.
