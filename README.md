# AWS Elastic Search Configuration
## Network configuration - VPC:
- You control network access within your VPC using security groups.

„““
Choose internet or VPC access. To enable VPC access, we will use private IP addresses from your VPC, which provides security by default. You control network access within your VPC using security groups.

Placing an Amazon ES domain within a VPC enables secure communication between Amazon ES and other services within the VPC without the need for an internet gateway, NAT device, or VPN connection.

You can optionally add an additional layer of security by applying a restrictive access policy. Internet endpoints are publicly accessible. 

To support VPCs, Amazon ES places an endpoint into either one or two subnets of your VPC.
If you enable zone awareness for your domain, Amazon ES places an endpoint into two subnets.
If you don't enable zone awareness, Amazon ES places an endpoint into only one subnet.

Amazon ES assigns each ENI a private IP address from the IPv4 address range of your subnet.Amazon ES also places an elastic network interface (ENI) in the VPC for each of your data nodes.

The service also assigns a public DNS hostname.
Because the IP addresses might change, you should resolve the domain endpoint periodically so that you can always access the correct data nodes. We recommend that you set the DNS resolution interval to one minute. 
You can't launch your domain within a VPC that uses dedicated tenancy. You must use a VPC with tenancy set to Default.
The Cluster health tab does not include shard information, and the Indices tab is not present at all.

To access the default installation of Kibana for a domain that resides within a VPC, users must have access to the VPC. This process varies by network configuration, but likely involves connecting:
* to a VPN or 
* managed network or 
* using a proxy server.
-> https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-kibana.html#es-kibana-access
-> https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-vpc.html#es-vpc-security
If you try to access the endpoint in a web browser, however, you might find that the request times out. To perform even basic GET requests, your computer must be able to connect to the VPC. This connection often takes the form of an 
* internet gateway, 
* VPN server, or 
* proxy server. 
For details on the various forms it can take, see Scenarios and Examples in theAmazon VPC User Guide.

In addition to this connectivity requirement, VPCs let you manage access to the domain through security groups. For many use cases, this combination of security features is sufficient, and you might feel comfortable applying an open access policy to the domain.
Operating with an open access policy does not mean that anyone on the internet can access the Amazon ES domain. Rather, it means that if a request reaches the Amazon ES domain and the associated security groups permit it, the domain accepts the request without further security checks.
For an additional layer of security, we recommend using access policies that specify IAM users or roles. Applying these policies means that, for the domain to accept a request, the security groups must permit it and it must be signed with valid credentials.
Because security groups already enforce IP-based access policies, you can't apply IP-based access policies to Amazon ES domains that reside within a VPC.

## SETUP AWS ES VPC - AWS Console
- VPC-ID needed
- Reserve IPs
The number of IP addresses that Amazon ES requires depends on the following:
* Number of data nodes in your domain. (Master nodes are not included in the number.)
* Whether you enable zone awareness. If you enable zone awareness, you need only half the number of IP addresses per subnet that you need if you don't enable zone awareness.
When you create the domain, Amazon ES reserves the IP addresses. You can see the network interfaces and their associated IP addresses in the Network Interfaces section of the Amazon EC2 console.
The Description column shows which Amazon ES domain the network interface is associated with.
TIP: We recommend that you create dedicated subnets for the Amazon ES reserved IP addresses.

Amazon ES requires a service-linked role to access your VPC. Amazon ES automatically creates the role when you use the Amazon ES console to create a domain within a VPC - you must have permissions for the iam:CreateServiceLinkedRole action. After Amazon ES creates the role, you can view it (AWSServiceRoleForAmazonElasticsearchService) using the IAM console.

- Access policy: template: „Do not require signing request with IAM credential“
You can use security groups to control which IP addresses can access the domain.

Slow logs are an Elasticsearch feature that Amazon ES exposes through Amazon CloudWatch Logs. These logs are useful for troubleshooting performance issues, but are disabled by default. Elasticsearch disables slow logs by default. After you enable the publishing of slow logs to CloudWatch, you still must specify logging thresholds for each Elasticsearch index.
1. Under Analytics, choose Elasticsearch Service.
2. In the navigation pane, under My domains, choose the domain that you want to update.
3. On the Logs tab, choose Enable for the log that you want.
4. Create a CloudWatch log group, or choose an existing one.
NOTE: If you plan to enable search and index slow logs, we recommend publishing each to its own log group. This separation makes the logs easier to scan.
1. Activate logging of ES: curl -XPUT elasticsearch_domain_endpoint/index/_settings --data '{"index.search.slowlog.threshold.query.warn": "5s","index.search.slowlog.threshold.query.info": "2s"}' -H 'Content-Type: application/json'
NOTE: To test that slow logs are publishing successfully, consider starting with very low values to verify that logs appear in CloudWatch, and then increase the thresholds to more useful levels. -> https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-createupdatedomains.html

## MONITORING
-> https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-managedomains.html

## ACCESS KIBANA
-> http://blog.timmybankers.nl/2014/03/24/Poor-man's-VPN
-> https://www.jeremydaly.com/access-aws-vpc-based-elasticsearch-cluster-locally/#comment-2909

1. Configure Jump-Station: 
    1. Instance in same subnet needed
    2. Extend SG of ES domain -> Explicitly open 443
    3. Connect SG of ES domain to Jump-Station
    4. IAM-Role NOT needed
2. SShuttle Configuration ~/.ssh/config
    1. Host demoesvpc
    2.   HostName ec2-52-205-239-15.compute-1.amazonaws.com
    3.   User ec2-user
    4.   IdentitiesOnly yes
    5.   IdentityFile /Users/mat/Documents/Projekte/devops/aws/playground/kp-us-east-1-playground-instancekey.pem
3. SSHuttle
    1. Examine subnet address to limit request forwarding. 
    2. sshuttle --dns --pidfile=/tmp/sshuttle.pid --remote=demoesvpc 172.31.0.0/16 
4. Check: 
    1. curl -k https://vpc-demo-es-vpc-46bui5ggqnfgo2kigv3buuqe5i.us-east-1.es.amazonaws.com
    2. curl -XGET https://vpc-demo-es-vpc-46bui5ggqnfgo2kigv3buuqe5i.us-east-1.es.amazonaws.com/_cluster/health

## PUSHING DATA

Inside VPC - Connected to Jump-Station:
* curl -XPUT https://vpc-demo-es-vpc-46bui5ggqnfgo2kigv3buuqe5i.us-east-1.es.amazonaws.com/demo-es-vpc/movie/1 -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'


## SETUP AWS ES public - AWS Console
If you select public access, you should secure your domain with an access policy that only allows specific users or IP addresses to access the domain.
„““

-> https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-vpc.html
-> https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-ac.html




## TERRAFORM
Using a [terraform community module](https://github.com/terraform-community-modules/tf_aws_elasticsearch) to setup AWS ES. Check ´variables.tf´ and ´output.tf´ for further configuration remark.

1. ´terraform init´
2. ´terraform plan -out es.out´
3. ´terraform apply "es.out"
4. ´terraform destroy´
