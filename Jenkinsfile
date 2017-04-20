#!/usr/bin/env groovy
currentBuild.description = "$branch<br>$message<br>$sha"

def notifySlack(channel, text) {
  sh """
    curl -X POST --data-urlencode 'payload={"channel": "$channel", "username": "instastage", "text": "$text", "icon_emoji": ":ops:"}' https://hooks.slack.com/services/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
  """
}

node {

  stage ('get a ux-prototype') {
    try {
      clean_branch = sh(returnStdout: true, script: "echo $branch | head -c23 | sed 's/_//g' | sed 's/^[^a-z]*//'").trim()
      sh "cd /var/lib/workspace/charts && git pull"
      git credentialsId: '31ad8eb4-8b2b-402b-b006-5574631007d2', url: 'git@github.com:mavenlink/ux-prototypes'
      sh("git checkout $sha")
      sh('`aws ecr get-login --region us-west-2`')
      r = sh(returnStatus: true, script: "aws ecr describe-images --region us-west-2 --repository-name ux-prototypes | grep $sha")
      sh("echo 'Exit code is $r'")
    }
    catch (e) {
      text = "Failed to git clone ux-prototypes code for `$branch` ${env.BUILD_URL}/console"
      notifySlack("#instastage-failures", text)
      sh("exit 1")
    }
  }

  stage ('build an ux-prototypes instastage') {
    if (r == 0) {
      echo "Already built"
      return
    }
    try {
      sh """
      echo $sha
      docker build --pull --build-arg SHA=$sha --build-arg APP=ux-prototypes --build-arg APP_SUBDOMAIN=$clean_branch -t 538244530177.dkr.ecr.us-west-2.amazonaws.com/ux-prototypes:$sha .
      """
    }
    catch (e) {
      text = "Failed to docker build for `$branch` ${env.BUILD_URL}/console"
      notifySlack("#instastage-failures", text)
      sh("exit 1")
    }
  }

  stage ('push to registry') {
    if (r == 0) {
      echo "Already built"
      return
    }
    try {
      sh("docker push 538244530177.dkr.ecr.us-west-2.amazonaws.com/ux-prototypes:$sha")
    }
    catch (e) {
      text = "Failed to push to docker registry for `$branch` ${env.BUILD_URL}/console"
      notifySlack("#instastage-failures", text)
      sh("exit 1")
    }
  }

  stage ('deploy an instastage') {
    try {
      sh """
      helm install --debug --dry-run --set instastage_name=$clean_branch,container.image=538244530177.dkr.ecr.us-west-2.amazonaws.com/ux-prototypes:$sha,env.app_subdomain=$clean_branch,env.app_domain=$app_domain,ttl=$ttl /var/lib/workspace/charts/ux-prototypes
      helm install -n $clean_branch --set container.image=538244530177.dkr.ecr.us-west-2.amazonaws.com/ux-prototypes:$sha,env.app_subdomain=$clean_branch,env.app_domain=$app_domain,ttl=$ttl /var/lib/workspace/charts/ux-prototypes ||
      helm upgrade --set instastage_name=$clean_branch,container.image=538244530177.dkr.ecr.us-west-2.amazonaws.com/ux-prototypes:$sha,env.app_subdomain=$clean_branch,env.app_domain=$app_domain,ttl=$ttl $clean_branch /var/lib/workspace/charts/ux-prototypes
      """
    }
    catch (e) {
      text = "Failed to helm install `$branch` ${env.BUILD_URL}/console"
      notifySlack("#instastage-failures", text)
      sh("exit 1")
    }
  }

