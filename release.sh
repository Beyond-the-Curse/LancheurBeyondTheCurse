#!/bin/bash

# Script de release automatique pour BeyondTheCurse Launcher
# Usage: ./release.sh [version] [message]

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérifier les arguments
if [ $# -eq 0 ]; then
    log_error "Usage: $0 <version> [commit_message]"
    log_info "Exemple: $0 1.2.3 \"Nouvelle version avec corrections de bugs\""
    exit 1
fi

VERSION=$1
COMMIT_MESSAGE=${2:-"Release version $VERSION"}

# Vérifier le format de version (semver)
if [[ ! $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    log_error "Format de version invalide. Utilisez le format semver (ex: 1.2.3)"
    exit 1
fi

# Vérifier que nous sommes sur la branche main
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
    log_warn "Vous n'êtes pas sur la branche main/master. Branche actuelle: $CURRENT_BRANCH"
    read -p "Continuer quand même? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Release annulée"
        exit 1
    fi
fi

# Vérifier que le repo est propre
if [ -n "$(git status --porcelain)" ]; then
    log_error "Le repository contient des modifications non commitées"
    git status --short
    exit 1
fi

# Vérifier que nous sommes à jour avec origin
log_info "Synchronisation avec origin..."
git fetch origin

if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
    log_error "La branche locale n'est pas synchronisée avec origin"
    log_info "Exécutez: git pull origin $CURRENT_BRANCH"
    exit 1
fi

# Vérifier que le tag n'existe pas déjà
if git tag -l | grep -q "^v$VERSION$"; then
    log_error "Le tag v$VERSION existe déjà"
    exit 1
fi

# Mettre à jour la version dans package.json
log_info "Mise à jour de la version dans package.json..."
npm version $VERSION --no-git-tag-version

# Construire l'application pour vérifier qu'il n'y a pas d'erreurs
log_info "Test de build..."
npm run build

# Commiter les changements de version
log_info "Commit des changements de version..."
git add package.json package-lock.json
git commit -m "chore: bump version to $VERSION"

# Créer le tag
log_info "Création du tag v$VERSION..."
git tag -a "v$VERSION" -m "$COMMIT_MESSAGE"

# Pousser les changements et le tag
log_info "Push vers origin..."
git push origin $CURRENT_BRANCH
git push origin "v$VERSION"

log_info "✅ Release v$VERSION créée avec succès!"
log_info "🚀 GitHub Actions va maintenant construire et publier la release"
log_info "📦 Surveillez: https://github.com/YOUR_USERNAME/YOUR_REPO/actions"

# Ouvrir la page des actions GitHub (optionnel)
read -p "Ouvrir la page GitHub Actions? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Récupérer l'URL du repo
    REPO_URL=$(git config --get remote.origin.url | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')
    open "$REPO_URL/actions" 2>/dev/null || xdg-open "$REPO_URL/actions" 2>/dev/null || log_info "Impossible d'ouvrir automatiquement: $REPO_URL/actions"
fi