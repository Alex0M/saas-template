node {
  //
  def pullRequest = false
  //
  git url: "${GITHUB_REPOSITORY}"
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
  //sh '''cat ./.env'''
  //
  echo sh(returnStdout: true, script: 'env')
  stage('Build & Unit tests') {
    sh './build.sh'
  }
    //
  stage('SonarQube analysis') {
    def scannerHome = tool 'SonarQube Scanner 3.0.3';
    withSonarQubeEnv('SonarQube') {
      if (pullRequest){
        //sh "${scannerHome}/bin/sonar-scanner -X -Dsonar.analysis.mode=preview -Dsonar.github.pullRequest=${ghprbPullId} -Dsonar.github.repository=${org}/${repo} -Dsonar.github.oauth=${GITHUB_ACCESS_TOKEN} -Dsonar.login=${SONARQUBE_ACCESS_TOKEN}"
      } else {
        sh "${scannerHome}/bin/sonar-scanner"
      }
    }
  }
  stage('Deploy & Publish') {
    if (pullRequest){
    } else {
      sh './upload.sh'
    }
    //archiveArtifacts artifacts: 'mobile/platforms/android/build/outputs/apk/*.apk'
  }
  stage('Cleanup') {
    echo 'Cleanup'
  }
}
