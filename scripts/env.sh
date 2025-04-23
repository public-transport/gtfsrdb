# env.sh

# Start from the directory where the script is located
PROJECT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

# Search for README.md by moving up the directory tree
while [ ! -f "$PROJECT_DIR/README.md" ] && [ "$PROJECT_DIR" != "/" ]; do
    PROJECT_DIR="$(dirname "$PROJECT_DIR")"
done

# If we reach the root without finding README.md, set PROJECT_DIR to the original directory
if [ "$PROJECT_DIR" = "/" ]; then
    PROJECT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"
fi

export PROJECT_DIR
export DB_HOST="10.5.0.2"
export DB="ott"
export DB_USER="ott"
export DB_PASS="ott"