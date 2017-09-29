#!/bin/bash

set -e

SRC_DOC_NOSLASH="/srv/data/html/docnotice"
SRC_VIGN_NOSLASH="/srv/data/html/vignettenotice"
SRC_DOC_NOSLASH_KAIN=""
SRC_VIGN_NOSLASH_KAIN=""
#SRC_DOC_NOSLASH_KAIN="/srv/data/html/docnotice-kain"
#SRC_VIGN_NOSLASH_KAIN="/srv/data/html/vignettenotice-kain"

BACKUP_DIR="/srv/backup/files/srv/data/html/"

rsync -avh --delete ${SRC_DOC_NOSLASH} ${SRC_VIGN_NOSLASH} ${SRC_DOC_NOSLASH_KAIN} ${SRC_VIGN_NOSLASH_KAIN} ${BACKUP_DIR}


