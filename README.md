Prerequisites

•	Active Azure subscription
•	Azure Devops subscription
•	Installed kubectl & terraform

Steps to customize image-

•	Clone the ghost github repo
•	Clone any (casper) theme github repo inside of the themes folder
•	Create the config.production.json file which will be used for adding custom setup like database, storage and mail settings.
•	Create a Dockerfile
•	Build and push your new image to ACR using AKS. 

Why use Dockerfile and ACR? 

It allows us to customize the ghost blog to include any theme and also the ability to comment any article in the blog. 
Also it allows version control and release instead of just taking the latest (or fixed) tag.  

Why AKS- 

AKS provides an easy to use container orchestration mechanism. 
It has auto upgrades, self-healing and auto-scaling using HPA. 
AKS cluster distributes resources such as nodes and storage across logical sections of underlying Azure infrastructure. Using availability zones physically separates nodes from other nodes deployed to different availability zones. AKS clusters deployed with multiple availability zones configured across a cluster provide a higher level of availability to protect against a hardware failure or a planned maintenance event.
 
Application Insights (AI)-

Using AI we gain insights into application performance, usage, and errors, enabling proactive optimization and diagnostics.
Log Analytics Workspace-
Centrally collect, analyse, and visualize logs for our applications and infrastructure.
Infrastructure Deployment-
We use Terraform for provisioning of our infrastructure. 

CICD-

Our code is in GitHub and we use Azure DevOps to automatically build and release our code.

