# \\[^_^]/ Bienvenue. Heureux de vous voir ici et merci pour votre intérêt

## ¯\\(ツ)/¯ Attention

Avertissement : Si vous voulez essayer ces _dotfiles_, vous devez d'abord dupliquer ce référentiel, revoir le code, et supprimer les choses que vous ne voulez pas ou dont vous n'avez pas besoin. N'utilisez pas aveuglément mes réglages à moins de savoir ce que cela implique. Utilisez les à vos risques et périls !

### \\[._.]/ Utilisation de Git et du script bootstrap

**Remarque** Si vous n'avez pas déjà installé Xcode ou Command Line Tools, utilisez `xcode-select --install` pour les télécharger et les installer depuis Apple.

j'utiliser Homebrew pour faciliter l'installation des logiciels et mettre à jour les outils de l'espace utilisateur.

Vous pouvez cloner le référentiel où vous voulez. Le script de bootstrap tirera la dernière version et copiera les fichiers dans votre dossier personnel.

```bash
git clone https://github.com/deild/dotfiles.git && cd dotfiles && . bootstrap.sh
```

Pour mettre à jour, `cd` dans votre dépôt local `dotfiles` et ensuite :

```bash
. bootstrap.sh
```

Alternativement, pour mettre à jour tout en évitant l'invite de confirmation :

```bash
set -- -f; . bootstrap.sh
```

### \\[._.]/ Installer les formules Homebrew

Lors de la configuration d'un nouveau Mac, vous voudrez peut-être installer certaines formules [Homebrew](https://brew.sh/) courantes (après l'installation de Homebrew, bien sûr) :

```bash
./brew.sh
```

Certaines des fonctionnalités de ces _dotfiles_ dépendent des formules installées par `brew.sh`. Si vous n'avez pas l'intention d'exécuter `brew.sh`, vous devriez parcourir attentivement le script et installer manuellement celles qui sont particulièrement importantes. Un bon exemple est la complétion Bash/Git : les dotfiles utilisent une version spéciale de Homebrew.

### \\[._.]/ Spécifiez le `$PATH`

Si `~/bashrc.d/.path` existe, il sera source avec les autres fichiers, avant tout test de fonctionnalité a lieu (comme détecter quelle version de `ls` utilisée).

Voici un exemple de fichier `~/bashrc.d/.path` qui ajoute `/usr/local/bin` au `$PATH` :

```bash
export PATH="/usr/local/bin:$PATH"
```

### \\[._.]/ Ajouter des commandes personnalisées sans créer un nouveau fork

Si `~/bashrc.d/.extra` existe, il sera source avec les autres fichiers. Vous pouvez l'utiliser pour ajouter quelques commandes personnalisées sans avoir besoin de dupliquer tout le référentiel, ou pour ajouter des commandes que vous ne voulez pas livrer dans un référentiel public.

Mon `~/bashrc.d/.extra` ressemble à ceci :

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Tolvä"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="tolva@gmail.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

Vous pouvez également utiliser `~/bashrc.d/.extra` pour remplacer les paramètres, fonctions et alias de mon référentiel dotfiles. Il vaut probablement mieux [dubliquer ce référentiel](https://github.com/deild/dotfiles/fork) à la place.

### \\[._.]/ Paramètres par défaut raisonnables de macOS

Lors de la configuration d'un nouveau Mac, il est possible que vous souhaitiez définir des valeurs par défaut raisonnables des paramètres de macOS :

```bash
. .macos
```
