pipeline {
    agent any
    environment {
        DEPLOY_DIR = '/var/lib/jenkins/grocery-webapp'
    }
    stages {
        stage('Toolchain') {
            steps {
                sh '''
                    if ! command -v python3 >/dev/null 2>&1; then
                        sudo apt-get update && sudo apt-get install -y python3 python3-venv python3-pip
                    fi
                    if ! python3 -c "import venv" >/dev/null 2>&1; then
                        sudo apt-get update && sudo apt-get install -y python3-venv
                    fi
                '''
            }
        }
        stage('Deploy backend') {
            steps {
                withCredentials([string(credentialsId: 'grocery-webapp-db-password', variable: 'DB_PASSWORD')]) {
                    sh '''
                        mkdir -p "$DEPLOY_DIR/backend"
                        rsync -a --delete --exclude='__pycache__' backend/ "$DEPLOY_DIR/backend/"

                        if [ ! -d "$DEPLOY_DIR/venv" ]; then
                            python3 -m venv "$DEPLOY_DIR/venv"
                        fi
                        "$DEPLOY_DIR/venv/bin/pip" install -q -r "$DEPLOY_DIR/backend/requirements.txt"

                        cat > "$DEPLOY_DIR/grocery-webapp.env" <<EOF
DB_HOST=192.168.1.241
DB_USER=grocery_webapp
DB_PASSWORD=${DB_PASSWORD}
DB_NAME=grocery_store
EOF
                        chmod 600 "$DEPLOY_DIR/grocery-webapp.env"
                        sudo cp --preserve=mode "$DEPLOY_DIR/grocery-webapp.env" /etc/grocery-webapp.env

                        cat > "$DEPLOY_DIR/grocery-webapp.service" <<EOF
[Unit]
Description=Grocery Store Management Flask backend
After=network.target mysql.service

[Service]
Type=simple
User=jenkins
WorkingDirectory=$DEPLOY_DIR/backend
EnvironmentFile=/etc/grocery-webapp.env
ExecStart=$DEPLOY_DIR/venv/bin/python3 $DEPLOY_DIR/backend/server.py
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
                        sudo cp "$DEPLOY_DIR/grocery-webapp.service" /etc/systemd/system/grocery-webapp.service
                        sudo systemctl daemon-reload
                        sudo systemctl enable --now grocery-webapp
                        sudo systemctl restart grocery-webapp
                    '''
                }
            }
        }
        stage('Deploy frontend') {
            steps {
                sh '''
                    mkdir -p /var/www/html/grocery-webapp
                    rsync -a --delete ui/ /var/www/html/grocery-webapp/
                '''
            }
        }
    }
}
