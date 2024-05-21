# HyperVerge
This Readme consists of two sections. 
    1. A terraform to provision a web application in a highly available environment using AWS EC2
    2. A health monitoring system that checks the health of any given API endpoint(s) based on health check configuration provided by the users.

1. Steps to create a web application using terraform.
    a.  Initialise a provider. (AWS in this)
    b.  Create a VPC with a public subnet.
    c.  Create an internet gateway and route table using that gateway id
    d.  Associate the route table to the subnets.
    e.  Create a security group with necessary ingress and egress rules.
    f.  Create an application load balancer, target group and a listener for the same.
    g.  Create a launch configuration for the EC2 instances ASG, as we need high availability.
    h.  Create an ASG using the launch configuration created and attach it to the load balancer target group.
    i.  Write a script to display instance-id, MAC address and IPV4 address and add it to the ASG configuration.
    j.  Create a cloud watch alarm for the ASG for CPU utilisation that triggers scale-in and scale-out.
    k.  Create a scale out and scale in policies.
    l.  Before running the terraform make sure to check the variables.tf file and give values accordingly.


2. Health Monitoring system
We will use Python and AWS services like Lambda, SNS, and CloudWatch for a serverless solution.
    a. Create a Lambda function that takes endpoints and alert_topic as inputs.
    b. The function will try to hit the endpoints and checks the status code of the response.
    c. The message is then sent to the user using the SNS topic.
    d. To make it a run at intervals Set up a CloudWatch Event Rule to trigger the Lambda function at a specified interval (e.g., every 5 minutes).
    e. Deploy the Lambda using AWS console or CLI.
    f. Create an SNS topic and subscribe to the users email or phone number to receive alerts.

sample test input for the function.
{
  "endpoints": [
    {"name": "Google", "url": "https://www.google.com"},
    {"name": "HyperVerge", "url": "https://hyperverge.co/"}
  ],
  "alert_topic": "arn:aws:sns:us-west-2:<aws-account-id>:YourSNSTopic"
}
