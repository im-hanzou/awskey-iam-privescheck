<h1>AWS IAM Privescheck</h1>
<p>This Bash script allows you to interact with AWS Identity and Access Management (IAM) and EC2 services to check AWS credentials and permissions related to EC2 instances. It provides the following functionalities:</p>

<ol>
<li><strong>Use AWS Credentials:</strong> Set up your AWS credentials using <code>aws configure</code>.</li>
<li><strong>Check EC2 Permission:</strong> Determine whether you have permission to create EC2 instances.</li>
<li><strong>List Roles for EC2 Instances:</strong> View a list of IAM roles associated with EC2 instances.</li>
<li><strong>List Attached Policies:</strong> Retrieve attached IAM policies for a specified IAM role.</li>
</ol>

<h2>Prerequisites</h2>
<p>Before using this script, make sure you have the following prerequisites installed:</p>
<ul>
<li><a href="https://aws.amazon.com/cli/">AWS CLI </a>: Ensure you have the AWS Command Line Interface installed and configured with your AWS credentials.</li>
<li><a href="https://stedolan.github.io/jq/">jq </a>: This script utilizes <code>jq</code> to parse JSON output from AWS CLI commands. Please install it before running the script.</li>
</ul>

<h2>Usage</h2>
<p>To use the script, follow these steps:</p>
<ol>
<li>Clone this repository to your local machine:</li>
<code>git clone https://github.com/im-hanzou/awskey-iam-privescheck.git</code>
<li>Navigate to the script's directory:</li>
<code>cd awskey-iam-privescheck</code>
<li>Make the script executable:</li>
<code>chmod +x awskey-privesc.sh</code>
<li>Run the script:</li>
<code>./awskey-privesc.sh</code>
</ol>

<h2>Reference</h2>
<p>Here is the reference and the next steps for exploitation.</p>
<li>https://infosecwriteups.com/exploiting-fine-grained-aws-iam-permissions-for-total-cloud-compromise-a-real-world-example-part-5a2f3de4be08</li>
<li>https://infosecwriteups.com/exploiting-aws-iam-permissions-for-total-cloud-compromise-a-real-world-example-part-2-2-f27e4b57454e</li>

<h2>Disclaimer</h2>
<p>This script interacts with AWS services, and improper use can result in unintended consequences. Use it responsibly, and ensure that your AWS credentials have appropriate permissions for the actions you perform.</p>
