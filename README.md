# \\[^_^]/ Tolva's Dotfiles

This repository serves as my way to help me setup and maintain my Mac. It takes the effort out of installing everything manually. Everything which is needed to install my preffered setup of macOS is detailed in this readme. Feel free to explore, learn and copy parts for your own dotfiles. Enjoy! :smile:

## Pourquoi voudrais-je que mes dotfiles soient sur GitHub

- **Sauvegardez**, restaurez et synchronisez les préférences et paramètres de votre boîte à outils. Vos fichiers dotfiles peuvent être les fichiers les plus importants sur votre machine.
- **Apprendre** de la communauté. Découvrez de nouveaux outils pour votre boîte à outils et de nouveaux trucs pour ceux que vous utilisez déjà.
- **Partagez** ce que vous avez appris avec nous.

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

Vous pouvez également utiliser `~/bashrc.d/.extra` pour remplacer les paramètres, fonctions et alias de mon référentiel dotfiles. Il vaut probablement mieux [dupliquer ce référentiel](https://github.com/deild/dotfiles/fork) à la place.

## LICENSE

[![MIT](https://img.shields.io/badge/license-MIT-BLUE)](LICENSE)
