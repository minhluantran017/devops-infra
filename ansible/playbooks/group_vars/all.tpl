# Core system
jenkins_domain: "jenkins.${DOMAIN}"
artifactory_domain: "artifactory.${DOMAIN}"
jumphost_domain: "jump.${DOMAIN}"

# Monitoring system
influxdb_domain: "dashboard.${DOMAIN}"
grafana_domain: "dashboard.${DOMAIN}"

prometheus_domain: "metrics.${DOMAIN}"
is_alertmanager: "${IS_ALERTMANAGER}"
slack_domain: "slack.${DOMAIN}"

# Supporting system
ldap_domain: "auth.${DOMAIN}"
sec_tools_domain: "sec-tools.${DOMAIN}"