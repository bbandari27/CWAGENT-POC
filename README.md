#check if the agent is installed successfully or not with the below commands on the instances: 

ps -aux | grep agent 
systemctl status amazon-cloudwatch-agent

#check the cwa logs in the below path: 

cat /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log

#check the config file on the instance: 

check in the logs where its reading 

#restart and route the file to the new config file: 

$sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/default -s
