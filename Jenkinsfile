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
      sh "cd /var/lib/workspace/charts && git pull && git checkout remove-init-for-faster-restart"
      git credentialsId: '31ad8eb4-8b2b-402b-b006-5574631007d2', url: 'git@github.com:mavenlink/mavenlink.git'
      sh("git checkout $sha")
      sh('`aws ecr get-login --region us-west-2`')
      r = sh(returnStatus: true, script: "aws ecr describe-images --region us-west-2 --repository-name mavenlink | grep $sha")
      sh("echo 'Exit code is $r'")
    }
    catch (e) {
      text = "Failed to git clone bigmaven code for `$branch` ${env.BUILD_URL}/console"
      notifySlack("#instastage-failures", text)
      sh("exit 1")
    }
  }

  stage ('build an instastage') {
    if (r == 0) {
      echo "Already built"
      return
    }
    try {
      if (clean_branch =~ /^(staging0[1-8])/) {
        source_db = "template_$clean_branch"
      }
      sh """
      echo $sha
      docker build --pull --build-arg SHA=$sha --build-arg APP=bigmaven --build-arg APP_SUBDOMAIN=$clean_branch -t 538244530177.dkr.ecr.us-west-2.amazonaws.com/mavenlink:$sha .
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
      sh("docker push 538244530177.dkr.ecr.us-west-2.amazonaws.com/mavenlink:$sha")
    }
    catch (e) {
      text = "Failed to push to docker registry for `$branch` ${env.BUILD_URL}/console"
      notifySlack("#instastage-failures", text)
      sh("exit 1")
    }
  }

  stage ('deploy an instastage') {
    try {
      if (clean_branch == 'master' || clean_branch =~ /^(staging|rc).*/) {
        sh """
        helm install --debug --dry-run --set instastage_name=$clean_branch,container.image=538244530177.dkr.ecr.us-west-2.amazonaws.com/mavenlink:$sha,env.app_subdomain=$clean_branch,env.app_domain=$app_domain,source_db=$source_db /var/lib/workspace/charts/instastage
        helm install -n $clean_branch --set container.image=538244530177.dkr.ecr.us-west-2.amazonaws.com/mavenlink:$sha,env.app_subdomain=$clean_branch,env.app_domain=$app_domain,source_db=$source_db /var/lib/workspace/charts/instastage ||
        helm upgrade --set instastage_name=$clean_branch,container.image=538244530177.dkr.ecr.us-west-2.amazonaws.com/mavenlink:$sha,env.app_subdomain=$clean_branch,env.app_domain=$app_domain,source_db=$source_db $clean_branch /var/lib/workspace/charts/instastage
        """
      } else {
        sh """
        helm install --debug --dry-run --set instastage_name=$clean_branch,container.image=538244530177.dkr.ecr.us-west-2.amazonaws.com/mavenlink:$sha,env.app_subdomain=$clean_branch,env.app_domain=$app_domain,ttl=$ttl,source_db=$source_db /var/lib/workspace/charts/instastage
        helm install -n $clean_branch --set container.image=538244530177.dkr.ecr.us-west-2.amazonaws.com/mavenlink:$sha,env.app_subdomain=$clean_branch,env.app_domain=$app_domain,ttl=$ttl,source_db=$source_db /var/lib/workspace/charts/instastage ||
        helm upgrade --set instastage_name=$clean_branch,container.image=538244530177.dkr.ecr.us-west-2.amazonaws.com/mavenlink:$sha,env.app_subdomain=$clean_branch,env.app_domain=$app_domain,ttl=$ttl,source_db=$source_db $clean_branch /var/lib/workspace/charts/instastage
        """
      }
    }
    catch (e) {
      text = "Failed to helm install `$branch` ${env.BUILD_URL}/console"
      notifySlack("#instastage-failures", text)
      sh("exit 1")
    }
  }

  stage ('check availability') {
    try {
      sh """
      NEXT_WAIT_TIME=0
      until \$(curl --silent https://${clean_branch}.instastage.cash/version.txt | grep -q '${sha}'); do
        sleep 30
        NEXT_WAIT_TIME=\$((\$NEXT_WAIT_TIME+1))
        if [ \$NEXT_WAIT_TIME -eq 60 ]; then
          exit 1;
        fi
      done
      """
      r = sh(returnStatus: true, script: "aws ecr describe-images --region us-west-2 --repository-name mavenlink | grep $sha")
      if (r == 0) {
        text = "The branch `$branch` - `$sha` has been deployed to: https://${clean_branch}.instastage.cash"
        notifySlack("#instastage", text)
        currentBuild.description = "<a href=\"https://${clean_branch}.instastage.cash\">$branch</a><br><a href=\"${commiturl}\">$message</a><br>$sha"
      } else {
        raise "failed availability check"
      }
    }
    catch (e) {
      text = "The pod for `$branch` failed the health checks. ${env.BUILD_URL}/console"
      notifySlack("#instastage-failures", text)
      sh("exit 1")
    }
  }
}

