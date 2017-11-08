node {
  //
  def pullRequest = false
  //
  git url: "https://github.com/attlas/attlas-portal.git"
  sh '''git submodule init'''
  sh '''git submodule update'''
  if (params.containsKey('sha1')){
    pullRequest = true
    echo "Pull request build sha1: ${sha1}"
    sh '''git fetch --tags --progress origin +refs/pull/*:refs/remotes/origin/pr/*'''
    sh '''git checkout ${ghprbActualCommit}'''
  }else{
    echo "Build default branch"
  }
  //
  //def groupId = sh(returnStdout: true, script:'''mvn help:evaluate -Dexpression=project.groupId | grep -e "^[^\\[]"''').trim()
  //def artifactId = sh(returnStdout: true, script:'''pushd bundle > /dev/null && mvn help:evaluate -Dexpression=project.artifactId | grep -e "^[^\\[]" && popd > /dev/null''').trim()
  //def version = sh(returnStdout: true, script:'''mvn help:evaluate -Dexpression=project.version | grep -e "^[^\\[]"''').trim()
  //echo "groupId: ${groupId} artifactId: ${artifactId} version: ${version}"

  def repo = sh(returnStdout: true, script:'''git config --get remote.origin.url | rev | awk -F'[./:]' '{print $2}' | rev''').trim()
  def org = sh(returnStdout: true, script:'''git config --get remote.origin.url | rev | awk -F'[./:]' '{print $3}' | rev''').trim()
  echo "org: ${org} repo: ${repo}"
  //
  sh '''cp ./.env.template ./.env'''
  //sh '''sed -i "/SERVICE_PORT=/ s/=.*/=8182/" ./.env'''

  //load "./.env"

//          sed -i "/COMPOSE_PROJECT_NAME=/ s/=.*/=$COMPOSE_PROJECT_NAME/" ./.env
//          sed -i "/SERVICE_DOMAIN=/ s/=.*/=$SERVICE_DOMAIN/" ./.env
//          sed -i "/SERVICE_DOMAIN_EMAIL=/ s/=.*/=$SERVICE_DOMAIN_EMAIL/" ./.env
//          sed -i "/SERVICE_ID=/ s/=.*/=$SERVICE_ID/" ./.env
//          sed -i "/SERVICE_DESC=/ s/=.*/=\\"$SERVICE_DESC\\"/" ./.env
    sh '''cat ./.env'''
    //
    echo sh(returnStdout: true, script: 'env')
    stage('Build & Unit tests') {
      sh './build.sh'
    }
    //
    stage('SonarQube analysis') {
      def scannerHome = tool 'SonarQube Scanner 3.0.3';
      withSonarQubeEnv('Attlas SonarQube instance') {
        if (pullRequest){
          sh "${scannerHome}/bin/sonar-scanner -Dsonar.analysis.mode=preview -Dsonar.github.pullRequest=${ghprbPullId} -Dsonar.github.repository=${org}/${repo} -Dsonar.github.oauth=${GITHUB_ACCESS_TOKEN} -Dsonar.login=${SONARQUBE_ACCESS_TOKEN}"
        } else {
          sh "${scannerHome}/bin/sonar-scanner"
        }
      }
    }
    stage('Up') {
      //sh './service-up.sh -d'
    }
    stage('Deploy & Publish') {
      //sh './service-deploy.sh'
      //archiveArtifacts artifacts: 'mobile/platforms/android/build/outputs/apk/*.apk'
    }
    stage('Cleanup') {
      echo 'Cleanup'
    }
}
