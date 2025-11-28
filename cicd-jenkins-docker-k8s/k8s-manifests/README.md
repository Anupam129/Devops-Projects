CI/CD Pipeline for Dockerized Applications


Step-by-Step Guide: CI/CD Pipeline for Dockerized Node.js App Using Jenkins


Step 0: Connect to EC2

ssh -i your-key.pem ubuntu@your-ec2-public-ip

Step 1: Update Ubuntu and Install Required Packages

sudo apt update -y

sudo apt upgrade -y

sudo apt install -y git curl wget unzip

Step 2: Install Node.js (v18)

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

sudo apt install -y nodejs

# Verify installation


node -v
npm -v
Expected: Node.js v18.x, npm v8.x

Step 3: Install Docker

sudo apt install -y docker.io

sudo systemctl start docker

sudo systemctl enable docker

sudo usermod -aG docker $USER

Log out and log back in to apply the Docker group change.

docker --version

Expected: Docker v20.x+

Step 4: Install Jenkins

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt update -y

sudo apt install -y openjdk-11-jdk jenkins


sudo systemctl start jenkins

sudo systemctl enable jenkins

sudo systemctl status jenkins

•	Access Jenkins: http://your-ec2-public-ip:8080

•	Use initial admin password:

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

•	Install suggested plugins and create admin user.

Step 5: Prepare GitHub Repository (sample-app)

Your repo structure:

sample-app/

├── index.js

├── package.json

├── package-lock.json  # auto-generated after npm install

├── Dockerfile


└── Jenkinsfile
________________________________________


index.js

const express = require('express');

const app = express();

const PORT = 3000;


app.get('/', (req, res) => {
  res.send('Hello from Dockerized Node.js App!');
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
________________________________________
package.json
{
  "name": "sample-app",
  "version": "1.0.0",
  "description": "Sample Node.js app for Docker CI/CD",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
________________________________________

Dockerfile

FROM node:18

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "index.js"]

________________________________________

Jenkinsfile
pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "pavanikoduru22/sample-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Pavanikoduru/sample-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE:latest'
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deployment stage - run your Docker container or Kubernetes deployment'
            }
        }
    }

    post {
        success {
            echo 'Dockerized CI/CD Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
________________________________________


Step 6: Push Repo to GitHub
cd sample-app

npm install       # generates package-lock.json

git init
git add .
git commit -m "Initial commit: Node.js app with Dockerfile & Jenkinsfile"

git remote add origin https://github.com/Pavanikoduru/sample-app.git

git branch -M main

git push -u origin main

Step 7: Add DockerHub Credentials in Jenkins

1.	Jenkins Dashboard → Manage Jenkins → Credentials → System → Global credentials → Add Credentials
o	Kind: Username with password

o	Username: anupam129

o	Password: **********

o	ID: dockerhub-creds

3.	Add GitHub Credentials (Optional if private repo)
   
o	Username: anupam129

o	Password: *************
________________________________________
Step 8: Create Jenkins Pipeline Job

1.	New Item → Pipeline → OK
  
2.	Pipeline definition:

o	Pipeline script from SCM
o	SCM: Git

o	Repository URL: https://github.com/anupam129/ Devops-Projects
o	Credentials: GitHub Devops-Projects
o	Branch: main
6.	Save → Build Now
________________________________________

Step 9: Verify Pipeline Execution

Pipeline stages will run:


1.	Checkout → GitHub repo cloned
   
3.	Build Docker Image → docker build -t anupam129/ Devops-Projects-app:latest .
   
5.	Push Docker Image → Pushed to DockerHub
   
7.	Deploy Stage → Placeholder, you can run the container manually
   
________________________________________
Step 10: Manual Deployment (Optional)

docker pull anupam129/sample-app:latest

docker run -d -p 3000:3000 anupam129/sample-app:latest

Check app in browser: http://your-ec2-public-ip:3000 → Should show "Hello from Dockerized Node.js App!"



