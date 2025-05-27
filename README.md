# Step-by-Step AWS Cloud Security Setup with CLI & Terraform

## 1. Root Account Protection

**Manual in AWS Console**
- Enable MFA for root user

## 2. IAM Configuration

### Create an IAM user with admin privileges

```bash
aws iam create-user --user-name AdminUser
aws iam attach-user-policy --user-name AdminUser --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

### Password Policy

```bash
aws iam update-account-password-policy   --minimum-password-length 14   --require-symbols   --require-numbers   --require-uppercase-characters   --require-lowercase-characters   --allow-users-to-change-password   --max-password-age 90   --password-reuse-prevention 5
```

## 3. VPC and Network Setup

```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.1.0/24 --availability-zone us-east-1a
...
```

## 4. Security Groups

```bash
aws ec2 create-security-group --group-name MySecurityGroup --description "Allow SSH and HTTPS" --vpc-id <vpc-id>
```

## 5. Encryption Setup

```bash
aws ec2 run-instances --image-id ami-xxxx --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":30,"Encrypted":true}}]'
```

## 6. Logging & Monitoring

```bash
aws cloudtrail create-trail --name MyTrail --s3-bucket-name my-cloudtrail-logs
aws ec2 create-flow-logs --resource-type VPC --resource-ids <vpc-id> ...
```

## 7. Terraform Example

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "admin_user" {
  name = "AdminUser"
}

resource "aws_iam_user_policy_attachment" "admin_attach" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
```
## 8. Advanced IAM Security Best Practices

### Use IAM Groups

```bash
aws iam create-group --group-name Admins
aws iam add-user-to-group --user-name AdminUser --group-name Admins
```

### Define custom policies with least privilege

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "s3:ListBucket"
      ],
      "Resource": "*"
    }
  ]
}
```

## 9. S3 Bucket Public Access Block & Versioning

```bash
aws s3api put-public-access-block --bucket my-secure-bucket --public-access-block-configuration '{"BlockPublicAcls":true,"IgnorePublicAcls":true,"BlockPublicPolicy":true,"RestrictPublicBuckets":true}'

aws s3api put-bucket-versioning --bucket my-secure-bucket --versioning-configuration Status=Enabled
```

## 10. GuardDuty Setup

```bash
aws guardduty create-detector --enable
```

## 11. AWS Config Rules

```bash
aws configservice put-configuration-recorder --configuration-recorder name=default,roleARN=arn:aws:iam::<account-id>:role/aws-config-role
aws configservice start-configuration-recorder --configuration-recorder-name default
```

## 12. AWS WAF and Shield

- Create a Web ACL for your application load balancer using AWS Console or WAFv2 CLI
- Enable AWS Shield Advanced for enhanced DDoS protection (requires subscription)

## 13. KMS Key for Encryption

```bash
aws kms create-key --description "Key for EBS and S3 encryption"
aws kms enable-key-rotation --key-id <key-id>
```

## 14. CloudWatch Alarms

```bash
aws cloudwatch put-metric-alarm --alarm-name CPUAlarmHigh --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 80 --comparison-operator GreaterThanThreshold --dimensions Name=InstanceId,Value=<instance-id> --evaluation-periods 2 --alarm-actions <sns-topic-arn>
```
